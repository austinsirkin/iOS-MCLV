//
//  APICall.swift
//  MailChimpTest
//
//  Created by Austin Sirkin on 1/6/18.
//  Copyright © 2018 Austin Sirkin. All rights reserved.
//

import Foundation

/* Didn't end up using any of this because I couldn't get it to work. I read that using objects as a way to parse and store the data retreived from API calls was the best way to do it, but I wasn't able to figure it out in the time I had. Bleh!

struct List {
    let lists: [String:Any]
}

extension List {
    init?(todo: [String: Any]) {
        guard let lists = todo["lists"] as? [String: Any]!,
            let name = lists["name"],
            let id = lists["id"]
            else {
                return nil
        }
       self.lists = lists

    }
}

*/




























