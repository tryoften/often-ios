//
//  ShareViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/29/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    var lyric: Lyric?

    @IBOutlet weak var insertButtonView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    
    var delegate: ShareViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.insertButtonView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.cancelButtonView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.insertButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("insertButtonTapped")))
        self.cancelButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("cancelButtonTapped")))
        
        self.insertButtonView.userInteractionEnabled = true
        self.cancelButtonView.userInteractionEnabled = true
        
        self.insertButtonView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let view = self.view as ALView
        let insertView = insertButtonView as ALView
        let cancelView = cancelButtonView as ALView
        
        self.view.addConstraints([
            insertView.al_width <= view.al_width * 0.5,
            insertView.al_height == insertView.al_width,
            insertView.al_left == view.al_left,
            insertView.al_top == view.al_top,
            cancelView.al_left == insertView.al_right,
            cancelView.al_width == insertView.al_width,
//            cancelView.al_right == view.al_right,
            cancelView.al_height == insertView.al_height,
            cancelView.al_top == view.al_top
        ])
    }
    
    func insertButtonTapped() {
        
    }
    
    func cancelButtonTapped() {
        self.delegate?.shareViewControllerDidCancel(self)
    }
}

protocol ShareViewControllerDelegate {
    func shareViewControllerDidCancel(shareViewController: ShareViewController)
}
