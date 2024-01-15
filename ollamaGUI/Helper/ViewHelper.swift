//
//  ViewHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import Foundation
import SwiftUI

struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { VStack { 
                placeHolder.padding(.leading,5)
                Spacer()
            } }
            content
        }
    }
}

extension View {
    func placeHolder<T: View>(_ holder: T, show: Bool) -> some View {
        modifier(PlaceHolder(placeHolder: holder, show: show))
    }
}
