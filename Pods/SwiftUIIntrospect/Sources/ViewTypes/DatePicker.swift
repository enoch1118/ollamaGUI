#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `DatePicker` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .introspect(.datePicker, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
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
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .introspect(.datePicker, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
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
    ///             .introspect(.datePicker, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UIDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    public struct DatePickerType: IntrospectableViewType {}

    #if !os(tvOS)
        public extension IntrospectableViewType where Self == DatePickerType {
            static var datePicker: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<DatePickerType, UIDatePicker> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<DatePickerType, UIDatePicker> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<DatePickerType, NSDatePicker> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
