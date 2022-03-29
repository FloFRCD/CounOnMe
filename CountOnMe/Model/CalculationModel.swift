//
//  calcul.swift
//  CountOnMe
//
//  Created by Florian Fourcade on 27/01/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

protocol CalculationModelDelegate {
    func textHasChanged(_ text: String)
    func present(alert: UIAlertController)
}

class CalculationModel {
    
    let delegate: CalculationModelDelegate?
    
    init(delegate: CalculationModelDelegate?) {
        self.delegate = delegate
    }
    
    private var text = ""
    
    private var currentValue: String {
        return text
    }
    
    private var elements: [String] {
        return text.split(separator: " ").map { "\($0)" }
    }
    
    //You can add an operator IF the last element is not + - x or /
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    //Check if there is a value
    private var alreadyANumber: Bool{
        return currentValue != ""
    }
    
    private var expressionHaveResult: Bool {
        return text.firstIndex(of: "=") != nil
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    //Check if there is a division
    private var haveADivision = false
    
    var alerteManager = AlertManager()
    
    func continueCalcul() {
        // Check if value in element.last
        if let first = elements.last,
           expressionHaveResult {
            resetInfo()
            sendText(first)
        }
    }
    
    //Add a character to textAppend
    private func sendText(_ value: String) {
        self.text.append(value)
        self.delegate?.textHasChanged(text)
    }
    
    
    //Reset the value of textAppend
    func resetInfo(){
        self.text = ""
        self.delegate?.textHasChanged("")
    }
    
    
    
    //Check if there is a point
    func haveAPoint() -> Bool {
        //Return true if yes, false otherwise
        return elements.last?.contains(where: {$0 == "."}) ?? false
    }
    
    //Division by 0 ?
    private func divideByZero () -> Bool {
        if haveADivision && elements.last == "0"{
            //If yes we remove the 0 and return True
            text.removeLast()
            return haveADivision
        }
        //Otherwise we pass the value of haveAdivision to false and we return false
        haveADivision = false
        return haveADivision
    }
    
    //Returns a "Float" number after an addition or subtraction
    func additionAndSubstraction(_ calcul : [String]) -> Float? {
        guard let leftNumber = Float(calcul[0]),
              let rightNumber = Float(calcul[2]) else {
                  return nil
              }
        
        let operand = calcul[1]
        
        if operand == "+" {
            return leftNumber + rightNumber
        }
        
        if operand == "-" {
            return leftNumber - rightNumber
        }
        
        return nil
    }
    
    //Returns a Float number after multiplication or division
    func multiplicationAndDivision(_ calcul : [String], _ range : Int) -> Float{
        let result : Float
        switch calcul[range] {
        case "x" : result = Float(calcul[range-1])! * Float(calcul[range+1])!
        case "/" :result = Float(calcul[range-1])! / Float(calcul[range+1])!
        default : fatalError()
        }
        return result
    }
    
    var operationsToReduce: [String] {
        var operationsToReduce = elements
        var i = 0
        
        //Checks the order of operations in calculations
        while i < operationsToReduce.count {
            if operationsToReduce[i] == "x" || operationsToReduce[i] == "/"{
                let result : Float
                result = multiplicationAndDivision(operationsToReduce, i)
                //When the calculation is done the result takes the place
                operationsToReduce[i] = String(result)
                operationsToReduce.remove(at: i+1)
                operationsToReduce.remove(at: i-1)
                i = 0
            }
            i += 1
        }
        //Addition and subtraction
        while operationsToReduce.count > 1 {
            guard let result = additionAndSubstraction(operationsToReduce) else {
                return []
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        //Checks if the Float=0, if yes it is deleted
        if operationsToReduce[0].last == "0"{
            operationsToReduce[0].removeLast()
            if operationsToReduce[0].last == "."{
                operationsToReduce[0].removeLast()
            }
        }
        return operationsToReduce
    }
    
    //do the calculation
    func calculate() {
        if divideByZero() {
            let alert = AlertManager.getAlert(.divisionZero)
            delegate?.present(alert: alert)
            return
        }
        
        guard canAddOperator else {
            let alert = AlertManager.getAlert(.calculateIncomplete)
            delegate?.present(alert: alert)
            return
        }
        
        guard expressionHaveEnoughElement else {
            let alert = AlertManager.getAlert(.calculateIncomplete)
            delegate?.present(alert: alert)
            return
        }
        
        if !expressionHaveResult {
            sendText(" = \(operationsToReduce.first!)")
        } else{
            let alert = AlertManager.getAlert(.alreadyAnEqual)
            delegate?.present(alert: alert)
        }
    }
    
    //add point
    func addPoint() {
        if canAddOperator {
            if haveAPoint() == false {
                sendText(".")
            }
        } else {
            let alert = AlertManager.getAlert(.operatorsAlreadyPresent)
            delegate?.present(alert: alert)
        }
    }
    
    func add(number: String) {
        if expressionHaveResult {
            resetInfo()
        }
        
        sendText(number)
    }
    
    //add text
    func add(symbol: CalculationSymbol) {
            if canAddOperator {
                if alreadyANumber {
                    continueCalcul()
                    sendText(symbol.rawValue)
                    
                    if symbol == .divide {
                        haveADivision = true
                    }
                } else {
                    let alert = AlertManager.getAlert(.missingNumber)
                    delegate?.present(alert: alert)
                }
            } else {
                let alert = AlertManager.getAlert(.operatorsAlreadyPresent)
                delegate?.present(alert: alert)
            }
    }
}

