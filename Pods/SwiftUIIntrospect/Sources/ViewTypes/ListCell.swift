#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of a `List` cell type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         List {
    ///             ForEach(1...3, id: \.self) { int in
    ///                 Text("Item \(int)")
    ///                     .introspect(.listCell, on: .iOS(.v13, .v14, .v15)) {
    ///                         print(type(of: $0)) // UITableViewCell
    ///                     }
    ///                     .introspect(.listCell, on: .iOS(.v16, .v17)) {
    ///                         print(type(of: $0)) // UICollectionViewCell
    ///                     }
    ///             }
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
    ///             ForEach(1...3, id: \.self) { int in
    ///                 Text("Item \(int)")
    ///                     .introspect(.listCell, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                         print(type(of: $0)) // UITableViewCell
    ///                     }
    ///             }
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
    ///             ForEach(1...3, id: \.self) { int in
    ///                 Text("Item \(int)")
    ///                     .introspect(.listCell, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
    ///                         print(type(of: $0)) // NSTableCellView
    ///                     }
    ///             }
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
    ///             ForEach(1...3, id: \.self) { int in
    ///                 Text("Item \(int)")
    ///                     .introspect(.listCell, on: .visionOS(.v1)) {
    ///                         print(type(of: $0)) // UICollectionViewCell
    ///                     }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    public struct ListCellType: IntrospectableViewType {
        public var scope: IntrospectionScope { .ancestor }
    }

    public extension IntrospectableViewType where Self == ListCellType {
        static var listCell: Self { .init() }
    }

    #if canImport(UIKit)
        public extension iOSViewVersion<ListCellType, UITableViewCell> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
        }

        public extension iOSViewVersion<ListCellType, UICollectionViewCell> {
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<ListCellType, UITableViewCell> {
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension visionOSViewVersion<ListCellType, UICollectionViewCell> {
            static let v1 = Self(for: .v1)
        }

    #elseif canImport(AppKit)
        public extension macOSViewVersion<ListCellType, NSTableCellView> {
            static let v10_15 = Self(for: .v10_15)
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }
    #endif
#endif
