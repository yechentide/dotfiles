# macOS window and Settings presentation

Use an AppKit application or window delegate to create and retain the main `NSWindow` and its coordinator. An `NSSplitViewController` can own a primary sidebar and detail controller; SwiftUI content can live in `NSHostingController` instances inside those AppKit containers. For example, create a sidebar item with `NSSplitViewItem(sidebarWithViewController:)`, add a detail item with `NSSplitViewItem(viewController:)`, and replace the detail controller's hosted content when the user selects a feature. Keep this main-window navigation separate from the Settings window. Release or stop window-scoped work when the main window closes.

## Settings entry and window

Place Settings in the application menu with the Command-comma shortcut. Retain a presenter with the app delegate or another app-lifetime owner. It creates a settings window controller on first use, then focuses the existing window on later requests. A preference-style toolbar selects panes; the controller changes the title, selected item, and hosted pane together.

```swift
#if os(macOS)
import AppKit
import SwiftUI

private enum SettingsPane: String, CaseIterable {
    case general
    case account

    var title: String {
        switch self {
        case .general: "General"
        case .account: "Account"
        }
    }

    var symbol: String {
        switch self {
        case .general: "gearshape"
        case .account: "person.crop.circle"
        }
    }

    var identifier: NSToolbarItem.Identifier {
        NSToolbarItem.Identifier("Settings.\(rawValue)")
    }
}

private struct SettingsPaneView: View {
    let pane: SettingsPane

    var body: some View {
        Text(pane.title).frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@MainActor
final class SettingsWindowController: NSWindowController, NSToolbarDelegate {
    private let hostingController: NSHostingController<AnyView>
    private var selectedPane: SettingsPane = .general

    init() {
        let hosting = NSHostingController(
            rootView: AnyView(SettingsPaneView(pane: .general))
        )
        self.hostingController = hosting

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 620, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        super.init(window: window)
        window.contentViewController = hosting
        window.title = selectedPane.title
        window.toolbarStyle = .preference
        window.tabbingMode = .disallowed
        window.isReleasedWhenClosed = false
        let toolbar = NSToolbar(identifier: "SettingsToolbar")
        toolbar.delegate = self
        toolbar.selectedItemIdentifier = selectedPane.identifier
        window.toolbar = toolbar
        window.center()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable")
    }

    @objc private func selectPane(_ sender: NSToolbarItem) {
        guard let pane = SettingsPane.allCases.first(where: {
            $0.identifier == sender.itemIdentifier
        }) else { return }

        selectedPane = pane
        window?.title = pane.title
        window?.toolbar?.selectedItemIdentifier = pane.identifier
        hostingController.rootView = AnyView(SettingsPaneView(pane: pane))
    }

    func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        SettingsPane.allCases.map(\.identifier)
    }

    func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        SettingsPane.allCases.map(\.identifier)
    }

    func toolbarSelectableItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
        SettingsPane.allCases.map(\.identifier)
    }

    func toolbar(
        _: NSToolbar,
        itemForItemIdentifier identifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar _: Bool
    ) -> NSToolbarItem? {
        guard let pane = SettingsPane.allCases.first(where: {
            $0.identifier == identifier
        }) else { return nil }

        let item = NSToolbarItem(itemIdentifier: identifier)
        item.label = pane.title
        item.image = NSImage(systemSymbolName: pane.symbol, accessibilityDescription: pane.title)
        item.target = self
        item.action = #selector(selectPane(_:))
        return item
    }
}

@MainActor
final class SettingsWindowPresenter: NSObject {
    private var controller: SettingsWindowController?

    @objc func show(_ sender: Any?) {
        if controller == nil {
            controller = SettingsWindowController()
        }
        NSApp.activate(ignoringOtherApps: true)
        controller?.showWindow(sender)
        controller?.window?.makeKeyAndOrderFront(sender)
    }
}

@MainActor
func makeSettingsMenuItem(target: SettingsWindowPresenter) -> NSMenuItem {
    let item = NSMenuItem(
        title: "Settings…",
        action: #selector(SettingsWindowPresenter.show(_:)),
        keyEquivalent: ","
    )
    item.target = target
    item.keyEquivalentModifierMask = [.command]
    return item
}
#endif
```

Add the menu item to the application submenu. The pane view above stands in for platform-appropriate settings content. Share settings values or small sections with iOS where useful, while allowing the Mac pane layout, menus, and window sizing to be native to macOS. If a pane's title or icon changes with observable state, refresh the corresponding toolbar item and window title.

Verify that the menu shortcut opens Settings, repeated requests focus the same window, closing and reopening it preserves or intentionally resets pane selection, selecting a toolbar pane updates content and title, and closing the main window stops its window-scoped work.
