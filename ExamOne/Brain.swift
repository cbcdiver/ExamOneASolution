import Foundation

// Exam: Basic Factorial recursive function, Note: must be coded
// outside of the class
func factorial(n:Double)->Double {
    if n < 2 {
        return 1
    } else {
        return n * factorial(n: n-1)
    }
}

class Brain {
    private var currentResult = 0.0
    var result:Double {
        get {
            return self.currentResult
        }
    }
    
    func setCurrentResult(aResult:Double) {
        self.currentResult = aResult
    }
    
    private enum OperationTypes {
        case Constant(Double)
        case UnaryOperator((Double)->Double)
        case BinaryOperator((Double, Double)->Double)
        case Equals
    }
    
    private let operations:Dictionary<String,OperationTypes> = [
        "π" : .Constant(M_PI),
        "e" : .Constant(M_E),
        "√" : .UnaryOperator(sqrt),
        "±" : .UnaryOperator({$0 != 0 ? -$0 : 0.0}),
        "+" : .BinaryOperator({$0+$1}),
        "−" : .BinaryOperator({$0-$1}),
        "×" : .BinaryOperator({$0*$1}),
        "÷" : .BinaryOperator({$0/$1}),
        
        // Exam: The Factorial method is added as a UnaryOperator
        "!" : .UnaryOperator(factorial),
        "=" : .Equals
    ]
    
    func performOperation(symbol:String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let theConstant):
                self.currentResult = theConstant
            case .UnaryOperator(let theUnaryFunction):
                self.currentResult = theUnaryFunction(self.currentResult)
            case .BinaryOperator(let theBinaryOperator):
                self.pendingOperation = PendingBinaryOperationInfo(binaryOperator: theBinaryOperator,firstOperand: self.currentResult)
            case .Equals:
                if let _ = pendingOperation {
                    self.currentResult = pendingOperation.binaryOperator(
                        pendingOperation.firstOperand, self.currentResult)
                    pendingOperation = nil
                }
            }
        }
    }
    
    private var pendingOperation:PendingBinaryOperationInfo!
    
    struct PendingBinaryOperationInfo {
        var binaryOperator:(Double, Double)->Double
        var firstOperand:Double
    }
}
