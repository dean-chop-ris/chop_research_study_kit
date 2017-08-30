//
//  RedcapInstrumentFieldBranchingLogic.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/23/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct RedcapInstrumentFieldBranchingLogic {
    
    public private(set) var parentStepId: String
    
    public var isEmpty: Bool {
    
        return branchingLogicAsString.isEmpty
    }
    
    public var workflowLogic: ChopModuleStepWorkflowLogic {

        var logic = ChopModuleStepWorkflowLogic(parentStepIdentifier: parentStepId)

        for expression in expressions {
            
            logic.add(stepIdentifier: expression.fieldName,
                      answer: Int(expression.answerValue)!)
        }
        return logic
    }
    
    
    public private(set) var expressions = [RedcapInstrumentFieldBranchingExpression]()
    
    init(parentStepIdentifier: String, logicAsString: String) {

        parentStepId = parentStepIdentifier
        branchingLogicAsString = logicAsString
        
        parse()
    }
    
    mutating func parse() {

        let parser = RedcapLogicParser()
        
        expressions = parser.parseBranchingLogic(branchingLogicAsString: branchingLogicAsString)
    }
    
    private var branchingLogicAsString: String
}

struct RedcapInstrumentFieldBranchingExpression {
    
    var fieldName: String { return baseExpression.stepId }
    var relation: ChopModuleStepWorkflowLogicRelation
                { return baseExpression.relation }
    var answerValue: String { return baseExpression.answerValue }

    init(expressionAsString: String) {
        
        expressionLogicAsString = expressionAsString
        
        parse()
    }

    mutating func parse() {
    
        let parser = RedcapLogicParser()
        
        baseExpression = parser.parseExpression(expressionLogicAsString: expressionLogicAsString)
    }

    private var baseExpression = ChopModuleStepWorkflowLogicExpression()
    private var expressionLogicAsString: String
}

struct RedcapLogicParser {
    
    func parseBranchingLogic(branchingLogicAsString: String) -> [RedcapInstrumentFieldBranchingExpression] {
    
        var expressions = [RedcapInstrumentFieldBranchingExpression]()
        
        if branchingLogicAsString.isEmpty {
            return expressions
        }
        
        let expressionStrings = branchingLogicAsString.components(separatedBy: " and ")
        
        for expressionString in expressionStrings {
            
            let expression = RedcapInstrumentFieldBranchingExpression(expressionAsString: expressionString)
            
            expressions += [expression]
        }
        return expressions
    }
    
    func parseExpression(expressionLogicAsString: String) -> ChopModuleStepWorkflowLogicExpression {
        
        var workflowLogicExpression = ChopModuleStepWorkflowLogicExpression()
        
        let components = expressionLogicAsString.components(separatedBy: " ")
        
        if components.count != 3 {
            print("ERROR: Parse error of Redcap branching logic expression components: \(expressionLogicAsString)")
            
            return workflowLogicExpression
        }
        
        /////////////////////////////////////////////
        // field name
        /////////////////////////////////////////////
        let rawFieldName = components[0].trim()
        
        // strip [ and ] from either end
        workflowLogicExpression.stepId = rawFieldName.substring(
            startIndex: 1,
            len: rawFieldName.length - 1)
        
        /////////////////////////////////////////////
        // relation
        /////////////////////////////////////////////
        
        // Always "Equals"... for now
        
        /////////////////////////////////////////////
        // answer value
        /////////////////////////////////////////////
        let rawAnswerValue = components[2].trim()
        
        // strip [ and ] from either end
        workflowLogicExpression.answerValue = rawAnswerValue.substring(
            startIndex: 1,
            len: rawAnswerValue.length - 1)
        
        return workflowLogicExpression
    }
}
