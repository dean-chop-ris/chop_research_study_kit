//
//  ChopRankingItem.swift
//  ParentStudyAlpha
//
//  Created by Ritter, Dean on 5/19/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation


struct ChopRankingItem {
    var web_Id: String
    var item_Id: String
    var displayString: String
    var rank: Int
    
    init(withWebId webId: String, withItemId itemId: String, withDisplayString displayStr: String) {
        
        self.web_Id = webId
        self.item_Id = itemId
        self.displayString = displayStr
        self.rank = -1
    }
}
