#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `TextEditor` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextEditor(text: $text)
    ///             .introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UITextView
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// Not available.
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextEditor(text: $text)
    ///             .introspect(.textEditor, on: .macOS(.v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSTextView
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
    ///         TextEditor(text: $text)
    ///             .introspect(.textEditor, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UITextView
    ///             }
    ///     }
    /// }
    /// ```
    public struct TextEditorType: IntrospectableViewType {}

    #if !os(tvOS)
        public extension IntrospectableViewType where Self == TextEditorType {
            static var textEditor: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<TextEditorType, UITextView> {
                @available(*, unavailable, message: "TextEditor isn't available on iOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<TextEditorType, UITextView> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<TextEditorType, NSTextView> {
                @available(*, unavailable, message: "TextEditor isn't available on macOS 10.15")
                static let v10_15 = Self.unavailable()
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
