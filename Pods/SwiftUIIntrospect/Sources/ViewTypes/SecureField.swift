#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `SecureField` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var text = "Lorem ipsum"
    ///
    ///     var body: some View {
    ///         SecureField("Secure Field", text: $text)
    ///             .introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UISecureField
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
    ///         SecureField("Secure Field", text: $text)
    ///             .introspect(.secureField, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UISecureField
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
    ///         SecureField("Secure Field", text: $text)
    ///             .introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSSecureField
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
    ///         SecureField("Secure Field", text: $text)
    ///             .introspect(.secureField, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UISecureField
    ///             }
    ///     }
    /// }
    /// ```
    public struct SecureFieldType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == SecureFieldType {
        static var secureField: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<SecureFieldType, UITextField> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<SecureFieldType, UITextField> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<SecureFieldType, UITextField> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<SecureFieldType, NSTextField> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
