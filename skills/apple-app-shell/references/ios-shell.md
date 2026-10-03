# iPhone tabs and iPad sidebar

Build separate UIKit shells around the same feature flows. A scene delegate retains the shell coordinator and assigns its root controller to `UIWindow`. Prefer a fixed layout decision when the scene connects; if the product supports changing the shell while running, explicitly transfer selection and navigation state.

## iPhone

Create one `UINavigationController` per top-level tab and retain the corresponding feature flows. Set each tab's title, symbol, and root controller once. A feature event pushes through its own navigation controller. A command that selects a different top-level section can select its tab and, if that command means “show the section home,” pop that stack to root. A normal tab tap need not discard its stack.

```swift
let tabs = UITabBarController()
tabs.viewControllers = sections.map { section in
    let navigation = UINavigationController(rootViewController: makeRoot(for: section))
    navigation.tabBarItem = UITabBarItem(
        title: section.title,
        image: UIImage(systemName: section.symbol),
        selectedImage: nil
    )
    navigation.delegate = navigationObserver
    return navigation
}
```

Set `hidesBottomBarWhenPushed` on a detail controller before pushing it. If the deployment target and OS behavior require additional tab-bar synchronization, derive visibility from the *actual* stack: the root is visible, a pushed detail is hidden. Update during a transition when animation needs it, confirm in `navigationController(_:didShow:animated:)`, and synchronize after tab changes; use the appropriate available UIKit API for the OS version. Do not store a separate Boolean that can drift from the stack. Keep feature-specific navigation-bar preferences with the feature's root or flow.

For example, an iOS 18+ navigation delegate can confirm the final state with:

```swift
func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
) {
    guard #available(iOS 18.0, *) else { return }
    let isAtRoot = navigationController.viewControllers.first === viewController
    navigationController.tabBarController?.setTabBarHidden(!isAtRoot, animated: animated)
}
```

If a particular iOS release still leaves the tab bar's view out of sync, isolate the additional compatibility adjustment in this same shell policy and test it on that release. Feature flows should only mark their pushed controllers as details.

## iPad

Use a `UISplitViewController(style: .doubleColumn)` with a primary sidebar and a secondary `UINavigationController`. Define a sidebar selection type distinct from detail destinations. The sidebar owns the visible row state; the shell owns the selected destination and secondary stack.

```swift
enum SidebarSelection: Hashable {
    case library
    case collection
    case settings(SettingsPane)
}

func select(_ destination: SidebarSelection) {
    selectedDestination = destination
    sidebar.select(destination, animated: true)
    secondaryNavigation.setViewControllers(
        [makeRoot(for: destination)],
        animated: false
    )
    splitView.show(.secondary)
}

func openDetail(_ controller: UIViewController) {
    secondaryNavigation.pushViewController(controller, animated: true)
    splitView.show(.secondary)
    // The sidebar selection remains the owner of this detail's context.
}
```

Settings panes can be rows in the sidebar. Selecting a pane replaces the secondary root with that pane; a deeper settings editor pushes on the secondary navigation controller. Keep pane identity and labels in the Settings feature so the phone and Mac presentations can use the same domain choice without sharing their entire UI.

The sidebar must keep selection visible when focus moves into detail, when its view reappears, and when a route is selected programmatically. If using a custom animated highlight, keep it separate from cell selection: synchronize accessibility `.selected` traits, recompute its frame after layout and reloads, clip its horizontal bounds to the visible safe area, start a new animation from the current presentation frame, cancel the previous animator, and honor Reduce Motion. These are interaction requirements, not reasons to make the sidebar own the app's navigation.

The highlight movement can live inside a `UITableViewController` with `highlightView`, `selectionAnimator`, and `hasPositionedHighlight` properties:

```swift
func moveHighlight(to indexPath: IndexPath, animated: Bool) {
    tableView.layoutIfNeeded()
    var row = tableView.rectForRow(at: indexPath)
    let visible = tableView.safeAreaLayoutGuide.layoutFrame
    let left = max(row.minX, visible.minX)
    let right = min(row.maxX, visible.maxX)
    row.origin.x = left
    row.size.width = max(0, right - left)
    let target = row.insetBy(dx: 8, dy: 3)

    guard hasPositionedHighlight else {
        highlightView.frame = target
        hasPositionedHighlight = true
        return
    }
    if let current = highlightView.layer.presentation()?.frame {
        highlightView.frame = current
    }
    selectionAnimator?.stopAnimation(true)
    guard animated, !UIAccessibility.isReduceMotionEnabled else {
        highlightView.frame = target
        return
    }
    let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.85) {
        self.highlightView.frame = target
    }
    animator.addCompletion { [weak self] _ in self?.selectionAnimator = nil }
    selectionAnimator = animator
    animator.startAnimation()
}
```

Set the highlight view behind cells, disable its user interaction and accessibility exposure, update visible cells' `.selected` traits when the selected destination changes, and reapply the highlight after a table reload or layout pass. Keep these visuals optional; ordinary UIKit selection is fine when no custom highlight is needed.

If a full-screen detail needs the sidebar hidden, save the split view's previous display mode, display-mode button visibility, and gesture preference before changing them. Restore those exact values once the detail has truly left the navigation stack, including a completed back gesture or a programmatic stack replacement. Keep this policy in the shell or a focused presentation object, not in the feature's model.

## Verify the behavior

Exercise: switching tabs preserves the intended stacks; a command selecting a section returns to its root when specified; pushing and popping a detail updates the tab bar; selecting an iPad sidebar row replaces the right root; pushing a detail retains the selected row; programmatic selection updates the row; a cancelled interactive back gesture leaves state unchanged; completing the gesture releases a temporary flow and restores any temporarily hidden sidebar controls. Test accessibility selection and Reduce Motion for a custom sidebar highlight.
