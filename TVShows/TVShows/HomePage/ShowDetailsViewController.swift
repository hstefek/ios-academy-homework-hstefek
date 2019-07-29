//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 7/26/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var detailsThumbnail: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsDescription: UILabel!
    @IBOutlet weak var detailsEpisodesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var token = String()
    var showId = String()
    private var episodes = [ShowEpisodes]()
    private var naslov = String()
    private var opis = String()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        _getDetails()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Get details
private extension ShowDetailsViewController {
    
    private func _getDetails() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(showId)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (dataResponse: DataResponse<ShowDetails>) in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let response):
                    self.naslov = response.title
                    self.opis = response.description
                    print("\(response)")
                    self._getEpisodes()
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showFetchError(error: apiFailure)
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    private func _getEpisodes() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(showId)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (dataResponse: DataResponse<[ShowEpisodes]>) in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let response):
                    self.episodes = response
                    print("\(self.episodes)")
                    self.reloadData()
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    let apiFailure: String = "\(error)"
                    self.showFetchError(error: apiFailure)
                    SVProgressHUD.dismiss()
                }
        }
    }
}

// MARK: - UITableView
extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = episodes[indexPath.row]
        print("Selected Item: \(item)")
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailTableViewCell", for: indexPath) as! ShowDetailTableViewCell
        cell.configure(with: episodes[indexPath.row])
        return cell
    }
}

//MARK: - Private
private extension ShowDetailsViewController {
    
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func setupUI() {
        detailsThumbnail.layer.cornerRadius = 20
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
    
    private func reloadData() {
        detailsThumbnail.image = UIImage(named: "icImagePlaceholder")
        detailsTitle.text = naslov
        detailsDescription.text = opis
        detailsEpisodesCount.text = "Episodes \(episodes.count)"
        setupTableView()
    }
    
}

