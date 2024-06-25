#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `NavigationView` type in SwiftUI, with `.columns` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationView {
    ///             Text("Root")
    ///         }
    ///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
    ///         .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
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
    ///         NavigationView {
    ///             Text("Root")
    ///         }
    ///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
    ///         .introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
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
    ///         NavigationView {
    ///             Text("Root")
    ///         }
    ///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
    ///         .introspect(.navigationView(style: .columns), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
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
    ///         NavigationView {
    ///             Text("Root")
    ///         }
    ///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
    ///         .introspect(.navigationView(style: .columns), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UISplitViewController
    ///         }
    ///     }
    /// }
    /// ```
    public struct NavigationViewWithColumnsStyleType: IntrospectableViewType {
        public enum Style {
            case columns
        }
    }

    public extension IntrospectableViewType where Self == NavigationViewWithColumnsStyleType {
        static func navigationView(style _: Self.Style) -> Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<NavigationViewWithColumnsStyleType, UISplitViewController> {
            static let v13 = Self(for: .v13, selector: selector)
            static let v14 = Self(for: .v14, selector: selector)
            static let v15 = Self(for: .v15, selector: selector)
            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UISplitViewController> {
                .default.withAncestorSelector(\.splitViewController)
            }
        }

        public extension tvOSViewVersion<NavigationViewWithColumnsStyleType, UINavigationController> {
            static let v13 = Self(for: .v13, selector: selector)
            static let v14 = Self(for: .v14, selector: selector)
            static let v15 = Self(for: .v15, selector: selector)
            static let v16 = Self(for: .v16, selector: selector)
            static let v17 = Self(for: .v17, selector: selector)

            private static var selector: IntrospectionSelector<UINavigationController> {
                .default.withAncestorSelector(\.navigationController)
            }
        }

        extension visionOSViewVersion<NavigationViewWithColumnsStyleType, UISplitViewController> {
            public static let v1 = Self(for: .v1, selector: selector)

            private static var selector: IntrospectionSelector<UISplitViewController> {
                .default.withAncestorSelector(\.splitViewController)
            }
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<NavigationViewWithColumnsStyleType, NSSplitView> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
