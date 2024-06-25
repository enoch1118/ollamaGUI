#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Picker` type in SwiftUI, with `.wheel` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var selection = "1"
    ///
    ///     var body: some View {
    ///         Picker("Pick a number", selection: $selection) {
    ///             Text("1").tag("1")
    ///             Text("2").tag("2")
    ///             Text("3").tag("3")
    ///         }
    ///         .pickerStyle(.wheel)
    ///         .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UIPickerView
    ///         }
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
    /// Not available.
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var selection = "1"
    ///
    ///     var body: some View {
    ///         Picker("Pick a number", selection: $selection) {
    ///             Text("1").tag("1")
    ///             Text("2").tag("2")
    ///             Text("3").tag("3")
    ///         }
    ///         .pickerStyle(.wheel)
    ///         .introspect(.picker(style: .wheel), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UIPickerView
    ///         }
    ///     }
    /// }
    /// ```
    public struct PickerWithWheelStyleType: IntrospectableViewType {
        public enum Style {
            case wheel
        }
    }

    #if !os(tvOS) && !os(macOS)
        public extension IntrospectableViewType where Self == PickerWithWheelStyleType {
            static func picker(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<PickerWithWheelStyleType, UIPickerView> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<PickerWithWheelStyleType, UIPickerView> {
                static let v1 = Self(for: .v1)
            }
        #endif
    #endif
#endif
