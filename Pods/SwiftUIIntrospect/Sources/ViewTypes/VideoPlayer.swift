#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `VideoPlayer` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
    ///             .introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // AVPlayerViewController
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### tvOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
    ///             .introspect(.videoPlayer, on: .tvOS(.v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // AVPlayerViewController
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### macOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
    ///             .introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14)) {
    ///                 print(type(of: $0)) // AVPlayerView
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ### visionOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
    ///             .introspect(.videoPlayer, on: .visionOS(.v1)) {
    ///                 print(type(of: $0)) // AVPlayerViewController
    ///             }
    ///     }
    /// }
    /// ```
    public struct VideoPlayerType: IntrospectableViewType {}

    #if canImport(AVKit)
        import AVKit

        public extension IntrospectableViewType where Self == VideoPlayerType {
            static var videoPlayer: Self { .init() }
        }

        #if canImport(UIKit)
            public extension iOSViewVersion<VideoPlayerType, AVPlayerViewController> {
                @available(*, unavailable, message: "VideoPlayer isn't available on iOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension tvOSViewVersion<VideoPlayerType, AVPlayerViewController> {
                @available(*, unavailable, message: "VideoPlayer isn't available on tvOS 13")
                static let v13 = Self.unavailable()
                static let v14 = Self(for: .v14)
                static let v15 = Self(for: .v15)
                static let v16 = Self(for: .v16)
                static let v17 = Self(for: .v17)
            }

            public extension visionOSViewVersion<VideoPlayerType, AVPlayerViewController> {
                static let v1 = Self(for: .v1)
            }

        #elseif canImport(AppKit)
            public extension macOSViewVersion<VideoPlayerType, AVPlayerView> {
                @available(*, unavailable, message: "VideoPlayer isn't available on macOS 10.15")
                static let v10_15 = Self(for: .v10_15)
                static let v11 = Self(for: .v11)
                static let v12 = Self(for: .v12)
                static let v13 = Self(for: .v13)
                static let v14 = Self(for: .v14)
            }
        #endif
    #endif
#endif
