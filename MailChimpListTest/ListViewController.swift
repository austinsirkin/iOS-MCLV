//
//  ListViewController.swift
//  MailChimpTest
//
//  Created by Austin Sirkin on 1/6/18.
//  Copyright © 2018 Austin Sirkin. All rights reserved.
//


import UIKit

// Declaring my variables to store the data I'mma get
var listNames = [String]()
var listIds = [String]()
var emailAddresses = [String]()

// Setting these as global constants so they can be used for all calls since they all use the same login deets
let username = "MyUserNameLiterallyDoesNotMatterAtAll"
let password = "8ac1de26a49c4cca30ca8c0b62b8e68c-us14"
let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
let base64LoginData = loginData.base64EncodedString()

class ListViewController: UITableViewController {
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        // WHOOPS, don't want to run the function below every single time we hit this page!
        if listIds == [] {
        
        // Running the function in viewDidLoad to start the calls for populating the data

            makeGetCall()
            
        // Not sure how to reload the data once it's loaded
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Code for actually displaying the data in the table view. Can't forget that part. It's kind of important.

   override func numberOfSections(in tableView: UITableView) -> Int {
    return listNames.count }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAddresses.count }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(listNames[section])"
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listName", for: indexPath)
        
        cell.textLabel?.text = "\(emailAddresses[indexPath.row])"
        
        return cell

    

    }

}
