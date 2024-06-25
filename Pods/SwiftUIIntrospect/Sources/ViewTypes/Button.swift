#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Button` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// Not available.
    ///
    /// ### tvOS
    ///
    /// Not available.
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Button("Action", action: {})
    ///             .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSButton
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct ButtonType: IntrospectableViewType {}

    #if !os(iOS) && !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == ButtonType {
            static var button: Self { .init() }
        }

        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
            public extension macOSViewVersion<ButtonType, NSButton> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
