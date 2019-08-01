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

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var token = String()
    private var show = [Show]();

    @objc private func _logoutActionHandler() {
        resetDefaults()
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _fetchShows()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationItem.leftBarButtonItem = UIBarButtonItem (
            image: UIImage(named: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(_logoutActionHandler)
        )
    }
}

// MARK: - Fetch shows
private extension HomeViewController {
    
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
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = show[indexPath.row]
        if let newViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
            newViewController.token = token
            newViewController.showId = item._id
            self.present(newViewController, animated: true)
        }
        print("Selected Item: \(item)")
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.configure(with: show[indexPath.row])
        return cell
    }
}

//MARK: - Private
private extension HomeViewController {
    
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
    
    private func reloadData() {
        setupTableView()
    }
    
}
