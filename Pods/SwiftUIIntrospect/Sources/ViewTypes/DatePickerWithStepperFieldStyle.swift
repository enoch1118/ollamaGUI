#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `DatePicker` type in SwiftUI, with `.stepperField` style.
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
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.stepperField)
    ///             .introspect(.datePicker(style: .stepperField), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct DatePickerWithStepperFieldStyleType: IntrospectableViewType {
        public enum Style {
            case stepperField
        }
    }

    #if !os(iOS) && !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == DatePickerWithStepperFieldStyleType {
            static func datePicker(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
            public extension macOSViewVersion<DatePickerWithStepperFieldStyleType, NSDatePicker> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
