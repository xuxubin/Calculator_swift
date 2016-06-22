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
    
    var brain = CalculatorBrain()

    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //print("\(digit)")
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
        if let result = brain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
            displayValue = 0
        }
    }
    
    @IBAction func performOperation(sender: UIButton)
    {
        if(userIsInTheMiddleOfTyping)
        {
            enter()
        }
        
        if let mathSymbol = sender.currentTitle
        {
            if let result = brain.performOperation(mathSymbol)
            {
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
}

