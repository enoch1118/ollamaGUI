//
//  StringHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation

extension String{
    var removeFirstBreakLine:String {
        if self.starts(with: "\n") {
            return self.replacing("\n", with: "",maxReplacements: 1)
        }
        return self
    }
}
