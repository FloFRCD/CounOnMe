//
//  AlertManager.swift
//  CountOnMe
//
//  Created by Florian Fourcade on 27/01/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

// TO SEARCH : SRP - Single Responsability Principle

import Foundation
import UIKit

struct AlertManager {
    
    //    Creation message d'erreur
    enum AlertType {
        case operatorsAlreadyPresent
        case calculateIncomplete
        case divisionZero
        case missingNumber
        case alreadyAnEqual
        
        var title: String {
            switch self{
            case .divisionZero:
                return "Zéro!"
            default:
                return "Informations"
            }
        }
        
        var message: String {
            switch self{
            case .operatorsAlreadyPresent:
                return "Un operateur est déja selectionné !"
            case .calculateIncomplete:
                return "Le calcul est incomplet!"
            case .divisionZero:
                return "Division par 0 impossible !"
                
            case .missingNumber:
                return "Le calcul ne peut pas commencer par un operateur"
            case .alreadyAnEqual:
                return "Resultat déjà calculé !"
            }
        }
    }
    
    static func getAlert(_ alertType: AlertType) -> UIAlertController {
        let alertVC = UIAlertController(title: "\(alertType.title)", message: "\(alertType.message)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}


