#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Stepper` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var selection = 5
    ///
    ///     var body: some View {
    ///         Stepper("Select a number", value: $selection, in: 0...10)
    ///             .introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIStepper
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
    ///     @State var selection = 5
    ///
    ///     var body: some View {
    ///         Stepper("Select a number", value: $selection, in: 0...10)
    ///             .introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // NSStepper
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct StepperType: IntrospectableViewType {}

    #if !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == StepperType {
            static var stepper: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<StepperType, UIStepper> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<StepperType, NSStepper> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
