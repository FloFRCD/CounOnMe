//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculationModel_Tests: XCTestCase {
    
    lazy var model = CalculationModel(delegate: self)
    
    var result: String = ""
    var alertError: String? = nil
    
    func test_when_add_two_numbers_then_result_should_be_correct() {
        // arrange
        model.add(number: "3")
        model.add(symbol: .add)
        model.add(number: "3")
        
        // act
        model.calculate()

        // assert
        XCTAssertEqual(result, "3 + 3 = 6")
    }
    
    func test_priority_of_operations() {
        // arrange
        model.add(number: "4")
        model.add(symbol: .add)
        model.add(number: "3")
        model.add(symbol: .multiply)
        model.add(number: "3")
        model.calculate()
         
        XCTAssertEqual(result, "4 + 3 x 3 = 13")
    }
    
    func test_when_sub_two_numbers_then_result_should_be_correct(){
        // arrange
        model.add(number: "3")
        model.add(symbol: .minus)
        model.add(number: "3")
        
        // act
        model.calculate()
        
        // assert
        XCTAssertEqual(result, "3 - 3 = 0")
    }
    
    // a test
    func test_when_multiplacation_is_complete_and_press_equal_button(){
        model.add(number: "5")
        model.add(symbol: .multiply)
        model.add(number: "5")
        model.calculate()
        
        XCTAssert(result == "5 x 5 = 25")
    }
    
    func test_when_division_complete_and_press_equal_button(){
        model.add(number: "5")
        model.add(symbol: .divide)
        model.add(number: "5")
        model.calculate()
        
        XCTAssert(result == "5 / 5 = 1")
    }
    
    // a test
    func test_have_result_and_continue_calcul(){
        // arrange
        model.add(number: "4")
        model.add(symbol: .add)
        model.add(number: "4")
        model.add(number: " = \(model.operationsToReduce.first!)")
//        XCTAssert(model.elements == ["4"," + ","4"," = ","8"])
        
        model.continueCalcul()
        model.add(symbol: .minus)
        model.add(number: "6")
//        XCTAssert(model.elements == ["8"," - ","6"])
        XCTAssert(model.operationsToReduce == ["2"])
    }
    
    func test_when_we_divide_by_zero_then_an_alert_message_should_be_triggered() {
        // arrange
        model.add(number: "5")
        model.add(symbol: .divide)
        model.add(number: "0")
        XCTAssertEqual(result, "5 / 0")
        
        // act
        model.calculate()
        
        // assert
        XCTAssertEqual(alertError, AlertManager.AlertType.divisionZero.message)
    }
    
    func test_when_start_new_calcul_add_a_point_cant_add_another_point_before_an_operator(){
        model.add(number: "5")
        XCTAssertFalse(model.haveAPoint())
        
        
        model.add(number: ".")
        model.add(number: "5")
        XCTAssert(model.haveAPoint())
        
        model.add(number: "5")
        XCTAssertTrue(model.haveAPoint())
    }
    
    func test_when_we_add_two_operators_then_error_should_be_triggered(){
        model.add(number: "5")
        model.add(symbol: .add)
        model.add(symbol: .divide)
        
        let errorMessageShouldBe = AlertManager.AlertType.operatorsAlreadyPresent.message
        XCTAssertEqual(errorMessageShouldBe, alertError)
    }
    
    func test_have_finished_a_calculation_start_a_new_calcul(){
        model.add(number: "5")
        model.add(symbol: .add)
        model.add(number: "5")
        model.calculate()
        
        XCTAssertEqual(result, "5 + 5 = 10")
        
        model.resetInfo()
        model.add(number: "5")
        
        XCTAssertEqual(result, "5")
    }
    
    func test_calcul_with_point_and_priorites_press_equal_button(){
        model.add(number: "5")
        model.add(number: ".")
        model.add(number: "5")
        model.add(symbol: .add)
        model.add(number: "5")
        model.add(symbol: .multiply)
        model.add(number: "5")
        model.add(number: ".")
        model.add(number: "5")
        
        XCTAssertEqual(result, "5.5 + 5 x 5.5")
        model.calculate()
        XCTAssertEqual(result, "5.5 + 5 x 5.5 = 33")
    }
    
    func test_when_start_new_calcul_AddAPoint_cant_add_another_point_before_an_operator(){
        model.add(number: "5")
        XCTAssertFalse(model.haveAPoint())
        
        
        model.add(number: ".")
        model.add(number: "5")
        XCTAssert(model.haveAPoint())
        
        model.add(symbol: .divide)
        XCTAssertFalse(model.haveAPoint())
    }
    
    func test_when_user_press_a_point(){
        model.add(number: "5")
        model.addPoint()
        model.add(number: "8")

        XCTAssertEqual(result, "5.8")
    }

    func test_when_user_make_a_new_operation_then_previous_operation_is_deleted() {
        // arrange
        model.add(number: "6")
        model.add(symbol: .add)
        model.add(number: "6")
        model.calculate()
        XCTAssertEqual(result, "6 + 6 = 12")
        
        // act
        model.add(symbol: .add)
        
        // assert
        XCTAssertEqual(result, "12 + ")
    }
    
    func test_when_user_add_a_point_after_an_operator_error_message_should_be_presented() {
        // arrange
        model.add(number: "12")
        model.add(symbol: .add)
        
        // act
        model.addPoint()
        
        // assert
        XCTAssertEqual(alertError, AlertManager.AlertType.operatorsAlreadyPresent.message)
    }
    
    func test_when_user_add_an_equal_after_an_operator_then_error_message_should_be_presented() {
        // arrange
        model.add(number: "12")
        model.add(symbol: .add)
        
        // act
        model.calculate()
        
        // assert
        XCTAssertEqual(alertError, AlertManager.AlertType.calculateIncomplete.message)
    }
    
    
    func test_when_user_press_equal_with_only_one_number() {
        model.add(number: "12")
        
        model.calculate()
        
        XCTAssertEqual(alertError, AlertManager.AlertType.calculateIncomplete.message)
    }
    
    func test_when_user_press_two_times_equal() {
        model.add(number: "12")
        model.add(symbol: .add)
        model.add(number: "12")
        
        model.calculate()
        model.calculate()
        
        XCTAssertEqual(alertError, AlertManager.AlertType.alreadyAnEqual.message)
    }
    
    func test_when_user_want_add_two_operators() {
        model.add(symbol: .add)
        
        
        XCTAssertEqual(alertError, AlertManager.AlertType.missingNumber.message)
        
    }
    
}


extension CalculationModel_Tests: CalculationModelDelegate {
    
    func textHasChanged(_ text: String) {
        result = text
    }
    
    func present(alert: UIAlertController) {
        alertError = alert.message
    }
}
