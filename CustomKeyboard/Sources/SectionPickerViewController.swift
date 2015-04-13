//
//  SectionPickerViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/14/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Analytics
import FlurrySDK

class SectionPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var keyboardViewController: KeyboardViewController!
    var panRecognizer: UIPanGestureRecognizer!
    var tapRecognizer: UITapGestureRecognizer!
    var drawerOpened: Bool = false
    var startingPoint: CGPoint?
    var pickerView: SectionPickerView!
    var categoryService: CategoryService?
    var currentCategory: Category?
    var categories: [Category]? {
        didSet {
            pickerView.categoriesTableView.reloadData()
            if (categories!.count > 1) {
                currentCategory = categories![1]
                pickerView.delegate?.didSelectSection(pickerView, category: currentCategory!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.pickerView.currentCategoryLabel.text = self.currentCategory!.name
                })
            }
        }
    }

    override func loadView() {
        view = SectionPickerView(frame: CGRectZero)
        pickerView = (view as SectionPickerView)
        pickerView.categoriesTableView.dataSource = self
        pickerView.categoriesTableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: "didPanView:")
//        view.addGestureRecognizer(panRecognizer)
        
        let toggleSelector = Selector("toggleDrawer")
        tapRecognizer = UITapGestureRecognizer(target: self, action: toggleSelector)
        pickerView.toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        pickerView.currentCategoryLabel.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleDrawer() {
        
        if tapRecognizer.state == .Ended {
            UIView.animateWithDuration(0.3, animations: {
                self.pickerView.backgroundColor = UIColor(fromHexString: "#121314")
            })
        }
        
        SEGAnalytics.sharedAnalytics().track("Drawer_Toggled")
        if (!pickerView.drawerOpened) {
            pickerView.open()
            Flurry.logEvent("Drawer_Toggled", timed: true)
        } else {
            pickerView.close()
            var params = [String: String]()
            
            if let currentCategory = currentCategory {
                params["current_category_id"] = currentCategory.id
            }
            Flurry.endTimedEvent("Drawer_Toggled", withParameters: params)
        }
        pickerView.drawerOpened = !pickerView.drawerOpened
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        UIView.animateWithDuration(0.3, animations: {
            self.pickerView.backgroundColor = UIColor.blackColor()
        })
    }
    
    func didPanView(recognizer: UIPanGestureRecognizer) {
        
        struct Position {
            static var value: CGFloat = 0
            static var isAbove: Bool = false
            static var isBelow: Bool = false
        }
        
        if recognizer.state == .Began {
            startingPoint = recognizer.translationInView(view)
            var frame = self.pickerView.frame
            frame.size.height = view.superview!.bounds.height
            self.pickerView.frame = frame
            return
        }
        
        let translation = recognizer.translationInView(view)
        let yChange: CGFloat = abs(translation.y - startingPoint!.y)
        let threshold = view.superview!.bounds.height / 2
        let velocity = recognizer.velocityInView(view)
        
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
        
        println("change y: \(translation.y)")
        var animationSpeed = NSTimeInterval(1 / velocity.y)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationSpeed)
        var frame = self.pickerView.frame
        frame.origin.y = min(max(startingPoint!.y + translation.y, CGRectGetHeight(frame)), SectionPickerViewHeight)
        self.pickerView.frame = frame
        UIView.commitAnimations()
        
        startingPoint = translation
        
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
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var category = categories![indexPath.row] as Category;
        
        currentCategory = category
        pickerView.currentCategoryLabel.text = category.name
        toggleDrawer()
        
        SEGAnalytics.sharedAnalytics().track("Category_Selected", properties: [
            "category_name": category.name,
            "category_id": category.id
        ])
        
        if category.id == "recently" {
            pickerView.delegate?.didSelectSection(pickerView, category: category)
        } else {
            categoryService?.requestLyrics(category.id, artistIds: nil).onSuccess({ lyrics in
                self.pickerView.delegate?.didSelectSection(self.pickerView, category: category)
                return
            })
        }
    }

    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        let category = categories![indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = pickerView.selectedBgView
        
        if let label = cell.textLabel {
            label.text = category.name
            label.font = UIFont(name: "Lato-Light", size: 20)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = categories {
            return categories.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
