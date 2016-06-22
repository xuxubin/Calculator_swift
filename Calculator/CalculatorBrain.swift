//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by xuxubin on 6/22/16.
//  Copyright © 2016 xuxubin. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description:String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = Array<Op>()
    
    private var knownOps = Dictionary<String, Op>()
    
    init()
    {
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("*", {$0 * $1}))
        //knownOps["*"] = Op.BinaryOperation("*", *)
        learnOp(Op.BinaryOperation("+", {$0 + $1}))
        learnOp(Op.BinaryOperation("-", {$1 - $0}))
        learnOp(Op.BinaryOperation("/", {$1 / $0}))
        learnOp(Op.UnaryOperation("*", {sqrt($0)}))
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left")
        return result
    }
    
    private func evaluate(ops:[Op]) -> (result:Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
                case Op.Operand(let operand):
                    return (operand, remainingOps)
                case Op.UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result
                    {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case Op.BinaryOperation(_, let operation):
                    let operand1Evaluation = evaluate(remainingOps)
                    if let operand1 = operand1Evaluation.result
                    {
                        let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                        if let operand2 = operand2Evaluation.result
                        {
                            return (operation(operand1, operand2), operand2Evaluation.remainingOps)
                        }
                    }
            }
        }
        return (nil, ops)
    }
}
