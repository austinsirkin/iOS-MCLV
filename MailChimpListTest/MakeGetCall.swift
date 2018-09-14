//
//  MakeGetCall.swift
//  MailChimpListViewer
//
//  Created by Austin Sirkin on 1/26/18.
//  Copyright © 2018 Austin Sirkin. All rights reserved.
//

import Foundation

func makeGetCall() {   // Creating the function for phoning home like E.T.
    
    
    // Setting up the request. Gotta tell it where to call.
    // By using query strings I can reduce the amount of data I'm pulling, hopefully speeding things up a little.
    let endpoint: String = "https://us14.api.mailchimp.com/3.0/lists?fields=lists.name,lists.id"
    guard let url = URL(string: endpoint) else {
        
        // Just in case something weird happens. It's hard-coded, though, so verrrrry unlikely.
        print("Not a URL, my dude.")
        return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
    
    // Creating the session. Boring stuff.
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // Making the actual request. Also boring stuff.
    let task = session.dataTask(with: urlRequest) {
        (data, response, error) in
        
        // Checking for errors (hopefully)
        guard error == nil else {
            print("Unable to call /lists.")
            print(error)
            return
        }
        
        // Ensuring the data exists. Hard to get any farther without that.
        guard let responseData = data else {
            print("No list data here.")
            return
        }
        
        // Parsing the JSON into a dictionary. Everyone likes dictionaries.
        do {
            if let jsonList = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any],
                
                // For-looping through the data that the call provides to turn it into an array.
                // Why is accessing nested dictionary content so hard????
                let lists = jsonList["lists"] as? [[String: Any]] {
                for list in lists {
                    
                    /* Getting things back onto the main thread and reloading the table so it will display.
                     I've heard that displaying things is important.
                     Note: Took me forever to figure this bit out!!! */
                    
 
                    DispatchQueue.main.async {
                        if let name = list["name"] as? String {
                            listNames.append(name)
                            
                        }
                        if let id = list["id"] as? String {
                            listIds.append(id)
                            
                            // Each time a list id comes in, run the function for calling for new data based on that id
                            makeMemberGetCall(listId: id)
                            
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }
                
                // In case we can't do any of that...
            else {
                print("Can't convert data from JSON, yo.")
                return
            }
            // Checking to make sure list names exist, printing to console for debugging
            guard let listName = listNames as? [String] else {
                print("Couldn't get list names.")
                return
            }
            print(listName)
        } catch  {
            print("Still can't convert data from JSON.")
            return
        }
    }
    // Resuming afterward
    task.resume()
}
func makeMemberGetCall(listId: String) {
    
    // Set up the new request based on the pulled list ids
    let endpoint: String = "https://us14.api.mailchimp.com/3.0/lists/\(listId)/members?fields=members.email_address,members.merge_fields"
    
    // I can use the same constants and variables because it's a new function.
    // I'll change some for clarity's sake, though.
    guard let url = URL(string: endpoint) else {
        print("Not a URL.")
        return
    }
    
    // This stuff is all the same as the other call.
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
    
    
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    
    let task = session.dataTask(with: urlRequest) {
        (data, response, error) in
        
        guard error == nil else {
            print("Unable to call /members")
            print(error)
            return
        }
        
        guard let responseData = data else {
            print("No member data here.")
            return
        }
        // Parsing the new dictionary, but for member data this time
        do {
            if let jsonMembers = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any],
                let members = jsonMembers["members"] as? [[String: Any]] {
                for member in members {
                    
                    // Appending email addresses, still need to figure out how to go from an array
                    // to an array of arrays, and tie that to each list id. At least this part works.
                    if let address = member["email_address"] as? String {
                        emailAddresses.append(address)
                    } else { continue }
                }
                
               
            }
                
            else {
                print("Can't convert data from JSON")
                return
            }
            
            guard let emailAddress = emailAddresses as? [String] else {
                print("Can't get the email addresses.")
                return
            }
        } catch  {
            print("Can't get email addresses.")
            return
        }
    }
    
    task.resume()
}
