#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Picker` type in SwiftUI, with `.segmented` style.
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
    ///         .pickerStyle(.segmented)
    ///         .introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UISegmentedControl
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
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
    ///         .pickerStyle(.segmented)
    ///         .introspect(.picker(style: .segmented), on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UISegmentedControl
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
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
    ///         .pickerStyle(.segmented)
    ///         .introspect(.picker(style: .segmented), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///             print(type(of: $0)) // NSSegmentedControl
    ///         }
    ///     }
    /// }
    /// ```
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
    ///         .pickerStyle(.segmented)
    ///         .introspect(.picker(style: .segmented), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UISegmentedControl
    ///         }
    ///     }
    /// }
    /// ```
    public struct PickerWithSegmentedStyleType: IntrospectableViewType {
        public enum Style {
            case segmented
        }
    }

    public extension IntrospectableViewType where Self == PickerWithSegmentedStyleType {
        static func picker(style _: Self.Style) -> Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<PickerWithSegmentedStyleType, UISegmentedControl> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<PickerWithSegmentedStyleType, UISegmentedControl> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<PickerWithSegmentedStyleType, UISegmentedControl> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<PickerWithSegmentedStyleType, NSSegmentedControl> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
