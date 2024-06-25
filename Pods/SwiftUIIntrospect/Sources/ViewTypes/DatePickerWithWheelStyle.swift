#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `DatePicker` type in SwiftUI, with `.wheel` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.wheel)
    ///             .introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIDatePicker
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
    /// Not available.
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.wheel)
    ///             .introspect(.datePicker(style: .wheel), on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UIDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    public struct DatePickerWithWheelStyleType: IntrospectableViewType {
        public enum Style {
            case wheel
        }
    }

    #if !os(tvOS) && !os(macOS)
        public extension IntrospectableViewType where Self == DatePickerWithWheelStyleType {
            static func datePicker(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<DatePickerWithWheelStyleType, UIDatePicker> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<DatePickerWithWheelStyleType, UIDatePicker> {
                static let v1 = Self(for: .v1)
            }
        #endif
    #endif
#endif
