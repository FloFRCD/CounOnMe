//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var model: CalculationModel!
    var alertManager = AlertManager()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = CalculationModel(delegate: self)
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        model.add(number: numberText)
    }
    
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        model.add(symbol: .add)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        model.add(symbol: .minus)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        model.add(symbol: .multiply)
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        model.add(symbol: .divide)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        model.calculate()
    }
    
    @IBAction func tappedAcButton(_ sender: UIButton) {
        model.resetInfo()
    }
    
    @IBAction func tappedPointButton(_ sender: UIButton) {
        model.addPoint()
    }
    
}


// MARK: - CalculationModelDelegate

extension CalculationViewController: CalculationModelDelegate {
    
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }

    func textHasChanged(_ text: String) {
        self.textView.text = text
    }
}
