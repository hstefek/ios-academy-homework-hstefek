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
import Kingfisher

final class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var detailsThumbnail: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsDescription: UILabel!
    @IBOutlet weak var detailsEpisodesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var token = String()
    var showId = String()
    private var episodes = [ShowEpisodes]()
    private var showTitle = String()
    private var showDescription = String()
    private var showImage = String()
    
    func setupUI() {
        detailsThumbnail.layer.cornerRadius = 20
        detailsThumbnail.kf.setImage(with: URL(string: "https://api.infinum.academy" + showImage))
        detailsTitle.text = showTitle
        detailsDescription.text = showDescription
        detailsEpisodesCount.text = "Episodes \(episodes.count)"
        setupTableView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        _getDetails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pressAddEpisodes(_ sender: Any) {
        if let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AddEpisodesViewController") as? AddEpisodesViewController {
            newViewController.token = token
            newViewController.showId = showId
            newViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: newViewController)
            present(navigationController, animated: true)
        }
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
                    self.showTitle = response.title
                    self.showDescription = response.description
                    self.showImage = response.imageUrl
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
                    self.setupUI()
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
        //print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
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
}

extension ShowDetailsViewController: AddShowDetailsViewControllerDelegate {
    
    func reloadData() {
        _getDetails()
    }
}

