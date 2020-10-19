//
//  Type.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/19.
//

import UIKit

struct Type {
    
    static let shared = Type()
    
    let pesco       = "pesco"
    let vegan       = "vegan"
    let lacto       = "lacto"
    let ovo         = "ovo"
    let fruitarian  = "fruitarian"
    let lacto_ovo   = "lacto_ovo"
    let flexitarian = "flexitarian"
    let pollo       = "pollo"
    
    func typeColor(typeName: String) -> UIColor {
        switch typeName {
        case pesco      : return .vridge_typePesco
        case vegan      : return .vridge_typeVegan
        case lacto      : return .vridge_typeLacto
        case ovo        : return .vridge_typeOvo
        case lacto_ovo  : return .vridge_typeLactoOvo
        case flexitarian: return .vridge_typeFlexitarian
        case pollo      : return .vridge_typePollo
        default         : return .blue
        }
    }
}
