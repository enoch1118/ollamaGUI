#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `List` type in SwiftUI, with `.bordered` style.
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
    ///     var body: some View {
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .listStyle(.bordered)
    ///         .introspect(.list(style: .bordered), on: .macOS(.v12, .v13, .v14)) {
    ///             print(type(of: $0)) // NSTableView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// Not available.
    public struct ListWithBorderedStyleType: IntrospectableViewType {
        public enum Style {
            case bordered
        }
    }

    #if !os(iOS) && !os(tvOS) && !os(visionOS)
        public extension IntrospectableViewType where Self == ListWithBorderedStyleType {
            static func list(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
            public extension macOSViewVersion<ListWithBorderedStyleType, NSTableView> {
                @available(*, unavailable, message: ".listStyle(.insetGrouped) isn't available on macOS 10.15")
                static let v10_15 = Self.unavailable()
                @available(*, unavailable, message: ".listStyle(.insetGrouped) isn't available on macOS 11")
                static let v11 = Self.unavailable()
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
