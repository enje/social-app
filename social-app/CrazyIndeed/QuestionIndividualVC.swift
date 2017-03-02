//
//  QuestionIndividualVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 3/1/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit

class QuestionIndividualVC: UIViewController, UIPageViewControllerDelegate {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white


        // Do any additional setup after loading the view.
    }
    
    func configureQuestion(qanda: QAndA){
        let lblNew = UILabel()
        lblNew.backgroundColor = UIColor.white
        lblNew.center = self.view.center
        lblNew.frame.size = CGSize(width: self.view.frame.width - 10, height: 40)
        lblNew.frame.origin = CGPoint(x: 5, y: self.view.frame.height / 2)
        lblNew.textColor = UIColor.black
        lblNew.text = qanda.question
        self.view.addSubview(lblNew)
    }

}
