//
//  SelectionsViewController.swift
//  FoodBit
//
//  Created by Ameya Singh on 3/25/17.
//  Copyright © 2017 Ameya Singh. All rights reserved.
//

import UIKit
import Foundation

class SelectionsViewController: UIViewController, RecipesTableViewControllerDelegate {
    
    var recipes = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchOutside(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func enter(_ sender: UITextField) {
//        performSegue(withIdentifier: "recipesScreen", sender: nil)
        sender.endEditing(true)
        sender.isEnabled = false
        self.requestIntent(query: sender.text!) { result in
            print (result)
            if (result == "\"\"") {
                self.requestRecipes(query: sender.text!){ result in
                    print(result)
                }
            }
            else {
                sender.isEnabled = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recipesScreen") {
            ((segue.destination as! UINavigationController).topViewController as! RecipesTableViewController).delegate = self
            ((segue.destination as! UINavigationController).topViewController as! RecipesTableViewController).recipes = self.recipes
        }
    }
    
    let LIFT_CONSTANT : CGFloat = 50.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= LIFT_CONSTANT
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += LIFT_CONSTANT
            }
        }
    }
    
    func returnFromTableView(controller: RecipesTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func requestIntent(query : String, completion: @escaping (String) -> ()) {
        let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(escapedString!)
        let urlString = "https://foodbyte.herokuapp.com/api/intend/\(escapedString!)"
        
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion("")
            } else {
                if let returnData = String(data: data!, encoding: .utf8) {
                    completion(returnData)
                } else {
                    completion("")
                }
            }
        }.resume()
    }
    
    func requestRecipes(query : String, completion: @escaping (String) -> ()) {
        let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://foodbyte.herokuapp.com/api/id/\(escapedString!)"
        
        let url = URL(string: urlString)!
        
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    self.recipes = parsedData["results"] as! NSArray

                    self.performSegue(withIdentifier: "recipesScreen", sender: self)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        
//            URLSession.shared.dataTask(with:url!) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    completion("")
//                } else {
//                    if let returnData = String(data: data!, encoding: .utf8) {
//                        completion(returnData)
//                    } else {
//                        completion("")
//                    }
//                }
//                }.resume()
            
        }.resume()
    }

    func dataGetComplete (data: Data?, response: URLResponse?, error: Error?) {
        
    }
}

