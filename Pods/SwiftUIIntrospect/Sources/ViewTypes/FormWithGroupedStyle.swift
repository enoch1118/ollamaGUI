#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Form` type in SwiftUI, with `.grouped` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Form {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .formStyle(.grouped)
    ///         .introspect(.form(style: .grouped), on: .iOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UICollectionView
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
    ///         Form {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .formStyle(.grouped)
    ///         .introspect(.form(style: .grouped), on: .tvOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UITableView
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
    ///         Form {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .formStyle(.grouped)
    ///         .introspect(.form(style: .grouped), on: .macOS(.v13, .v14)) {
    ///             print(type(of: $0)) // NSScrollView
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
    ///         Form {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .formStyle(.grouped)
    ///         .introspect(.form(style: .grouped), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
    ///     }
    /// }
    /// ```
    public struct FormWithGroupedStyleType: IntrospectableViewType {
        public enum Style {
            case grouped
        }
    }

    public extension IntrospectableViewType where Self == FormWithGroupedStyleType {
        static func form(style _: Self.Style) -> Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<FormWithGroupedStyleType, UITableView> {
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on iOS 15")
            static let v15 = Self.unavailable()
        }

        public extension iOSViewVersion<FormWithGroupedStyleType, UICollectionView> {
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<FormWithGroupedStyleType, UITableView> {
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 13")
            static let v13 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 14")
            static let v14 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on tvOS 15")
            static let v15 = Self.unavailable()
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<FormWithGroupedStyleType, UICollectionView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<FormWithGroupedStyleType, NSScrollView> {
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 10.15")
            static let v10_15 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 11")
            static let v11 = Self.unavailable()
            @available(*, unavailable, message: ".formStyle(.grouped) isn't available on macOS 12")
            static let v12 = Self.unavailable()
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
