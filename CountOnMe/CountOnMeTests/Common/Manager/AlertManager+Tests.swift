//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class AlertManager_Tests: XCTestCase {
    
    func test_alert_should_have_correct_title_and_message() {
        // arrange
        let titleAndMessagesShouldBe: [(title: String, message: String)] = [
            ("Informations", "Un operateur est déja selectionné !"),
            ("Informations", "Le calcul est incomplet!"),
            ("Zéro!", "Division par 0 impossible !"),
            ("Informations", "Le calcul ne peut pas commencer par un operateur"),
            ("Informations", "Resultat déjà calculé !")
        ]
        
        let caseToTests: [AlertManager.AlertType] = [
            .operatorsAlreadyPresent,
            .calculateIncomplete,
            .divisionZero,
            .missingNumber,
            .alreadyAnEqual
        ]
        
        // act & assert
        for (index, titleAndMessage) in titleAndMessagesShouldBe.enumerated() {
            let caseToTest = caseToTests[index]
                
            // act
            let alert = AlertManager.getAlert(caseToTest)
            // assert
            XCTAssertEqual(alert.title, titleAndMessage.title)
            XCTAssertEqual(alert.message, titleAndMessage.message)
        }
    }
}
