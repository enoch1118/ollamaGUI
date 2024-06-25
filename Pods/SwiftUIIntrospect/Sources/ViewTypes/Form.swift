#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `Form` type in SwiftUI.
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
    ///         .introspect(.form, on: .iOS(.v13, .v14, .v15)) {
    ///             print(type(of: $0)) // UITableView
    ///         }
    ///         .introspect(.form, on: .iOS(.v16, .v17)) {
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
    ///         .introspect(.form, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // UITableView
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// Not available.
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
    ///         .introspect(.form, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // UICollectionView
    ///         }
    ///     }
    /// }
    /// ```
    public struct FormType: IntrospectableViewType {}

    #if !os(macOS)
        public extension IntrospectableViewType where Self == FormType {
            static var form: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<FormType, UITableView> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
            }

            public extension iOSViewVersion<FormType, UICollectionView> {
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension tvOSViewVersion<FormType, UITableView> {
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<FormType, UICollectionView> {
                static let v1 = Self(for: .v1)
            }
        #endif
    #endif
#endif
