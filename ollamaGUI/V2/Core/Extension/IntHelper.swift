//
//  IntHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Foundation


extension Int{
    var getSize:String{
        let div = 1024.0
        if self > Int(pow(div,3)){
            let val = pow(div,3)
            return "\((Double(self) / val).roundToDecimal(2))GB"
        }
        if self > Int(pow(div,2)){
            let val = pow(div,3)
            return "\((Double(self) / val).roundToDecimal(2))MB"
        }
        if self > Int(pow(div,1)){
            let val = pow(div,2)
            return "\((Double(self) / val).roundToDecimal(2))KB"
        }
        if self > Int(pow(div,0)){
            let val = pow(div,1)
            return "\((Double(self) / val).roundToDecimal(2))B"
        }
        
        return "cal error"
    }
}


extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
