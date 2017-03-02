//
//  QuestionPage.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/23/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit

class QuestionPage: UIView {
    

    var QAndA: QAndA!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurePage(qanda: QAndA){
        self.QAndA = qanda
        
        /*if let questionTemp = self.QAndA.question as String!{
            if questionTemp  != nil {
                questionLab.text = questionTemp
            }
            else{
                questionLab.text = ""
            }
            
        }
        else{
            questionLab.text = ""
        }*/
    }
}
