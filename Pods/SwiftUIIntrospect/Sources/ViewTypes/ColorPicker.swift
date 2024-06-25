#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `ColorPicker` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var color = Color.red
    ///
    ///     var body: some View {
    ///         ColorPicker("Pick a color", selection: $color)
    ///             .introspect(.colorPicker, on: .iOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIColorPicker
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
    ///     @State var color = Color.red
    ///
    ///     var body: some View {
    ///         ColorPicker("Pick a color", selection: $color)
    ///             .introspect(.colorPicker, on: .macOS(.v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSColorPicker
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var color = Color.red
    ///
    ///     var body: some View {
    ///         ColorPicker("Pick a color", selection: $color)
    ///             .introspect(.colorPicker, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // UIColorPicker
    ///             }
    ///     }
    /// }
    /// ```
    public struct ColorPickerType: IntrospectableViewType {}

    #if !os(tvOS)
        public extension IntrospectableViewType where Self == ColorPickerType {
            static var colorPicker: Self { .init() }
        }

        #if canImport(UIKit)
            @available(iOS 14, *)
            public extension iOSViewVersion<ColorPickerType, UIColorWell> {
                @available(*, unavailable, message: "ColorPicker isn't available on iOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            @available(iOS 14, *)
            public extension visionOSViewVersion<ColorPickerType, UIColorWell> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit)
            @available(macOS 11, *)
            public extension macOSViewVersion<ColorPickerType, NSColorWell> {
                @available(*, unavailable, message: "ColorPicker isn't available on macOS 10.15")
                static let v10_15 = Self.unavailable()
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
