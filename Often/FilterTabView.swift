//
//  FilterTabView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/5/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

enum FilterTabViewType: Int {
    case Gifs = 0
    case Quotes
    case Images
}

class FilterTabView: UIView {
    let highlightBarView: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    var highlightBarWidthConstraint: NSLayoutConstraint?
    var delegate: FilterTabDelegate?
    var buttons: [UIButton] = []
    
    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
        NSForegroundColorAttributeName: BlackColor
    ]
    
    var mediaTypes: [MediaType] = [] {
        didSet {
            resetTabButtons()
            setupTabView()
            setupButtonLayout()
        }
    }
    
    override init(frame: CGRect) {
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor
        
        super.init(frame: frame)
        backgroundColor = WhiteColor
        
        addSubview(highlightBarView)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTabView() {
        
        var index = 0
        for type in mediaTypes {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.textAlignment = .Center
            let title = "\(type.rawValue)s"
            let titleString = NSAttributedString(string: title.uppercaseString, attributes: attributes)
            button.setAttributedTitle(titleString, forState: .Normal)
            button.addTarget(self, action: #selector(FilterTabView.buttonDidTap(_:)), forControlEvents: .TouchUpInside)
            button.tag = index
            buttons.append(button)
            addSubview(button)
            index += 1
        }
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left
        highlightBarLeftConstraint?.constant = 0.0
        highlightBarWidthConstraint = highlightBarView.al_width == al_width
        
        addConstraints([
            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            highlightBarLeftConstraint!,
        ])
    }
    
    func setupButtonLayout() {
        var buttonIndex: CGFloat = 0
        for button in buttons {
            let buttonLeftConstraint = button.al_left == al_left
            buttonLeftConstraint.constant = (UIScreen.mainScreen().bounds.width / CGFloat(buttons.count)) * buttonIndex
            
            addConstraints([
                button.al_top == al_top,
                button.al_bottom == al_bottom,
                buttonLeftConstraint,
                button.al_width == al_width / CGFloat(buttons.count),
                highlightBarView.al_width == al_width / CGFloat(buttons.count)
                
                ])
            
            buttonIndex++
        }
    }
    
    func buttonDidTap(sender: UIButton) {
        
        guard let title = sender.titleLabel?.text else {
            return
        }
        
        highlightBarLeftConstraint?.constant = (UIScreen.mainScreen().bounds.width / CGFloat(buttons.count)) * CGFloat(sender.tag)
        
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
        
        switch title.lowercaseString {
        case "gifs":
            delegate?.gifTabSelected()
        case "quotes":
            delegate?.quotesTabSelected()
        case "images":
            delegate?.imagesTabSelected()
        default: break
        }
    }
    
    func resetTabButtons() {
        for view in subviews {
            if let _ = view as? UIButton {
                view.removeFromSuperview()
            }
        }
        buttons.removeAll()
    }

}

protocol FilterTabDelegate {
    func gifTabSelected()
    func quotesTabSelected()
    func imagesTabSelected()
}