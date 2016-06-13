//
//  ViewController.swift
//  Calculator
//
//  Created by xuxubin on 16/5/16.
//  Copyright © 2016年 xuxubin. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{

    @IBOutlet weak var displayLabel: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    var operandStack:Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("\(digit)")
        if userIsInTheMiddleOfTyping
        {
            let textCurrentlyDisplay = displayLabel.text!
            displayLabel.text = textCurrentlyDisplay + digit
        }
        else
        {
            displayLabel.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }

    var displayValue: Double
    {
        get
        {
            return NSNumberFormatter().numberFromString(displayLabel.text!)!.doubleValue
        }
        set
        {
            displayLabel.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func enter()
    {
        print("press enter")
        userIsInTheMiddleOfTyping = false
        operandStack.append(displayValue)
        print("operand stack = \(operandStack)")
    }
    
    @IBAction func performOperation(sender: UIButton)
    {
        if(userIsInTheMiddleOfTyping)
        {
            enter()
            userIsInTheMiddleOfTyping = false
        }
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle
        {
            switch mathSymbol {
            case "+":
                performCalculation2({(op1:Double, op2:Double) -> Double in
                      return op1+op2
                    })
            case "-":
                performCalculation2({(op1,op2) in op2-op1
                })
            case "*":
                performCalculation2({$0 * $1})
                // performCalculation{$0 * $1}
                // performCalculation() {$0 * $1}
            case "/":
                performCalculation2(divide)
            case "√":
                performCalculation1({sqrt($0)})
            default:
                break
                
            }
        }
    }
    
    func performCalculation2(operation:(Double, Double) -> Double)
    {
        if(operandStack.count >= 2)
        {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    func performCalculation1(operation: Double -> Double)
    {
        if(operandStack.count >= 1)
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func divide(op1:Double, _ op2:Double) -> Double
    {
        return op2/op1
    }
}

