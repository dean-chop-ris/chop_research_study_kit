//
//  ChopUser.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/31/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ChopUser {
    
    var remoteDataStoreId: String {
        get { return _remoteDataStoreId }
        set { _remoteDataStoreId = newValue }
    }
    
    var email: String {
        get { return _email }
        set { _email = newValue }
    }
    
    init(withDbObject dbObject: NSManagedObject) {
        _remoteDataStoreId = (dbObject.value(forKeyPath: "remoteDataStoreId") as? String)!
        _email = (dbObject.value(forKeyPath: "email") as? String)!
    }

    init() {
        _remoteDataStoreId = "__Uninitialized remoteDataStoreId"
        _email = "__Uninitialized email"
    }

    func commit() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "ChopUserCoreDataEntity",
                                       in: managedContext)!
        let user = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        user.setValue(_remoteDataStoreId, forKeyPath: "remoteDataStoreId")
        user.setValue(_email, forKeyPath: "email")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //private var dbObject: NSManagedObject
    private var _remoteDataStoreId: String
    private var _email: String
}


struct ChopUserCollection {
    
    var isEmpty: Bool {
        get { return users.count == 0 }
    }
    
    var first: ChopUser {
        
        return users[0]
    }

    init(fromDataStore: Bool = false) {
        
        if fromDataStore {
 
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "ChopUserCoreDataEntity")
            
            do {
                let userDbObjects = try managedContext.fetch(fetchRequest)
                
                for userDbObject in userDbObjects {
                    
                    let user = ChopUser(withDbObject: userDbObject)
                    
                    users += [user]
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    /*
    func filter(armName: String) -> ChopUserCollection {
        
        var newCollection = ChopUserCollection()
        
        for item in arms {
            
            if (item.name == armName) {
                newCollection.add(item: item)
            }
        }
        return newCollection
    }
    
    mutating func loadFromJSON(data: [Dictionary<String, Any>], forInstrumentName armName: String = "") {
        
        let loadAll = armName.isEmpty
        
        for item in data {
            
            let arm = ChopUser(data: item)
            
            if loadAll || (arm.name == armName) {
                arms += [arm]
            }
        }
        
    }
    */
    mutating func removeAll() {
        
        users = [ChopUser]()
    }
    
    mutating func add(item: ChopUser) {
        
        users += [item]
    }
   /*
    func find(eventId: String) -> ChopUser? {
        
        for arm in arms {
            
            if eventId.contains(arm.armId) {
                return arm
            }
        }
        return nil
    }
    */
    fileprivate var users = [ChopUser]()
}

extension ChopUserCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> ChopUserIterator {
        
        return ChopUserIterator(withArray: users)
    }
}


//////////////////////////////////////////////////////////////////////
// ChopUserIterator
//////////////////////////////////////////////////////////////////////

struct ChopUserIterator : IteratorProtocol {
    
    var values: [ChopUser]
    var indexInSequence = 0
    
    init(withArray dictionary: [ChopUser]) {
        values = [ChopUser]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> ChopUser? {
        if indexInSequence < values.count {
            let element = values[indexInSequence]
            indexInSequence += 1
            
            return element
        } else {
            indexInSequence = 0
            return nil
        }
    }
}
