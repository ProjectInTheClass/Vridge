//
//  VegieType.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/17.
//

import UIKit

enum VegieTypes: Int, CaseIterable {
    case vegan
    case lacto
    case ovo
    case lacto_ovo
    case pesco
    case pollo
    case fruitarian
    case flexitarian
    
    
    var typeName: String {
        switch self {
        case .vegan: return "vegan"
        case .lacto: return "lacto"
        case .ovo: return "ovo"
        case .lacto_ovo: return "lacto_ovo"
        case .pesco: return "pesco"
        case .pollo: return "pollo"
        case .fruitarian: return "fruitarian"
        case .flexitarian: return "flexitarian"
        }
    }
    
    var typeDetail: String {
        switch self {
        case .vegan: return "this is vegan"
        case .lacto: return "this is lacto"
        case .ovo: return "this is ovo"
        case .lacto_ovo: return "this is lacto_ovo"
        case .pesco: return "this is pesco"
        case .pollo: return "this is pollo"
        case .fruitarian: return "this is fruitarian"
        case .flexitarian: return "this is flexitarian"
        }
    }
    
    var typeColor: UIColor {
        switch self {
        case .vegan: return .vridge_typeVegan
        case .lacto: return .vridge_typeLacto
        case .ovo: return .vridge_typeOvo
        case .lacto_ovo: return .vridge_typeLactoOvo
        case .pesco: return .vridge_typePesco
        case .pollo: return .vridge_typePollo
        case .fruitarian: return .vridge_typeFruitarian
        case .flexitarian: return .vridge_typeFlexitarian
        }
    }
    
}
