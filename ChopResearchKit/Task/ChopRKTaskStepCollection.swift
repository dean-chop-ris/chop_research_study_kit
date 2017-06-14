//
//  ChopRKTaskStepCollection.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/31/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopRKTaskStepCollection: Sequence {
    
    var rkSteps: [ORKStep] {
        get {
            var rkStepsList = [ORKStep]()
            
            for stepKey in stepKeysInOrder {
                guard let step = steps[stepKey] else {
                    continue
                }
                step.populateRKStepArray(stepArray: &rkStepsList)
            }
            return rkStepsList
        }
    }
    
    init() {
        steps = [String:ChopRKTaskStep]()
        stepKeysInOrder = [String]()
    }
    
    
    func findStep(withId stepId: String) -> ChopRKTaskStep? {
        if let step = steps[stepId] {
            return step
        }
        return nil
    }
 
    func nextStep(fromStepId: String) -> ChopRKTaskStep? {
        
        var foundFromKey = false
        
        for key in stepKeysInOrder {
            if foundFromKey {
                return steps[key]
            }
            if key == fromStepId {
                foundFromKey = true
            }
        }
        return nil
    }
    
    mutating func add(element: ChopRKTaskStep) -> Bool {
        
        steps[element.stepId] = element
        stepKeysInOrder += [element.stepId]
        
        return true
    }
    
    mutating func remove(element: ChopRKTaskStep) {
        
        steps.removeValue(forKey: element.stepId)
    }
    
    mutating func captureResults(withResult taskResult: ORKTaskResult) {
        
        var newStepCollection = [String:ChopRKTaskStep]()
        
        for step in steps.values {
            
            if step is HasModuleStepDataToCapture {
                
                var question = step as! HasModuleStepDataToCapture
                
                question.captureResult(fromORKTaskResult: taskResult)
                newStepCollection[question.stepId] = step
            } else {
                newStepCollection[step.stepId] = step
            }
        }
        self.steps = newStepCollection
    }
    
    // Protocol: Sequence (allows iteration over collection)
    
    public func makeIterator() -> ChopRKTaskStepIterator {
        return ChopRKTaskStepIterator(withChopSurveyDictionary: steps)
    }
    
    // private elements
    private var steps: [String:ChopRKTaskStep]
    private var stepKeysInOrder: [String]
}


struct ChopRKTaskStepIterator : IteratorProtocol {
    
    var values: [ChopRKTaskStep]
    var indexInSequence = 0
    
    init(withChopSurveyDictionary dictionary: [String:ChopRKTaskStep]) {
        values = [ChopRKTaskStep]()
        for value in dictionary.values {
            self.values += [value]
        }
    }
    
    mutating func next() -> ChopRKTaskStep? {
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
