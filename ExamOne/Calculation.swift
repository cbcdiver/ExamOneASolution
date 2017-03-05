//
//  Calculation.swift
//  ExamOne
//
//  Created by Chris Chadillon on 2017-02-26.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import Foundation

class Calculation {
    var operandOne:Double
    var operandTwo:Double
    var theOperator:Operator
    var theResult:Double
    
    init (operandOne:Double = 0.0, operandTwo:Double = 0.0,
          theOperator:Operator, theResult:Double) {
        self.operandOne = operandOne
        self.operandTwo = operandTwo
        self.theOperator = theOperator
        self.theResult = theResult
    }
    
    var description:String {
        switch self.theOperator {
        case .PI,
             .Euler:
            return "\(self.theOperator.rawValue) = \(self.theResult)"
        case .SqRoot,
             .ChangeSign:
            return "\(self.theOperator.rawValue)\(self.operandOne) = \(self.theResult)"
        // EXAM: Add the Factorial to the description
        case .Factorial:
            return "\(self.operandOne) \(self.theOperator.rawValue) = \(self.theResult)"
        case .Addition,
             .Subtraction,
             .Multiply,
             .Divide:
            return "\(self.operandOne) \(self.theOperator.rawValue) \(self.operandTwo) = \(self.theResult)"
        case .Equals: return ""
        }
    }
}
