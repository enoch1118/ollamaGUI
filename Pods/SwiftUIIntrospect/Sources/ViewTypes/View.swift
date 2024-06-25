#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of a generic SwiftUI view type.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         HStack {
    ///             Image(systemName: "scribble")
    ///             Text("Some text")
    ///         }
    ///         .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // some subclass of UIView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         HStack {
    ///             Image(systemName: "scribble")
    ///             Text("Some text")
    ///         }
    ///         .introspect(.view, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // some subclass of UIView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         HStack {
    ///             Image(systemName: "scribble")
    ///             Text("Some text")
    ///         }
    ///         .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///             print(type(of: $0)) // some subclass of NSView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         HStack {
    ///             Image(systemName: "scribble")
    ///             Text("Some text")
    ///         }
    ///         .introspect(.view, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // some subclass of UIView
    ///         }
    ///     }
    /// }
    /// ```
    public struct ViewType: IntrospectableViewType {}

    public extension IntrospectableViewType where Self == ViewType {
        static var view: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<ViewType, UIView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<ViewType, UIView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<ViewType, UIView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<ViewType, NSView> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
