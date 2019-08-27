//
//  AddEpisodesViewController.swift
//  TVShows
//
//  Created by Infinum on 7/30/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol AddShowDetailsDelegate: class {
    func reloadData()
}

final class AddEpisodesViewController: UIViewController {

    weak var delegate: AddShowDetailsDelegate?
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var seasonNumber: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
    
    var token = String()
    var showId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem (
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAdd)
        )
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd() {
        guard let title = episodeTitle.text, let description = episodeDescription.text, let episodeNumber = episodeNumber.text, let season = seasonNumber.text else { return }
        _addShow(title: title, description: description, episodeNumber: episodeNumber, season: season)
    }
    
    // MARK: - Add show + automatic JSON parsing
    private func _addShow(title: String, description: String, episodeNumber: String, season: String) {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let parameters: [String: String] = [
            "showId": showId,
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": season
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data",  decoder: JSONDecoder()) {[weak self] (response: DataResponse<ShowDetails>) in
                guard let self = self else { return }
                switch response.result {
                case .success(let response):
                    print("\(response)")
                    SVProgressHUD.dismiss()
                    self.delegate?.reloadData()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showFetchError(error: apiFailure)
                    print("API failure: \(error)")
                    SVProgressHUD.dismiss()
                }
        }
    }
}
