#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the page control type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         TabView {
    ///             Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
    ///             Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
    ///         }
    ///         .tabViewStyle(.page(indexDisplayMode: .always))
    ///         .introspect(.pageControl, on: .iOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UIPageControl
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
    ///             Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
    ///             Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
    ///         }
    ///         .tabViewStyle(.page(indexDisplayMode: .always))
    ///         .introspect(.pageControl, on: .tvOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UIPageControl
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
    ///         TabView {
    ///             Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
    ///             Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
    ///         }
    ///         .tabViewStyle(.page(indexDisplayMode: .always))
    ///         .introspect(.pageControl, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UIPageControl
    ///         }
    ///     }
    /// }
    /// ```
    public struct PageControlType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == PageControlType {
        static var pageControl: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<PageControlType, UIPageControl> {
            @available(*, unavailable, message: ".tabViewStyle(.page) isn't available on iOS 13")
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<PageControlType, UIPageControl> {
            @available(*, unavailable, message: ".tabViewStyle(.page) isn't available on tvOS 13")
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<PageControlType, UIPageControl> {
            static let v1 = Self(for: .v1)
        }
    #endif
#endif
