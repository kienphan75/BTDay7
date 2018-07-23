//
//  DatabaseManager.swift
//  Day7
//
//  Created by admin on 7/23/18.
//  Copyright © 2018 meosteam. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager{
    static let instanle = DatabaseManager()
    
    func coptyToDocument(){
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("contactDB.db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("contactDB.db")
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
   
    }
    
    func getAllContacts() -> [ContactModel]?{
        var contacts = [ContactModel]()
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("contactDB.db")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return nil
        }
        
        do {
            let rs = try database.executeQuery("select id, name, phone from contact", values: nil)
            while rs.next() {
                let x = rs.int(forColumn: "id")
                let y = rs.string(forColumn: "name")
                let z = rs.string(forColumn: "phone")
                contacts.append(ContactModel(id: Int(x), name: y!, phone: z!))
                
            }
            
            return contacts
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return nil
    }
    
    func insert(name: String, phone: String) {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("contactDB.db")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            try database.executeUpdate("insert into contact (name, phone) values (?, ?)", values: ["\(name)", "\(phone)"])
            //            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["e", "f", "g"])
            
//            let rs = try database.executeQuery("select id, name, phone from contact", values: nil)
//            while rs.next() {
//                let x = rs.int(forColumn: "id")
//                let y = rs.string(forColumn: "name")
//                let z = rs.string(forColumn: "phone")
//                contacts.append(ContactModel(id: Int(x), name: y!, phone: z!))
//
//            }
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()

    }
    
    
    
}
