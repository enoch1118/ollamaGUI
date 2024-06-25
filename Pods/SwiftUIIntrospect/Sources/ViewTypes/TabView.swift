#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `TabView` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         TabView {
    ///             Text("Tab 1").tabItem { Text("Tab 1") }
    ///             Text("Tab 2").tabItem { Text("Tab 2") }
    ///         }
    ///         .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UITabBarController
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         TabView {
    ///             Text("Tab 1").tabItem { Text("Tab 1") }
    ///             Text("Tab 2").tabItem { Text("Tab 2") }
    ///         }
    ///         .introspect(.tabView, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UITabBarController
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         TabView {
    ///             Text("Tab 1").tabItem { Text("Tab 1") }
    ///             Text("Tab 2").tabItem { Text("Tab 2") }
    ///         }
    ///         .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///             print(type(of: $0)) // NSTabView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct TabViewType: IntrospectableViewType {}

    #if !os(visionOS)
        public extension IntrospectableViewType where Self == TabViewType {
            static var tabView: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<TabViewType, UITabBarController> {
                static let v13 = Self(for: .v13, selector: selector)
                static let v14 = Self(for: .v14, selector: selector)
                static let v15 = Self(for: .v15, selector: selector)
                static let v16 = Self(for: .v16, selector: selector)
                static let v17 = Self(for: .v17, selector: selector)

                private static var selector: IntrospectionSelector<UITabBarController> {
                    .default.withAncestorSelector(\.tabBarController)
                }
            }

            public extension tvOSViewVersion<TabViewType, UITabBarController> {
                static let v13 = Self(for: .v13, selector: selector)
                static let v14 = Self(for: .v14, selector: selector)
                static let v15 = Self(for: .v15, selector: selector)
                static let v16 = Self(for: .v16, selector: selector)
                static let v17 = Self(for: .v17, selector: selector)

                private static var selector: IntrospectionSelector<UITabBarController> {
                    .default.withAncestorSelector(\.tabBarController)
                }
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<TabViewType, NSTabView> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
