//
//  ChopItemSelectChoice.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/21/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopItemSelectChoice {
    
    static let NO_VALUE = Int.min
    
    var hasValue = false
    var value = 0
    var description = ""
}

//////////////////////////////////////////////////////////////////////
// ChopItemSelectChoiceCollection
//////////////////////////////////////////////////////////////////////

struct ChopItemSelectChoiceCollection {
    
    var isEmpty: Bool {
        get { return items.count == 0 }
    }

    var count: Int {
        
        return items.count
    }

    var first: ChopItemSelectChoice? {
        
        return count > 0 ? items[0] : nil
    }

    var last: ChopItemSelectChoice? {
        
        return count > 0 ? items[items.count - 1] : nil
    }

    var rkTextChoices: [ORKTextChoice] {
        
        var textChoices = [ORKTextChoice]()
        var choiceIndex = 0
        
        for item in items {
//            let rkVal = item.hasValue ? item.value : ChopItemSelectChoice.NO_VALUE
            let rkVal = item.hasValue ? item.value : choiceIndex
            
            textChoices += [ORKTextChoice(
                text: item.description,
                value: rkVal as NSCoding & NSCopying & NSObjectProtocol)]
            
            choiceIndex += 1
        }
        return textChoices
    }
    
    mutating func removeAll() {
        
        items = [ChopItemSelectChoice]()
    }
    
    mutating func add(item: ChopItemSelectChoice) {
        
        items += [item]
    }
    
    fileprivate var items = [ChopItemSelectChoice]()
}

extension ChopItemSelectChoiceCollection: Sequence {
    // MARK: Sequence
    public func makeIterator() -> ChopItemSelectChoiceIterator {
        
        return ChopItemSelectChoiceIterator(withArray: items)
    }
}


//////////////////////////////////////////////////////////////////////
// ChopItemSelectChoiceIterator
//////////////////////////////////////////////////////////////////////

struct ChopItemSelectChoiceIterator : IteratorProtocol {
    
    var values: [ChopItemSelectChoice]
    var indexInSequence = 0
    
    init(withArray dictionary: [ChopItemSelectChoice]) {
        values = [ChopItemSelectChoice]()
        for value in dictionary {
            self.values += [value]
        }
    }
    
    mutating func next() -> ChopItemSelectChoice? {
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
