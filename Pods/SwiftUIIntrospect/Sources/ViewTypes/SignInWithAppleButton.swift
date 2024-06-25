#if !os(watchOS)
    import SwiftUI

    /// An abstract representation of the `SignInWithAppleButton` type in SwiftUI.
    ///
    /// ### iOS
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         SignInWithAppleButton(.signIn) { request in
    ///             request.requestedScopes = [.fullName, .email]
    ///         } onCompletion: { result in
    ///             // do something with result
    ///         }
    ///         .introspect(.signInWithAppleButton, on: .iOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // ASAuthorizationAppleIDButton
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
    ///         SignInWithAppleButton(.signIn) { request in
    ///             request.requestedScopes = [.fullName, .email]
    ///         } onCompletion: { result in
    ///             // do something with result
    ///         }
    ///         .introspect(.signInWithAppleButton, on: .tvOS(.v14, .v15, .v16, .v17)) {
    ///             print(type(of: $0)) // ASAuthorizationAppleIDButton
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
    ///         SignInWithAppleButton(.signIn) { request in
    ///             request.requestedScopes = [.fullName, .email]
    ///         } onCompletion: { result in
    ///             // do something with result
    ///         }
    ///         .introspect(.signInWithAppleButton, on: .macOS(.v11, .v12, .v13, .v14),) {
    ///             print(type(of: $0)) // ASAuthorizationAppleIDButton
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
    ///         SignInWithAppleButton(.signIn) { request in
    ///             request.requestedScopes = [.fullName, .email]
    ///         } onCompletion: { result in
    ///             // do something with result
    ///         }
    ///         .introspect(.signInWithAppleButton, on: .visionOS(.v1)) {
    ///             print(type(of: $0)) // ASAuthorizationAppleIDButton
    ///         }
    ///     }
    /// }
    /// ```
    public struct SignInWithAppleButtonType: IntrospectableViewType {}

    #if canImport(AuthenticationServices)
        import AuthenticationServices

        public extension IntrospectableViewType where Self == SignInWithAppleButtonType {
            static var signInWithAppleButton: Self { .init() }
        }

        public extension iOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
            @available(*, unavailable, message: "SignInWithAppleButton isn't available on iOS 13")
            static let v13 = Self.unavailable()
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension tvOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
            @available(*, unavailable, message: "SignInWithAppleButton isn't available on tvOS 13")
            static let v13 = Self.unavailable()
            static let v14 = Self(for: .v14)
            static let v15 = Self(for: .v15)
            static let v16 = Self(for: .v16)
            static let v17 = Self(for: .v17)
        }

        public extension macOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
            @available(*, unavailable, message: "SignInWithAppleButton isn't available on macOS 10.15")
            static let v10_15 = Self.unavailable()
            static let v11 = Self(for: .v11)
            static let v12 = Self(for: .v12)
            static let v13 = Self(for: .v13)
            static let v14 = Self(for: .v14)
        }

        public extension visionOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
            static let v1 = Self(for: .v1)
        }
    #endif
#endif
