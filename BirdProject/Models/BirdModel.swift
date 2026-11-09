//
//  BirdModel.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 13/08/26.
//

import SwiftUI

struct BirdModel {
    let identifier: String
    let title: String
    let imageName: String
    
//    static let unknown = BirdModel(
//        identifier: unknown, title: "Canto não encontrado", imageName: ""
//    )
    
    static func from(identifier: String) -> BirdModel {
        switch identifier {
        case "btv":
            return BirdModel(identifier: "Bem-te-vi", title: "Bem-te-vi", imageName: "btvImage")
        case "ttc":
            return BirdModel(identifier: "Tico_tico", title: "Tico Tico", imageName: "ttcImage")
        case "cio":
            return BirdModel(identifier: "Curio", title: "Curió", imageName: "cioImage")
        default:
            return BirdModel(identifier: "Unknown", title: "Canto não encontrado", imageName: "")
        }
    }
}

//enum BirdModel: String, CaseIterable, Codable{
//    
//    case none = "Não definido"
//    case btv = "Bem-te-vi"
//    case ttc = "Tico Tico"
//    case cio = "Curió"
//    
//    var title: String {
//        switch self {
//        case .none:
//            return "Não definido"
//        case .btv:
//            return "Bem-te-vi"
//        case .ttc:
//            return "Tico Tico"
//        case .cio:
//            return "Curió"
//        }
//    }
//    
//    var photo: Image {
//        switch self{
//        case .none: return Image("")
//        case .btv: return Image("btvImage")
//        case .ttc: return Image("ttcImage")
//        case .cio: return Image("cioImage")
//        }
//    }
//    
//}
