//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 7/18/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {

    var token = String()
    private var show = [Show]();
    override func viewDidLoad() {
        super.viewDidLoad()
        _fetchShows()
    }
    
    private func showFetchError(error: String){
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("pressed OK")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {
            print("alertController shown")
        }
    }
    
    // MARK: - Fetch shows
    private func _fetchShows() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (dataResponse: DataResponse<[Show]>) in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let response):
                    self.show = response
                    print(self.show[0].title)
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showFetchError(error: apiFailure)
                    SVProgressHUD.dismiss()
                }
        }
    }
}
