//
//  SectionPickerViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/14/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class SectionPickerViewController: UIViewController {
    
    var categoryService: CategoryService?
    var currentCategory: Category?
    var panRecognizer: UIPanGestureRecognizer!
    var drawerOpened: Bool = false
    var startingPoint: CGPoint?
    var pickerView: SectionPickerView!

    override func loadView() {
        view = SectionPickerView(frame: CGRectZero)
        pickerView = (view as SectionPickerView)
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: "didPanView:")
        view.addGestureRecognizer(panRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPanView(recognizer: UIPanGestureRecognizer) {
        
        struct Position {
            static var value: CGFloat = 0
            static var isAbove: Bool = false
            static var isBelow: Bool = false
        }
        
        if recognizer.state == .Began {
            startingPoint = recognizer.translationInView(view)
            return
        }
        
        let translation = recognizer.translationInView(view)
        let yChange: CGFloat = abs(translation.y - startingPoint!.y)
        let threshold = view.superview!.bounds.height / 2
        let velocity = recognizer .velocityInView(view)
        
        if recognizer.state == .Ended {
            Position.isAbove = false
            Position.isBelow = false

            if yChange > threshold {
                if velocity.y < 0 {
                    pickerView.open()
                } else {
                    pickerView.close()
                }
                pickerView.drawerOpened = !pickerView.drawerOpened
            } else {
                if pickerView.drawerOpened {
                    pickerView.open()
                } else {
                    pickerView.close()
                }
            }
            return
        }
        
        if !pickerView.drawerOpened {
            pickerView.heightConstraint?.constant = SectionPickerViewHeight + yChange
        } else {
            pickerView.heightConstraint?.constant =
                pickerView.superview!.bounds.height - yChange
        }
        
        if yChange > threshold && !Position.isAbove {
            println("animate arrow down")
            pickerView.animateArrow(pointingUp: true)
            Position.isAbove = true
            Position.isBelow = false
        } else if yChange < threshold && !Position.isBelow {
            println("animate arrow up")
            pickerView.animateArrow(pointingUp: false)
            Position.isBelow = true
            Position.isAbove = false
        }
        
        Position.value = yChange
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
