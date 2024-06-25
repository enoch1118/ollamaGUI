#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `ScrollView` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         ScrollView {
    ///             Text("Item")
    ///         }
    ///         .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UIScrollView
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
    ///         ScrollView {
    ///             Text("Item")
    ///         }
    ///         .introspect(.scrollView, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UIScrollView
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
    ///         ScrollView {
    ///             Text("Item")
    ///         }
    ///         .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///             print(type(of: $0)) // NSScrollView
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
    ///         ScrollView {
    ///             Text("Item")
    ///         }
    ///         .introspect(.scrollView, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UIScrollView
    ///         }
    ///     }
    /// }
    /// ```
    public struct ScrollViewType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == ScrollViewType {
        static var scrollView: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<ScrollViewType, UIScrollView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<ScrollViewType, UIScrollView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<ScrollViewType, UIScrollView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<ScrollViewType, NSScrollView> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
