//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 7/8/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var counter = 0
   

    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var myButton: UIButton!
    
    @IBAction func TouchUpInside(_ sender: Any) {
        print("Hello World!")
        counter += 1
        if counter < 10{
            Label.text = "Button press counter: " + String(counter)}
        else if counter < 30{
            Label.text = "You really like this button, don't you? \n" + String(counter)
        }
        else{
            Label.text = "Can you stop doing that? \n" + String(counter)
        }
        
        if counter%2==1 {
            mySpinner.startAnimating()
        }
        else{
            mySpinner.stopAnimating()
        }
    }
    @IBOutlet weak var Label: UILabel!{
        didSet{
            self.Label.text = "What is my purpose? I hope I'm not a butter passer..."
            self.Label.font = UIFont (name: "Didot", size: 30)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        mySpinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.mySpinner.stopAnimating()
        }
        myButton.layer.cornerRadius = 10
        myButton.clipsToBounds = true
        myButton.backgroundColor = .darkGray
        myButton.setTitleColor(.blue, for: .normal)
        myButton.setImage(UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
