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
    private var name = UserDefaults.standard.string(forKey: "name") ?? ""
    private var pass = UserDefaults.standard.string(forKey: "pass") ?? ""

    //MARK: - Lifecycle methods
    private func configureUI() {
        logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
        emailField.text = name
        passwordField.text = pass
        if name != "" {
            _loginUserWith(email: name, password: pass)
        }
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
        rememberMe()
        _loginUserWith(email: name, password: pass)
    }
    @IBAction private func createAccHomePush() {
        rememberMe()
        if name.isEmpty {
            print("API failure: Enter username!")
        } else {
            _RegisterUserWith(email: name, password: pass)
        }
    }
    
    //MARK: - Private functions
    private func goToHome(token: String){
        if let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                newViewController.token = token
                let navigationController = UINavigationController(rootViewController: newViewController)
                present(navigationController, animated: true)
        }
    }
    
    private func rememberMe() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        if checkboxButton.isSelected {
            UserDefaults.standard.set(email, forKey: "name")
            UserDefaults.standard.set(password, forKey: "pass")
        }
        name = email
        pass = password
    }
    
    private func showLoginError(error: String){
        self.logInButton.shake()
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
                    print("\(user)")
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (dataResponse: DataResponse<LoginData>) in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let response):
                    print("\(response)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    SVProgressHUD.dismiss()
                    self.goToHome(token: response.token)
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showLoginError(error: apiFailure)
                    SVProgressHUD.dismiss()
                }
        }
    }

}

extension UIView {
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
