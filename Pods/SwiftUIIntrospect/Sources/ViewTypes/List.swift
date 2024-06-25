#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `List` type in SwiftUI.
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
    ///         .introspect(.list, on: .iOS(.v13, .v14, .v15)) {
    ///             print(type(of: $0)) // UITableView
    ///         }
    ///         .introspect(.list, on: .iOS(.v16, .v17)) {
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
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .introspect(.list, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
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
    ///         List {
    ///             Text("Item 1")
    ///             Text("Item 2")
    ///             Text("Item 3")
    ///         }
    ///         .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
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
    ///         .introspect(.list, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
    ///     }
    /// }
    /// ```
    public struct ListType: IntrospectableViewType {
        public enum Style {
            case plain
        }
    }

    public extension IntrospectableViewType where Self == ListType {
        static var list: Self { .init() }
        static func list(style _: Self.Style) -> Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<ListType, UITableView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
        }

        public extension iOSViewVersion<ListType, UICollectionView> {
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<ListType, UITableView> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<ListType, UICollectionView> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<ListType, NSTableView> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
