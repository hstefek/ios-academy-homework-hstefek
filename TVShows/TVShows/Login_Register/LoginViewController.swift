//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 7/18/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    //MARK: - Properties
    
    //MARK: - Lifecycle methods
    private func configureUI() {
        logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction private func checkboxButtonAction() {
        checkboxButton.isSelected.toggle()
    }
    @IBAction private func loginHomePush() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        _loginUserWith(email: email, password: password)
    }
    @IBAction private func createAccHomePush() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        if email.isEmpty {
            print("API failure: Enter username!")
        } else {
            _RegisterUserWith(email: email, password: password)
            print("API failure: Enter username!")
        }
    }
    
    //MARK: - Private functions
    private func goToHome(){
        let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
        present(newViewController, animated: true, completion: nil)
    }
    
    private func showLoginError(error: String){
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("pressed OK")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
            print("alertController shown")
        }
    }
    
    // MARK: - Register + automatic JSON parsing
    private func _RegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response: DataResponse<User>) in
                guard let self = self else { return }
                switch response.result {
                case .success(let user):
                    var token: String = user.id
                    SVProgressHUD.dismiss()
                    self._loginUserWith(email: email, password: password)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("API failure: \(error)")
                }
        }
    }
    
    
    // MARK: - Login + automatic JSON parsing
    private func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let response):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    SVProgressHUD.dismiss()
                    self.goToHome()
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showLoginError(error: apiFailure)
                    SVProgressHUD.dismiss()
                }
        }
    }

}

