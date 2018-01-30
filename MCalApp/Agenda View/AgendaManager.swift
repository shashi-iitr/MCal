//
//  AgendaManager.swift
//  MCalApp
//
//  Created by shashi kumar on 30/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AgendaManager: NSObject {
    
    func fetchAgenda() -> NSDictionary {
        var agenda = NSDictionary()
        do {
            if let file = Bundle.main.url(forResource: "agenda", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                agenda = json as! NSDictionary
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return agenda
    }
}
