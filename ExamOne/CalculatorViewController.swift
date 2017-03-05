//
//  CalculatorViewController.swift
//  ExamOne
//
//  Created by Chris Chadillon on 2017-02-26.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // Instances Properties
    let theBrain = Brain()
    var theOperator = Operator.PI
    var operandOne = 0.0
    var operandTwo = 0.0
    var objectToSaveCalculationTo:CalculationSavable!
    
    // Outlets
    @IBOutlet weak var operatorSeg: UISegmentedControl!
    @IBOutlet weak var operandOneText: UITextField!
    @IBOutlet weak var operandTwoText: UITextField!
    @IBOutlet weak var resultText: UITextField!
    @IBOutlet weak var theOperatorImage: UIImageView!
    
    // Actions
    @IBAction func doCalculate(_ sender: UIButton) {
        self.doCalcResult()
        let theCalculation = Calculation(operandOne: Double(self.operandOne), operandTwo: Double(self.operandTwo), theOperator: self.theOperator, theResult: theBrain.result)
        self.objectToSaveCalculationTo.saveACalculation(aCalculation: theCalculation)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func doCalcResult() {
        switch self.theOperator {
        case .PI,
             .Euler:
            self.theBrain.performOperation(symbol: self.theOperator.rawValue)
        case .SqRoot,
             .ChangeSign,
             
             // Exam: Treat Factorial like a Unary operator
             .Factorial:
            var op1 = 0.0
            if let o1 = Double(self.operandOneText.text!) {
                op1 = o1
            }
            self.operandOne = op1
            self.theBrain.setCurrentResult(aResult: op1)
            self.theBrain.performOperation(symbol: self.theOperator.rawValue)
        case .Addition,
             .Subtraction,
             .Multiply,
             .Divide:
            var op1 = 0.0
            var op2 = 0.0
            if let o1 = Double(self.operandOneText.text!) {
                op1 = o1
            }
            if let o2 = Double(self.operandTwoText.text!) {
                op2 = o2
            }
            self.operandOne = op1
            self.operandTwo = op2
            self.theBrain.setCurrentResult(aResult: op1)
            self.theBrain.performOperation(symbol: self.theOperator.rawValue)
            self.theBrain.setCurrentResult(aResult: op2)
            self.theBrain.performOperation(symbol: Operator.Equals.rawValue)
            
        case .Equals: break
        }
        self.resultText.text = theBrain.result.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.operatorSeg.addTarget(self, action: #selector(operatorDidChange(sender:)), for: .valueChanged)
        
        self.operandOneText.isEnabled = false
        self.operandTwoText.isEnabled = false
        self.resultText.isEnabled = false
        
        // Exam: Load the previously saved operator from the UserDefaults
        let savedOperatorIndex = UserDefaults.standard.integer(forKey: "operator")
       
        // Exam: Set the segmented control to the save operator
        self.operatorSeg.selectedSegmentIndex = savedOperatorIndex
       
        // Exam: Update the image view to the selected operator
        self.theOperatorImage.image = UIImage(named: Operator.from(int: savedOperatorIndex).asImageName)
        
        // Exam: Set the saved operator to the of the View
        self.theOperator = Operator.from(int: savedOperatorIndex)
       
        // Exam: Call the method to update the operand fields (enable and disbale) based on 
        // the currently selected operator
        self.enableAndDisableFields(selectedOperator: self.theOperator)
    }
    
    @IBAction func updateResult(_ sender: UIButton) {
        self.doCalcResult()
    }
}

extension CalculatorViewController {
    func operatorDidChange(sender: UISegmentedControl) {
        let selectedOperator = Operator.from(int:sender.selectedSegmentIndex)
        self.theOperator = selectedOperator
       
        // Exam: Call the method to update the operand fields based on the operator
        self.enableAndDisableFields(selectedOperator: self.theOperator)
       
        // Exam: Update the image view to the selected operator
        self.theOperatorImage.image = UIImage(named: self.theOperator.asImageName)
        
        // Exam: Save the selected operator to the UserDefauls
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "operator")
        UserDefaults.standard.synchronize()
    }
    
    // Exam: Make this into a new method so it can be used for 2 things:
    //
    // 1 -> When the View loads and an Operator is preselected
    // 2 -> When an operator is selected from the segmented control
    func enableAndDisableFields(selectedOperator:Operator) {
        switch selectedOperator {
        case .PI,
             .Euler:
            self.operandOneText.isEnabled = false
            self.operandOneText.text = ""
            self.operandTwoText.isEnabled = false
            self.operandTwoText.text = ""
        case .SqRoot,
             .ChangeSign,
        
            // Exam: Enable and disable the operands for Factorial
             .Factorial:
            self.operandOneText.isEnabled = true
            self.operandTwoText.isEnabled = false
            self.operandTwoText.text = ""
        case .Addition,
             .Subtraction,
             .Multiply,
             .Divide:
            self.operandOneText.isEnabled = true
            self.operandTwoText.isEnabled = true
        case .Equals: break
        }
    }
}
