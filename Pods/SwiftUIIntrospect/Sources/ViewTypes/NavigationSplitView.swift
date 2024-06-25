#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `NavigationSplitView` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationSplitView {
    ///             Text("Root")
    ///         } detail: {
    ///             Text("Detail")
    ///         }
    ///         .introspect(.navigationSplitView, on: .iOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UISplitViewController
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
    ///         NavigationSplitView {
    ///             Text("Root")
    ///         } detail: {
    ///             Text("Detail")
    ///         }
    ///         .introspect(.navigationSplitView, on: .tvOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UINavigationController
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
    ///         NavigationSplitView {
    ///             Text("Root")
    ///         } detail: {
    ///             Text("Detail")
    ///         }
    ///         .introspect(.navigationSplitView, on: .macOS(.v13, .v14)) {
    ///             print(type(of: $0)) // NSSplitView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationSplitView {
    ///             Text("Root")
    ///         } detail: {
    ///             Text("Detail")
    ///         }
    ///         .introspect(.navigationSplitView, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UISplitViewController
    ///         }
    ///     }
    /// }
    /// ```
    public struct NavigationSplitViewType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == NavigationSplitViewType {
        static var navigationSplitView: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<NavigationSplitViewType, UISplitViewController> {
            @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UISplitViewController> {
                .default.withAncestorSelector(\.splitViewController)
            }
        }

        public extension tvOSViewVersion<NavigationSplitViewType, UINavigationController> {
            @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UINavigationController> {
                .default.withAncestorSelector(\.navigationController)
            }
        }

        extension visionOSViewVersion<NavigationSplitViewType, UISplitViewController> {
            public static let v1 = Self(for: .v1, selector: selector)

            private static var selector: IntrospectionSelector<UISplitViewController> {
                .default.withAncestorSelector(\.splitViewController)
            }
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<NavigationSplitViewType, NSSplitView> {
            @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 10.15")
            static let v10_15 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 11")
            static let v11 = Self.unavailable()
            @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 12")
            static let v12 = Self.unavailable()

            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
