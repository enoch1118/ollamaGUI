//
//  RoleEnum.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Foundation

enum RoleEnum:String,Codable{
    case user
    case assistant
}

extension RoleEnum {
    var value:String{
        String(describing: self)
    }
}
