//
//  SignupQuestionsVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/23/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignupQuestionsVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var questionPage = QuestionPage()

    var qAndaList = [QAndA]()    //lists questions
    
    var tempArr = [UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        print("I have a question..." + String(describing: qAndaList))
        
        for i: Int in 0 ..< qAndaList.count{
            tempArr.append(self.newQuestionViewController(number: i))
        }
        
        //load first vc
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    //go down
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    //go up
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        print("controller index " + String(viewControllerIndex))
        print("controller count " + String(orderedViewControllersCount))
        
        guard orderedViewControllersCount != nextIndex else {
            self.performSegue(withIdentifier: "gotoSocialFromQuestions", sender: self)
            //orderedViewControllers[viewControllerIndex].dismiss(animated: true, completion: nil)
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    //make array of view controllers for page view
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return self.tempArr
    }()
    
    //creates the view controller
    private func newQuestionViewController(number: Int) -> QuestionIndividualVC/*UIViewController*/ {
        let questionView = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionIndividualVC
        questionView.configureQuestion(qanda: qAndaList[number])
        return questionView
    }
    
}
