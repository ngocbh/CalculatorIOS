//
//  ViewControllerCal.swift
//  Calculator
//
//  Created by Ngoc Jr on 7/23/17.
//  Copyright © 2017 mespi. All rights reserved.
//

import UIKit

class ViewControllerCal: UIViewController {
    
    //MARK: VALUE
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operatorColection: [UIButton]!
    @IBOutlet var buttonsColection: [UIButton]!
    
    
    //MARK: VAlUE
    var currentOperation:Int = 0
    var numberOnScreen:Double = 0
    var rememberNumber:Double = 0
    var previousAction:Int = 0
    var previousNumberOnScreen:Double = 0
    var previousOperator:Int = 0
    var decima:Double = 0
    var isNegativeNumber : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Make borderWidth for buttons

        for button_ in buttonsColection {
            button_.layer.borderWidth = 1/4
        }
    }
    

    
    //MARK: ACTION
    
    func caculated(rememberNumber : Double, numberOnScreen : Double, operation : Int) -> Double
    {
        //return rememberNumber (operator) numberOnScreen
        switch operation {
        case 1:     //Division
            return rememberNumber / numberOnScreen
        case 2:     //Multiplication
            return rememberNumber * numberOnScreen
        case 3:     //Subtraction
            return rememberNumber - numberOnScreen
        case 4:     //Addition
            return rememberNumber + numberOnScreen
        default:
            return numberOnScreen
        }
    }
    
    
    func convertNumberToText(_ number : Double)
    {
        
        if numberOnScreen >= 10e10 || (numberOnScreen < 10e-9 && numberOnScreen > 0 ) || ( numberOnScreen < 0 && numberOnScreen > 10e-9 )  {
            lblText.text = String(Float32(numberOnScreen))
        }
        else if (abs(numberOnScreen) - round(abs(numberOnScreen))) == Double(0) {
            lblText.text = String(Int64(numberOnScreen))
            
        }
        else  {
            lblText.text = String(numberOnScreen)
            if ( (lblText.text?.characters.count)! > 9 )
            {
                let numberString : String = lblText.text!
                let str = numberString[0..<10]
                lblText.text = str
            }
        }
    }
    
    
    @IBAction func touchOperators(_ sender: UIButton)
    {
        if previousAction >= 14 && previousOperator <= 17 {
            currentOperation = sender.tag - 9
            previousOperator = currentOperation
            previousAction = sender.tag
            
            for operator_ in operatorColection {
                operator_.layer.borderWidth = 1/4
            }
            sender.layer.borderWidth = 2

            return
        }
        
        if currentOperation != 0 {
            numberOnScreen = caculated(rememberNumber: rememberNumber, numberOnScreen: numberOnScreen, operation: currentOperation)
            
            convertNumberToText(numberOnScreen)
            rememberNumber = numberOnScreen
        }
        
        for operator_ in operatorColection {
            operator_.layer.borderWidth = 1/4
        }
        
        currentOperation = sender.tag - 9
        previousOperator = currentOperation
        rememberNumber = numberOnScreen
        numberOnScreen = 0
        decima = 0
        previousAction = sender.tag
        sender.layer.borderWidth = 2
        
    }
    
    
    @IBAction func touchNumbers(_ sender: UIButton)
    {
        
        var isNegative : Int = 0
        
        if previousAction == 18 {
            lblText.text = "0"
            numberOnScreen = 0
        }
        
        for operator_ in operatorColection {
            operator_.layer.borderWidth = 1/4
        }
        
        if currentOperation > 4 {
            currentOperation -= 4;
            if lblText.text == "0" {
                lblText.text = String(sender.tag-1)
                decima = 0
            }
            else if lblText.text == "-0" {
                lblText.text = "-"
                lblText.text = lblText.text! + String(sender.tag-1)
                decima = 0
                isNegative = 1
            }
            else {
                if decima > 0 {
                    lblText.text = lblText.text! + String(sender.tag-1)
                }
                else {
                    lblText.text = String(sender.tag-1)
                }
            }
            numberOnScreen = 0
        }
        else if lblText.text == "0" {
            lblText.text = String(sender.tag-1)
            numberOnScreen = 0
            decima = 0
        }
        else if lblText.text == "-0" {
            lblText.text = "-"
            lblText.text = lblText.text! + String(sender.tag-1)
            numberOnScreen = 0
            decima = 0
            isNegative = 1
        }
        else {
            if (lblText.text?.characters.count)! <= 9
            {
                lblText.text = lblText.text! + String(sender.tag-1)
            }
        }
        
        if (lblText.text?.characters.count)! <= 9
        {
            if decima == 0
            {
                if numberOnScreen < 0 || isNegative == 1
                {
                    numberOnScreen = numberOnScreen*10 - Double(sender.tag-1)
                } else {
                    numberOnScreen = numberOnScreen*10 + Double(sender.tag-1)
                }
            }
            else
            {
                if numberOnScreen < 0 || isNegative == 1
                {
                    numberOnScreen = numberOnScreen - Double(sender.tag-1)/decima
                    decima *= 10
                } else {
                    numberOnScreen = numberOnScreen + Double(sender.tag-1)/decima
                    decima *= 10
                }
            }
        }
        previousNumberOnScreen = numberOnScreen
        clearButton.setTitle("C", for: .normal)
        previousAction = sender.tag

    }
    
    
    @IBAction func touchEqual(_ sender: UIButton)
    {
        
        if ( previousAction == 18 ) {
            if previousOperator > 4 { previousOperator -= 4 }
            
            numberOnScreen = caculated(rememberNumber: rememberNumber, numberOnScreen: previousNumberOnScreen, operation: previousOperator)
        }
        if previousAction >= 14 && previousAction <= 17 {
            if previousOperator > 4 { previousOperator -= 4 }

            numberOnScreen = caculated(rememberNumber: rememberNumber, numberOnScreen: numberOnScreen, operation: previousOperator)
        }
        else{
            if currentOperation > 4 { currentOperation -= 4 }
            
            numberOnScreen = caculated(rememberNumber: rememberNumber, numberOnScreen: numberOnScreen, operation: currentOperation)
        }
        
        convertNumberToText(numberOnScreen)
        
        for operator_ in operatorColection {
            operator_.layer.borderWidth = 1/4
        }
        
        rememberNumber = numberOnScreen
        
        if previousAction != 18 {
            previousOperator = currentOperation
        }
        
        currentOperation = 0
        decima = 0
        previousAction = sender.tag
    }
    
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        
        for operator_ in operatorColection {
            operator_.layer.borderWidth = 1/4
        }
    
        
        if previousAction == 18 || previousAction == 11  {
            sender.setTitle("AC", for: .normal)
            numberOnScreen = 0
            currentOperation = 0
            rememberNumber = 0
            previousNumberOnScreen = 0
            previousOperator = 0
            lblText.text = "0"
            decima = 0
            previousAction = sender.tag
            return
        }
        
        
        
        if lblText.text != "0"
        {
            
            sender.setTitle("AC", for: .normal)
            lblText.text = "0"
            numberOnScreen = 0
            decima = 0
            
            var count = 0
            for operator_ in operatorColection
            {
                count += 1
                if count == currentOperation {
                    operator_.layer.borderWidth = 2
                }
            }
        }
        else {
            numberOnScreen = 0
            currentOperation = 0
            rememberNumber = 0
            previousNumberOnScreen = 0
            previousOperator = 0
            lblText.text = "0"
            decima = 0
        }
        
        previousAction = sender.tag

    }
    
    
    @IBAction func touchPlusMinus(_ sender: UIButton) {
        
        if previousAction >= 14 && previousAction <= 17 {
            lblText.text = "-0";
            return
        }
        
        if lblText.text == "0" {
            return
        }
        
        
        
        if numberOnScreen > 0
        {
            lblText.text = "-" + lblText.text!
            numberOnScreen = -numberOnScreen
        }
        else
        {
            var name = lblText.text!
            name.remove(at: name.startIndex)
            lblText.text = name
            numberOnScreen = -numberOnScreen
        }
        previousAction = sender.tag
    }
    
    
    @IBAction func touchPercent(_ sender: UIButton) {
        numberOnScreen = caculated(rememberNumber: numberOnScreen, numberOnScreen: 100, operation: 1)
        convertNumberToText(numberOnScreen)
        previousNumberOnScreen = numberOnScreen
        previousAction = sender.tag
    }
    
    
    @IBAction func touchDots(_ sender: UIButton) {
        if decima != 0 {
            return
        }
        if previousAction > 10 {
            lblText.text = "0"
        }
        
        for operator_ in operatorColection {
            operator_.layer.borderWidth = 1/4
        }
        
        lblText.text = lblText.text! + "."
        decima = 10
        previousAction = sender.tag
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}


