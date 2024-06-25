#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `NavigationStack` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationStack {
    ///             Text("Root")
    ///         }
    ///         .introspect(.navigationStack, on: .iOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UINavigationController
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
    ///         NavigationStack {
    ///             Text("Root")
    ///         }
    ///         .introspect(.navigationStack, on: .tvOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UINavigationController
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// Not available.
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationStack {
    ///             Text("Root")
    ///         }
    ///         .introspect(.navigationStack, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UINavigationController
    ///         }
    ///     }
    /// }
    /// ```
    public struct NavigationStackType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == NavigationStackType {
        static var navigationStack: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<NavigationStackType, UINavigationController> {
            @available(*, unavailable, message: "NavigationStack isn't available on iOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "NavigationStack isn't available on iOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "NavigationStack isn't available on iOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UINavigationController> {
                .default.withAncestorSelector(\.navigationController)
            }
        }

        public extension tvOSViewVersion<NavigationStackType, UINavigationController> {
            @available(*, unavailable, message: "NavigationStack isn't available on tvOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "NavigationStack isn't available on tvOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "NavigationStack isn't available on tvOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UINavigationController> {
                .default.withAncestorSelector(\.navigationController)
            }
        }

        extension visionOSViewVersion<NavigationStackType, UINavigationController> {
            public static let v1 = Self(for: .v1, selector: selector)

            private static var selector: IntrospectionSelector<UINavigationController> {
                .default.withAncestorSelector(\.navigationController)
            }
        }
    #endif
#endif
