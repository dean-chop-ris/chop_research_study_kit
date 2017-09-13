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
    
    var isValid: Bool {
        
        return _email != ChopUser.NULL_EMAIL
    }
    
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
        _email = ChopUser.NULL_EMAIL
    }

    init(withEmail email: String) {

        self.init()

        let coreDataUser = get(emailToGet: email)
        
        if coreDataUser.isValid == false {
            return
        }
        
        load(coreDataEntityToLoad: coreDataUser.entity!)
    }

    func commit() -> Bool {

        var coreDataUser = get(emailToGet: _email)
        
        if coreDataUser.isValid == false {
            let entity = NSEntityDescription.entity(forEntityName: "ChopUserCoreDataEntity",
                                                    in: coreDataUser.context!)!
          
            coreDataUser.entity = NSManagedObject(entity: entity,
                                                  insertInto: coreDataUser.context) as? ChopUserCoreDataEntity
        }

        //
        // Update Values
        //
        unload(destCoreDataEntity: coreDataUser.entity!)
        
        //
        // Save back to CoreData
        //
        do {
            
            try coreDataUser.context?.save()
            
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    private func get(emailToGet: String) -> CoreDataUser {
        
        var coreDataUser = CoreDataUser()

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return coreDataUser
        }

        coreDataUser.context = appDelegate.persistentContainer.viewContext
        let userFetchRequest: NSFetchRequest<ChopUserCoreDataEntity> = ChopUserCoreDataEntity.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", emailToGet)
        
        userFetchRequest.predicate = predicate
        
        do {
            let fetchedUserSet = try coreDataUser.context?.fetch(userFetchRequest)
            
            if fetchedUserSet?.count == 0 {
                return coreDataUser
            }
            if (fetchedUserSet?.count)! > 1 {
                print("Error: Core Data returned more than one value for email: " + email)
                return coreDataUser
            }
            
            coreDataUser.entity = fetchedUserSet?[0]
            
            return coreDataUser
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return coreDataUser
        }
    }

    private mutating func load(coreDataEntityToLoad: ChopUserCoreDataEntity) {
        
        _email = coreDataEntityToLoad.email!
        _remoteDataStoreId = coreDataEntityToLoad.remoteDataStoreId!
    }

    private func unload(destCoreDataEntity: ChopUserCoreDataEntity) {
        
        destCoreDataEntity.email = _email
        destCoreDataEntity.remoteDataStoreId = _remoteDataStoreId
    }

    private var _remoteDataStoreId: String
    private var _email: String
    
    static private let NULL_EMAIL = "__Uninitialized email"
}

struct CoreDataUser {
    var isValid: Bool {
        return entity != nil
    }

    var entity: ChopUserCoreDataEntity? = nil
    var context: NSManagedObjectContext? = nil
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

    mutating func removeAll() {
        
        users = [ChopUser]()
    }
    
    mutating func add(item: ChopUser) {
        
        users += [item]
    }
    
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
