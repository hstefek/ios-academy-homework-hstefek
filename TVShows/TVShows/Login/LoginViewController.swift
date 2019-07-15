//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 7/8/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    private var numberOfClicks: Int = 0
   
    // MARK: - Outlets
    
    @IBOutlet private weak var touchCounterButtonSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var touchCounterButton: UIButton!
    @IBOutlet private weak var buttonPressCounterLabel: UILabel!
    
    @IBAction private func touchCounterButtonActionHandler(){
        print("Hello World!")
        numberOfClicks += 1
        if numberOfClicks < 10 {
            buttonPressCounterLabel.text = "Button press counter: " + String(numberOfClicks)
            
        } else if numberOfClicks < 30 {
            buttonPressCounterLabel.text = "You really like this button, don't you? \n" + String(numberOfClicks)
        } else{
            buttonPressCounterLabel.text = "Can you stop doing that? \n" + String(numberOfClicks)
        }
        if numberOfClicks.isMultiple(of: 2) {
            touchCounterButtonSpinner.startAnimating()
        } else{
            touchCounterButtonSpinner.stopAnimating()
        }
    }
    
    private func configureUI() {
        touchCounterButton.layer.cornerRadius = 20
        touchCounterButtonSpinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.touchCounterButtonSpinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
