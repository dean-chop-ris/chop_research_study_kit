//
//  ChopModuleStepCollection.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/17/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

struct ChopModuleStepCollection {

    var rkSteps: [ORKStep] {
        get {
            var rkStepsList = [ORKStep]()
            
            for stepKey in stepKeysInOrder {
                guard let step = steps[stepKey] else {
                    continue
                }
                if let rkStep = step as? ChopRKTaskStep {
                    rkStep.populateRKStepArray(stepArray: &rkStepsList)
                }
            }
            return rkStepsList
        }
    }

    init() {
        steps = [String:ChopResearchStudyModuleStep]()
        stepKeysInOrder = [String]()
    }
    
    
    func findStep(withId stepId: String) -> ChopResearchStudyModuleStep? {
        if let step = steps[stepId] {
            return step
        }
        return nil
    }

    func nextStep(fromStepId: String) -> ChopResearchStudyModuleStep? {
        
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

    mutating func add(element: ChopResearchStudyModuleStep) -> Bool {

        steps[element.stepId] = element
        stepKeysInOrder += [element.stepId]

        return true
    }

    mutating func remove(element: ChopResearchStudyModuleStep) {
        
        steps.removeValue(forKey: element.stepId)
    }
    
    mutating func captureResults(withResult taskResult: ORKTaskResult) {
        
        var newStepCollection = [String:ChopResearchStudyModuleStep]()

        for step in steps.values {
        
            if step is HasModuleStepDataToCapture {
            
                var dataStep = step as! HasModuleStepDataToCapture
            
                dataStep.captureResult(fromORKTaskResult: taskResult)
                newStepCollection[dataStep.stepId] = dataStep
            } else {
                newStepCollection[step.stepId] = step
            }
        }
        self.steps = newStepCollection
    }
    
    
    fileprivate var steps: [String:ChopResearchStudyModuleStep]
    private var stepKeysInOrder: [String]
}

extension ChopModuleStepCollection: Sequence {
    // MARK: Sequence

    // Protocol: Sequence (allows iteration over collection)
    
    public func makeIterator() -> ModuleStepIterator {
        // create a new one? created when a new iteration is started?
        return ModuleStepIterator(withChopSurveyDictionary: steps)
        //return self.moduleStepIterator
    }
}


//////////////////////////////////////////////////////////////////////
// ModuleStepIterator
//////////////////////////////////////////////////////////////////////

struct ModuleStepIterator : IteratorProtocol {
    
    var values: [ChopResearchStudyModuleStep]
    var indexInSequence = 0
    
    init(withChopSurveyDictionary dictionary: [String:ChopResearchStudyModuleStep]) {
        values = [ChopResearchStudyModuleStep]()
        for value in dictionary.values {
            self.values += [value]
        }
    }
    
    mutating func next() -> ChopResearchStudyModuleStep? {
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
