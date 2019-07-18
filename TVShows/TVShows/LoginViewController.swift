//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 7/18/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var isChecked: Bool = false
    
    // MARK: - Images
    let checkedImage = UIImage(named: "ic-checkbox-filled")! as UIImage
    let uncheckedImage = UIImage(named: "ic-checkbox-empty")! as UIImage
    
    // MARK: - Outlets
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var checkboxButton: UIButton!
    
    @IBAction func checkboxButtonAction() {
        if isChecked == false{
            checkboxButton.setImage(checkedImage, for: UIControl.State.normal)
            isChecked = true
        } else {
            checkboxButton.setImage(uncheckedImage, for: UIControl.State.normal)
            isChecked = false
        }
    }
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 5
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
