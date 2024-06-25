#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `List` type in SwiftUI, with `.sidebar` style.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .listStyle(.sidebar)
    ///         .introspect(.list(style: .sidebar), on: .iOS(.v14, .v15)) {
    ///             print(type(of: $0)) // UITableView
    ///         }
    ///         .introspect(.list(style: .sidebar), on: .iOS(.v16, .v17)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
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
    ///     var body: some View {
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .listStyle(.sidebar)
    ///         .introspect(.list(style: .sidebar), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///             print(type(of: $0)) // NSTableView
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
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .listStyle(.sidebar)
    ///         .introspect(.list(style: .sidebar), on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
    ///     }
    /// }
    /// ```
    public struct ListWithSidebarStyleType: IntrospectableViewType {
        public enum Style {
            case sidebar
        }
    }

    #if !os(tvOS)
        public extension IntrospectableViewType where Self == ListWithSidebarStyleType {
            static func list(style _: Self.Style) -> Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<ListWithSidebarStyleType, UITableView> {
                @available(*, unavailable, message: ".listStyle(.sidebar) isn't available on iOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
            }

            public extension iOSViewVersion<ListWithSidebarStyleType, UICollectionView> {
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<ListWithSidebarStyleType, UICollectionView> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<ListWithSidebarStyleType, NSTableView> {
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
