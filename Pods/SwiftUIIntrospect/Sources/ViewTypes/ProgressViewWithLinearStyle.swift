#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `ProgressView` type in SwiftUI, with `.linear` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         ProgressView(value: 0.5)
    ///             .progressViewStyle(.linear)
    ///             .introspect(.progressView(style: .linear), on: .iOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIProgressView
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         ProgressView(value: 0.5)
    ///             .progressViewStyle(.linear)
    ///             .introspect(.progressView(style: .linear), on: .tvOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIProgressView
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         ProgressView(value: 0.5)
    ///             .progressViewStyle(.linear)
    ///             .introspect(.progressView(style: .linear), on: .macOS(.v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSProgressIndicator
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         ProgressView(value: 0.5)
    ///             .progressViewStyle(.linear)
    ///             .introspect(.progressView(style: .linear), on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UIProgressView
    ///             }
    ///     }
    /// }
    /// ```
    public struct ProgressViewWithLinearStyleType: IntrospectableViewType {
        public enum Style {
            case linear
        }
    }

    public extension IntrospectableViewType where Self == ProgressViewWithLinearStyleType {
        static func progressView(style _: Self.Style) -> Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<ProgressViewWithLinearStyleType, UIProgressView> {
            @available(*, unavailable, message: ".progressViewStyle(.linear) isn't available on iOS 13")
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<ProgressViewWithLinearStyleType, UIProgressView> {
            @available(*, unavailable, message: ".progressViewStyle(.linear) isn't available on tvOS 13")
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<ProgressViewWithLinearStyleType, UIProgressView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<ProgressViewWithLinearStyleType, NSProgressIndicator> {
            @available(*, unavailable, message: ".progressViewStyle(.linear) isn't available on macOS 10.15")
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
