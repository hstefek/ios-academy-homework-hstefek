//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 7/18/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var logInButton: UIButton!
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 5
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
