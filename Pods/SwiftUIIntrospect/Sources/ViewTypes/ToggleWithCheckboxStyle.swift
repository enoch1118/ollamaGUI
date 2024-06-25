#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Toggle` type in SwiftUI, with `.checkbox` style.
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
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         Toggle("Checkbox", isOn: $isOn)
    ///             .toggleStyle(.checkbox)
    ///             .introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSButton
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct ToggleWithCheckboxStyleType: IntrospectableViewType {
        public enum Style {
            case checkbox
        }
    }

    #if !os(iOS) && !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == ToggleWithCheckboxStyleType {
            static func toggle(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
            public extension macOSViewVersion<ToggleWithCheckboxStyleType, NSButton> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
