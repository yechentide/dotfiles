# Example: UIKit shell, SwiftUI feature screens

This example shows a two-tab iOS app. UIKit owns the tabs and the navigation stacks. The Library flow builds its own SwiftUI screens and handles their events. The scene delegate retains `AppCoordinator` and assigns `makeRootViewController()` to its window.

```swift
import SwiftUI
import UIKit

@MainActor
final class AppCoordinator {
    private var libraryFlow: LibraryFlowCoordinator?

    func makeRootViewController() -> UIViewController {
        let libraryNavigation = UINavigationController()
        let libraryFlow = LibraryFlowCoordinator(navigationController: libraryNavigation)
        libraryFlow.start()
        self.libraryFlow = libraryFlow

        libraryNavigation.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: nil
        )

        let settings = UIHostingController(rootView: SettingsScreen())
        settings.title = "Settings"
        let settingsNavigation = UINavigationController(rootViewController: settings)
        settingsNavigation.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil
        )

        let tabs = UITabBarController()
        tabs.viewControllers = [libraryNavigation, settingsNavigation]
        return tabs
    }
}

private enum LibraryEvent {
    case openItem(id: String)
}

@MainActor
private final class LibraryFlowCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let screen = LibraryScreen { [weak self] event in
            self?.handle(event)
        }
        let controller = UIHostingController(rootView: screen)
        controller.title = "Library"
        navigationController.setViewControllers([controller], animated: false)
    }

    private func handle(_ event: LibraryEvent) {
        switch event {
        case let .openItem(id):
            let controller = UIHostingController(rootView: ItemScreen(itemID: id))
            controller.title = "Item"
            controller.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(controller, animated: true)
        }
    }
}

private struct LibraryScreen: View {
    let onEvent: (LibraryEvent) -> Void

    var body: some View {
        Button("Open item") {
            onEvent(.openItem(id: "sample"))
        }
    }
}

private struct ItemScreen: View {
    let itemID: String

    var body: some View {
        Text("Item \(itemID)")
    }
}

private struct SettingsScreen: View {
    var body: some View {
        Text("Settings")
    }
}
```

The sample data is deliberately small. In a real feature, inject its state or model into `LibraryScreen`, and keep loading or saving in that model or a service. If a detail screen later opens an editor, add that transition to `LibraryFlowCoordinator`; the app coordinator still only knows that Library is a top-level section. For an iPad split view, construct a different UIKit shell and let the same feature events select or push a secondary controller as appropriate.
