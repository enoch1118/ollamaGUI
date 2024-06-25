#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `TextField` type in SwiftUI, with `.vertical` axis.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextField("Text Field", text: $text, axis: .vertical)
    ///             .introspect(.textField(axis: .vertical), on: .iOS(.v16, .v17)) {
    ///                 print(type(of: $0)) // UITextView
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextField("Text Field", text: $text, axis: .vertical)
    ///             .introspect(.textField(axis: .vertical), on: .tvOS(.v16, .v17)) {
    ///                 print(type(of: $0)) // UITextField
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextField("Text Field", text: $text, axis: .vertical)
    ///             .introspect(.textField(axis: .vertical), on: .macOS(.v13, .v14)) {
    ///                 print(type(of: $0)) // NSTextField
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextField("Text Field", text: $text, axis: .vertical)
    ///             .introspect(.textField(axis: .vertical), on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UITextView
    ///             }
    ///     }
    /// }
    /// ```
    public struct TextFieldWithVerticalAxisType: IntrospectableViewType {
        public enum Axis {
            case vertical
        }
    }

    public extension IntrospectableViewType where Self == TextFieldWithVerticalAxisType {
        static func textField(axis _: Self.Axis) -> Self { .init() }
    }

    // MARK: SwiftUI.TextField(..., axis: .vertical) - iOS

    #if canImport(UIKit)
        public extension iOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<TextFieldWithVerticalAxisType, UITextField> {
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 15")
            static let v15 = Self.unavailable()

            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<TextFieldWithVerticalAxisType, NSTextField> {
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 10.15")
            static let v10_15 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 11")
            static let v11 = Self.unavailable()
            @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 12")
            static let v12 = Self.unavailable()

            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
