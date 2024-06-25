#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `DatePicker` type in SwiftUI, with `.graphical` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.graphical)
    ///             .introspect(.datePicker(style: .graphical), on: .iOS(.v14, .v15, .v16, .v17)) {
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
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.graphical)
    ///             .introspect(.datePicker(style: .graphical), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .datePickerStyle(.graphical)
    ///             .introspect(.datePicker(style: .graphical), on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UIDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    public struct DatePickerWithGraphicalStyleType: IntrospectableViewType {
        public enum Style {
            case graphical
        }
    }

    #if !os(tvOS)
        public extension IntrospectableViewType where Self == DatePickerWithGraphicalStyleType {
            static func datePicker(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<DatePickerWithGraphicalStyleType, UIDatePicker> {
                @available(*, unavailable, message: ".datePickerStyle(.graphical) isn't available on iOS 13")
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<DatePickerWithGraphicalStyleType, UIDatePicker> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            public extension macOSViewVersion<DatePickerWithGraphicalStyleType, NSDatePicker> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
