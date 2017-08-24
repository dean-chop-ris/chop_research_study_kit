//
//  ChopModuleStepWorkflowLogic.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/23/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct ChopModuleStepWorkflowLogic {
    
    public private(set) var parentStepId: String

    public var expressions: [ChopModuleStepWorkflowLogicExpression] {
        
        return logicExpressions
    }
    
    public var isEmpty: Bool {
        
        return logicExpressions.count == 0
    }
    
    init(parentStepIdentifier: String) {
        
        parentStepId = parentStepIdentifier
    }

    mutating func add(stepIdentifier: String, answer: Int) {
        
        logicExpressions.append(ChopModuleStepWorkflowLogicExpression(
            stepId: stepIdentifier,
            relation: ChopModuleStepWorkflowLogicRelation.Equals,
            answerValue: answer.description))
    }

    mutating func add(expressionToAdd: ChopModuleStepWorkflowLogicExpression) {
        
        logicExpressions.append(expressionToAdd)
    }

    private var logicExpressions = [ChopModuleStepWorkflowLogicExpression]()
}

enum ChopModuleStepWorkflowLogicRelation {
    case Equals
}

struct ChopModuleStepWorkflowLogicExpression {
    
    public var stepId = ""
    public var relation = ChopModuleStepWorkflowLogicRelation.Equals
    public var answerValue = ""
}
