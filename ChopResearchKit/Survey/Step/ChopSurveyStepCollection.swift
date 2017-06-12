//
//  ChopSurveyStepCollection.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/12/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation
import ResearchKit

/*
struct ChopSurveyStepCollection: Sequence {
    
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
        steps = [String:ChopSurveyStep]()
        stepKeysInOrder = [String]()
        surveyStepIterator = SurveyStepIterator(withChopSurveyDictionary: steps)
    }
    
    
    func findStep(withId stepId: String) -> ChopSurveyStep? {
        if let step = steps[stepId] {
            return step
        }
        return nil
    }
    
    func nextStep(fromStepId: String) -> ChopSurveyStep? {
        
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

    mutating func add(element: ChopSurveyStep) -> Bool {
        
        steps[element.stepId] = element
        stepKeysInOrder += [element.stepId]
        
        if element is ChopSurveyCompletionStep {
            //
            // Last element has been added; we can initialize the iterator
            //
            self.surveyStepIterator = SurveyStepIterator(withChopSurveyDictionary: steps)
        }
        
        return true
    }
    
    mutating func remove(element: ChopSurveyStep) {
        
        steps.removeValue(forKey: element.stepId)
    }
    
    mutating func captureResults(withResult taskResult: ORKTaskResult) {
        for step in steps.values {
            
            if step is ChopSurveyQuestion {

                var question = step as! ChopSurveyQuestion
                
                question.captureResult(fromORKTaskResult: taskResult)
            }
        }
    }
    
    // Protocol: Sequence (allows iteration over collection)
    
    public func makeIterator() -> SurveyStepIterator {
        return self.surveyStepIterator
    }
    
    // private elements
    private var steps: [String:ChopSurveyStep]
    private var stepKeysInOrder: [String]
    private var surveyStepIterator: SurveyStepIterator
}


struct SurveyStepIterator : IteratorProtocol {
    
    var values: [ChopSurveyStep]
    var indexInSequence = 0
    
    init(withChopSurveyDictionary dictionary: [String:ChopSurveyStep]) {
        values = [ChopSurveyStep]()
        for value in dictionary.values {
            self.values += [value]
        }
    }
    
    mutating func next() -> ChopSurveyStep? {
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
*/
