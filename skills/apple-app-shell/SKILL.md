---
name: apple-app-shell
description: Design or implement iPhone, iPad, and macOS app navigation with UIKit or AppKit shells and selectively embedded SwiftUI components or simple screens. Use for new native projects and for untangling navigation coordinators in mixed-framework apps.
---

# Native navigation with selected SwiftUI screens

On iPhone and iPad, UIKit owns the scene, tabs or split layout, navigation controllers, and transitions between features. On macOS, AppKit owns windows, menus, toolbars, and split views. Build selected components and simple screens in SwiftUI and embed them with `UIHostingController`, `UIHostingConfiguration`, or `NSHostingController`; keep screens in UIKit or AppKit when that better fits their behavior. A self-contained SwiftUI sheet may manage its own local navigation. Follow the project's existing conventions and deployment target when they differ from the examples.

## Choose ownership before writing routes

- The app coordinator owns the scene or window's root controller, top-level sections, and navigation between features. Keep it unaware of a feature's editors, persistence, and screen construction details.
- A feature flow owns its screens, local navigation, and the state needed for that flow. It receives a navigation controller or presentation context and sends only genuine cross-feature requests to the app coordinator.
- A screen reports user intent through a small typed event or focused closures. It does not need to know which tab, navigation controller, or device layout presents it.
- A model or service owns loading, saving, and cache updates. A coordinator may connect completion to a transition, but should not become the implementation of the edit operation.

Keep app destinations and feature destinations separate. Introduce an app-wide route type only when callers actually need to request navigation across features, deep links, or restoration. Avoid putting every detail screen into one global enum. Prefer shared feature intent and state where appropriate, while each platform decides how to present it.

## Choose a shell for each platform

| Platform | Native shell | Settings entry and presentation |
| --- | --- | --- |
| iPhone | `UITabBarController` with one `UINavigationController` per tab | A Settings tab shows a root list and pushes detail screens. |
| iPad | `UISplitViewController` with a persistent primary sidebar and a secondary navigation controller | Settings panes are sidebar destinations; selecting one replaces the secondary root, while deeper settings screens push onto it. |
| macOS | `NSWindow` with an AppKit root such as `NSSplitViewController` | The application menu opens or focuses a separate Settings window; its toolbar selects panes. |

Keep a stable selection separate from temporary detail destinations. For iPad, selecting another sidebar row replaces the secondary root and synchronizes the row highlight; opening a detail pushes without changing that selection. If a detail temporarily hides the sidebar, restore the previous split-view controls and display mode when that detail actually ends. On iPhone, keep each tab's stack alive; distinguish a deliberate command to return to a section root from an ordinary tap on the already selected tab.

Use one settings domain model or pane identifier where the content overlaps, but build platform-specific containers and navigation. Reuse individual settings sections where they fit, not an entire phone list as the iPad or Mac interface. Read [references/ios-shell.md](references/ios-shell.md) for tab/sidebar behavior and [references/macos-settings.md](references/macos-settings.md) for the desktop window and settings menu. Read [references/example.md](references/example.md) for a small SwiftUI event-to-UIKit-flow example.

## Arrange the project

For a new project, start with this top-level structure and create directories as their responsibilities appear:

```text
App/
Components/
Config/
Errors/
Extensions/
Features/
PreviewData/
Resources/
```

- `App`: entry point, scene setup, UIKit app shell, and cross-feature navigation. Keep feature screens and edit operations out of it.
- `Components`: UI pieces reused by multiple features. Keep a component used by only one feature inside that feature.
- `Config`: app-wide configuration and settings definitions.
- `Errors`: error types shared across features. Keep feature-specific errors with their feature.
- `Extensions`: small, broadly reusable extensions; avoid using it as a catch-all for feature logic.
- `Features`: one directory per user-facing feature. Place its flow coordinator, screens, state, and services together; add subdirectories only when the feature benefits from them.
- `PreviewData`: sample data and fixtures for previews or development, kept separate from production resources.
- `Resources`: asset catalogs, localization, and other bundled resources.

For example, `App/Mobile/` and `App/Desktop/` can hold platform shells while `App/Navigation/` holds genuine cross-feature contracts. `Features/Library/Navigation/` owns the Library flow; `Features/Settings/iOS/` and `Features/Settings/macOS/` hold their distinct settings containers. The exact subdirectory names are optional; the ownership boundary is the important part.

## Implement the boundary

1. Create and retain one app coordinator per iOS scene or macOS window. Let it retain feature flows for as long as their navigation state must survive. Let the platform framework own the visible navigation container.
2. Create selected SwiftUI screens in the feature flow, passing state and event callbacks explicitly. Use weak captures when a hosted view's callback points back to its owner.
3. Push or present the resulting controller through the flow's platform context. Put title, toolbar visibility, and presentation style at the boundary where the controller is created.
4. Define completion by the actual operation or navigation removal. A SwiftUI `onDisappear` can also occur when another screen covers the current one; it is not a general signal that a flow ended. For interactive back gestures, inspect the completed navigation stack after the transition rather than assuming `willShow` means a pop succeeded.
5. Check state ownership when a tab changes, a split view replaces its detail, a settings window closes, or a scene closes. Release a temporary flow when its root leaves the stack, and keep state only for the intended lifetime.

When refactoring an existing large coordinator, map its responsibilities first. Move one feature's screen creation and local transitions into a feature flow, verify its tab/split and back behavior, then repeat. Extract UIKit layout behavior separately from feature behavior; splitting a large file into extensions alone does not change ownership.
