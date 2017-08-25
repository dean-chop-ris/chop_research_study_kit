//
//  RedcapArm.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapArm {
    // Core Attributes
    var armNumber: Int { get { return base.attributeAsInt(key: "arm_num") } }
    var name: String { get { return base.attributeAsString(key: "name") } }
    
    // Other Attributes
    var armId: String { return id.asString }

    /////////////////////
    
    init(data: Dictionary<String, Any>) {
        
        var localBase = RedcapItemBase()
        
        localBase.coreAttributes = data
        
        id = RedcapArmId(armNum: localBase.attributeAsInt(key: "arm_num"))
        base = localBase
    }

    private var base = RedcapItemBase()
    private var id: RedcapArmId
}

struct RedcapArmId {
    
    var asString: String { return "arm_\(armNumber.description)" }
    
    init(armNum: Int) {
        armNumber = armNum
    }
    
    private var armNumber = 0
}

struct RedcapIdComponent {
    
    var asString: String { return itemName }

    init(redcapItemName: String) {

        for char in redcapItemName.characters {
            var str = ""
            
            if char.isUppercase {
                str = char.description.lowercased()
            }
            
            if char == " " {
                str = "_"
            }
            itemName += str
        }
    }
    
    private var itemName = ""
}

extension Character {
    var isUppercase: Bool {
        return "A"..."Z" ~= self
    }
}

struct RedcapArmCollection {
    
    var isEmpty: Bool {
        get { return arms.count == 0 }
    }
    
    var first: RedcapArm {
        
        return arms[0]
    }
    
    func filter(armName: String) -> RedcapArmCollection {
        
        var newCollection = RedcapArmCollection()
        
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
            
            let arm = RedcapArm(data: item)
            
            if loadAll || (arm.name == armName) {
                arms += [arm]
            }
        }
        
    }
    
    mutating func removeAll() {
        
        arms = [RedcapArm]()
    }
    
    mutating func add(item: RedcapArm) {
        
        arms += [item]
    }
    
    func find(eventId: String) -> RedcapArm? {

        for arm in arms {
            
            if eventId.contains(arm.armId) {
                return arm
            }
        }
        return nil
    }

    fileprivate var arms = [RedcapArm]()
}

extension RedcapArmCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> RedcapArmIterator {
        
        return RedcapArmIterator(withArray: arms)
    }
}


//////////////////////////////////////////////////////////////////////
// RedcapArmIterator
//////////////////////////////////////////////////////////////////////

struct RedcapArmIterator : IteratorProtocol {
    
    var values: [RedcapArm]
    var indexInSequence = 0
    
    init(withArray dictionary: [RedcapArm]) {
        values = [RedcapArm]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> RedcapArm? {
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



/*
 
 [["arm_num": 1, "name": Drug A]]
 
 */
