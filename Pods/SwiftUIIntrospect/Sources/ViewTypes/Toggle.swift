#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Toggle` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         Toggle("Toggle", isOn: $isOn)
    ///             .introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UISwitch
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
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         Toggle("Toggle", isOn: $isOn)
    ///             .introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSButton
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct ToggleType: IntrospectableViewType {}

    #if !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == ToggleType {
            static var toggle: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<ToggleType, UISwitch> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<ToggleType, NSButton> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
