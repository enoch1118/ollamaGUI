//
//  FloatingWindow.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/17/24.
//

import Foundation
import SwiftUI

/// - Custom View Modifier for Floating Window (Like Sheets)
extension View {
    @ViewBuilder
    func floatingWindow<Content: View>(
        position: Binding<CGPoint>,
        show: Binding<Bool>,
        floating: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(FloatingWindowModifier(windowView: content,
                                        position: position, show: show,
                                        floating: floating))
    }
}

/// - Floating Window Modifier
private struct FloatingWindowModifier<WindowView: View>: ViewModifier {
    var windowView: () -> WindowView
    @Binding var position: CGPoint
    @Binding var show: Bool
    @Binding var floating: Bool
    @State var view: WindowView?
    @State private var panel: FloatingPanelHelper<WindowView>?

    func body(content: Content) -> some View {
        content
            /// - Updating Position Dynamically
            .onChange(of: position) { _, newValue in
                panel?.updatePosition(newValue)
            }
            .onChange(of: floating) { _, newValue in
                panel?.updateFloading(newValue)
            }
            .onChange(of: show) { _, newValue in
                /// - When Ever Show is Toggled Presenting Floating Panel
                if newValue {
                    view = windowView()
                    panel = FloatingPanelHelper(
                        position: $position,
                        show: $show,
                        floating: $floating,
                        content: {
                            view!
                        }
                    )

                    /// - To Place panel at center by default
                    panel?.center()
                    panel?.updatePositionWithoutAnimation(position)
                    panel?.orderFront(nil)
                    panel?.makeKey()
                } else {
                    /// - Removing Panel
                    panel?.close()
                }
            }
            .background(content: {
                if let view = view {
                    ViewUpdater(content: view, panel: $panel)
                }

                EmptyView()
            })
    }
}

private struct ViewUpdater<Content: View>: NSViewRepresentable {
    var content: Content
    @Binding var panel: FloatingPanelHelper<Content>?
    func makeNSView(context _: Context) -> NSView {
        /// - Simply Return Empty View
        return NSView()
    }

    func updateNSView(_: NSView, context _: Context) {
        /// - Update Panel's Hosting View
        if let hostingView = panel?.contentView as? NSHostingView<Content> {
            hostingView.rootView = content
        }
    }
}

/// - Creating Floating Panel Using NSPanel
private class FloatingPanelHelper<Content: View>: NSWindow {
    @Binding private var show: Bool
    @Binding private var floating: Bool
    @Binding private var position: CGPoint

    init(
        position: Binding<CGPoint>,
        show: Binding<Bool>,
        floating: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        /// - Need to Implement it's super initializer
        /// - Your Custom Window Mask's Goes Here
        _show = show
        _position = position
        _floating = floating
        super.init(
            contentRect: .zero,
            styleMask: [.resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        /// - Setting Up Window Properties
        level = .normal /// - Hiding Out TitleBar
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        backgroundColor = .clear
        hasShadow = true
        isMovableByWindowBackground = true
        isReleasedWhenClosed = false

        /// - Removing all traffic buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        /// - Adding Content View
        /// - Adding SwiftUI View With the Help of HostingView
        contentView = NSHostingView(rootView: content())
    }

    override var canBecomeKey: Bool {
        true
    }

    /// - Live Position Update when the window is dragged across the screen
    override func mouseDragged(with _: NSEvent) {
        position = frame.origin
    }

    /// - Updating Position With Animation
    func updatePosition(_ to: CGPoint) {
        let fittingSize = frame.size
        setFrame(
            .init(origin: to, size: fittingSize),
            display: true,
            animate: true
        )
    }

    func updateFloading(_ to: Bool) {
        if to {
            level = .floating
        } else {
            level = .normal
        }
    }

    /// - Updating Position Without Animation
    func updatePositionWithoutAnimation(_ to: CGPoint) {
        setFrameOrigin(to)
    }

    /// - Dynamic Updation when the panel is closed
    override func close() {
        print("close")
        super.close()
        show = false
    }
}
