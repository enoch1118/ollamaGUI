#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `TextField` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         TextField("Text Field", text: $text)
    ///             .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UITextField
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
    ///         TextField("Text Field", text: $text)
    ///             .introspect(.textField, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
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
    ///         TextField("Text Field", text: $text)
    ///             .introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
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
    ///         TextField("Text Field", text: $text)
    ///             .introspect(.textField, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UITextField
    ///             }
    ///     }
    /// }
    /// ```
    public struct TextFieldType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == TextFieldType {
        static var textField: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<TextFieldType, UITextField> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<TextFieldType, UITextField> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<TextFieldType, UITextField> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<TextFieldType, NSTextField> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
