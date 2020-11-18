//
//  VegieType.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/17.
//

import UIKit

enum VegieType: String, CaseIterable {
    case fruitarian = "fruitarian"
    case vegan = "vegan"
    case lacto = "lacto"
    case ovo = "ovo"
    case lacto_ovo = "lacto ovo"
    case pesco = "pesco"
    case pollo = "pollo"
    case flexitarian = "flexitarian"
    
    var typeDetail: String {
        switch self {
        case .fruitarian: return "과일만 섭취할 수 있어요"
        case .vegan: return "채소, 과일만 섭취할 수 있어요"
        case .lacto: return "채소, 과일, 유제품, 꿀만 섭취할 수 있어요"
        case .ovo: return "채소, 과일, 달걀만 섭취할 수 있어요"
        case .lacto_ovo: return "채소, 과일, 달걀, 유제품만 섭취할 수 있어요"
        case .pesco: return "해산물까지 섭취할 수 있어요"
        case .pollo: return "해산물, 닭고기까지 섭취할 수 있어요"
        case .flexitarian: return "상황에 따라서 육류를 섭취할 수 있어요"
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
    
    var typeImage: UIImage {
        switch self {
        case .flexitarian: return UIImage(named: "imgFlexitarian") ?? UIImage()
        case .vegan: return UIImage(named: "imgVegan") ?? UIImage()
        case .lacto: return UIImage(named: "imgLacto") ?? UIImage()
        case .ovo: return UIImage(named: "imgOvo") ?? UIImage()
        case .lacto_ovo: return UIImage(named: "imgLactoOvo") ?? UIImage()
        case .pesco: return UIImage(named: "imgPesco") ?? UIImage()
        case .pollo: return UIImage(named: "imgPollo") ?? UIImage()
        case .fruitarian: return UIImage(named: "imgFruitarian") ?? UIImage()

        }
    }
    
    var typeDescription: String {
        switch self {
        case .fruitarian: return "@fruitatian | 과일만"
        case .vegan: return "@vegan | 채소, 과일"
        case .lacto: return "@lacto | 채소, 과일, 유제품, 꿀"
        case .ovo: return "@ovo | 채소, 계란, 과일"
        case .lacto_ovo: return "@lacto ovo | 채소, 과일, 달걀, 유제품"
        case .pesco: return "@pesco | 해산물까지"
        case .pollo: return "@pollo | 해산물, 닭고기까지"
        case .flexitarian: return "@flexitarian | 상황에 따라 육식"
        }
    }
}

