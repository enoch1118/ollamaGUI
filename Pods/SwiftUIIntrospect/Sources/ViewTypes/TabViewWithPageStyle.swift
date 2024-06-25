#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `TabView` type in SwiftUI, with `.page` style.
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
    ///         .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UICollectionView
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
    ///         .introspect(.tabView(style: .page), on: .tvOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UICollectionView
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
    ///         .introspect(.tabView(style: .page), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
    ///     }
    /// }
    /// ```
    public struct TabViewWithPageStyleType: IntrospectableViewType {
        public enum Style {
            case page
        }
    }

    #if !os(macOS)
        public extension IntrospectableViewType where Self == TabViewWithPageStyleType {
            static func tabView(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
                @available(*, unavailable, message: ".tabViewStyle(.page) isn't available on iOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension tvOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
                @available(*, unavailable, message: ".tabViewStyle(.page) isn't available on tvOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
                static let v1 = Self(for: .v1)
            }
        #endif
    #endif
#endif
