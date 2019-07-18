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
import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}

final class LoginViewController: UIViewController {
    
    // MARK: - Images
    private let checkedImage = UIImage(named: "ic-checkbox-filled")! as UIImage
    private let uncheckedImage = UIImage(named: "ic-checkbox-empty")! as UIImage
    
    // MARK: - Outlets
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passField: UITextField!
    
    // MARK: - Variables
    private var isChecked: Bool = false

    // MARK: - Actions
    @IBAction private func checkboxButtonAction() {
        if isChecked == false{
            checkboxButton.setImage(checkedImage, for: UIControl.State.normal)
            isChecked = true
        } else {
            checkboxButton.setImage(uncheckedImage, for: UIControl.State.normal)
            isChecked = false
        }
    }
    @IBAction private func loginHomePush() {
        let useremail =  emailField.text!
        let pass =  passField.text!
        _loginUserWith(email: useremail, password: pass)
    }
    @IBAction private func createAccHomePush() {
        let useremail =  emailField.text!
        let pass =  passField.text!
        if useremail.isEmpty == false {
            _alamofireCodableRegisterUserWith(email: useremail, password: pass)
        } else {
            print("API failure: Enter username!")
        }
    }
    
    //MARK: - Functions
    private func goToHome(){
        let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
        present(newViewController, animated: true, completion: nil)
    }
    private func configureUI() {
        logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Register + automatic JSON parsing
    private func _alamofireCodableRegisterUserWith(email: String, password: String) {
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                    var LoginUser: String = user.id
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
            "password": password
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let response):
                    //var LoginUser: String = response.id
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    SVProgressHUD.dismiss()
                    self?.goToHome()
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                    SVProgressHUD.dismiss()
                }
        }
    }
}

