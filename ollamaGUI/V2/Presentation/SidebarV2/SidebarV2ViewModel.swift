//
//  SidebarV2ViewModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 2/18/24.
//

import Foundation

class SidebarV2ViewModel: ObservableObject {
    var bloc: NetworkBloc!
    @Published var state: NetworkState = .initState
    @Published var showSetting = false
    
    func ignite(container: DIContainer) {
        bloc = .init(container: container)
        bloc.stateSubject.assign(to: &$state)
    }
    
    
    func check() {
        bloc.addEvent(event: .checkNetwork)
    }
    
}
