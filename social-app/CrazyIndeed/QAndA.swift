//
//  QandA.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 3/1/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class QAndA{
    private var _correctAnswer: String!
    private var _question: String!
    private var _questionNumber: String!
    private var _key: String!
    private var _QandARef: FIRDatabaseReference!
    
    var key: String{
        return _key
    }
    
    var correctAnswer: String{
        if let AnswerTemp = _correctAnswer as String!{
            if AnswerTemp  != nil {
                return AnswerTemp
            }
            else{
                return ""
            }
            
        }
        else{
            return ""
        }
    }
    
    var question: String{
        if let questionTemp = _question as String!{
            if questionTemp  != nil {
                return questionTemp
            }
            else{
                return ""
            }
            
        }
        else{
            return ""
        }
    }
    
    var questionNumber: String{
        if let questionNumberTemp = _questionNumber as String!{
            if questionNumberTemp != nil {
                return questionNumberTemp
            }
            else{
                return ""
            }
            
        }
        else{
            return ""
        }
    }
    
    init(correctAnswer: String, question: String, questionNumber: String){
        self._correctAnswer = correctAnswer
        self._question = question
        self._questionNumber = questionNumber
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self._key = key
        
        print("Key: " + key)
        
        if let question = dictionary["question"] as? String{
            self._question = question
        }
        if let questionNumber = dictionary["questionNumber"] as? String{
            self._questionNumber = questionNumber
        }
        
        self._QandARef = DataService.ds.REF_QANDA.child(self._key)
    }
}
