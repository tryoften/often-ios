//
//  FilterTabView.swift
//  Often
//
//  Created by Kervins Valcourt on 11/5/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FilterTabView: UIView {
    let highlightBarView: UIView
    var highlightBarLeftConstraint: NSLayoutConstraint?
    var leftTabButton: UIButton
    var rightTabButton: UIButton
    var delegate: FilterTabDelegate?
    
    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(value: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
        NSForegroundColorAttributeName: BlackColor!
    ]
    
    var leftTabButtonTitle: String? {
        didSet {
            let filterString = AttributedString(string: (leftTabButtonTitle?.uppercased())!, attributes: attributes)
            leftTabButton.setAttributedTitle(filterString, for: UIControlState())
        }
    }
    
    var rightTabButtonTitle: String? {
        didSet {
            let filterString = AttributedString(string: (rightTabButtonTitle?.uppercased())!, attributes: attributes)
            rightTabButton.setAttributedTitle(filterString, for: UIControlState())
        }
    }
    
    
    override init(frame: CGRect) {
        leftTabButton = UIButton()
        leftTabButton.translatesAutoresizingMaskIntoConstraints = false
        leftTabButton.titleLabel?.textAlignment = .center
        
        rightTabButton = UIButton()
        rightTabButton.translatesAutoresizingMaskIntoConstraints = false
        rightTabButton.titleLabel?.textAlignment = .center
        
        highlightBarView = UIView()
        highlightBarView.translatesAutoresizingMaskIntoConstraints = false
        highlightBarView.backgroundColor = TealColor
        
        super.init(frame: frame)
        backgroundColor = WhiteColor

        leftTabButton.addTarget(self, action: #selector(FilterTabView.leftButtonDidTap), for: .touchUpInside)
        rightTabButton.addTarget(self, action: #selector(FilterTabView.rightButtonDidTap), for: .touchUpInside)

        addSubview(leftTabButton)
        addSubview(rightTabButton)
        addSubview(highlightBarView)
        
         setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        highlightBarLeftConstraint = highlightBarView.al_left == al_left
        highlightBarLeftConstraint?.constant = (UIScreen.main().bounds.width / 2)
        
        addConstraints([
            rightTabButton.al_bottom == al_bottom,
            rightTabButton.al_top == al_top,
            rightTabButton.al_left == al_left,
            rightTabButton.al_width == al_width / 2,

            leftTabButton.al_bottom == al_bottom,
            leftTabButton.al_top == al_top,
            leftTabButton.al_right == al_right,
            leftTabButton.al_left == rightTabButton.al_right,
            leftTabButton.al_width == al_width / 2,

            highlightBarView.al_bottom == al_bottom,
            highlightBarView.al_height == 4,
            highlightBarView.al_width == al_width / 2,
            highlightBarLeftConstraint!
        ])
    }
    
    func leftButtonDidTap() {
        highlightBarLeftConstraint?.constant =  (UIScreen.main().bounds.width / 2)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.leftTabSelected()
    }
    
    func rightButtonDidTap() {
        highlightBarLeftConstraint?.constant = 0.0

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.rightTabSelected()
    }

    func disableButtonFor(_ type: MediaType, withAnimation: Bool = false) {
        switch type {
        case .Gif:
            leftTabButton.isUserInteractionEnabled = false
            leftTabButton.alpha = 0.30
            rightTabButton.alpha = 1
            highlightBarLeftConstraint?.constant = 0
        case .Lyric, .Quote:
            rightTabButton.isUserInteractionEnabled = false
            rightTabButton.alpha = 0.30
            leftTabButton.alpha = 1
            highlightBarLeftConstraint?.constant = (UIScreen.main().bounds.width / 2)
        default:
            break
        }

        if withAnimation {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }

        }

    }

    func resetTabButtons() {
        leftTabButton.isUserInteractionEnabled = true
        leftTabButton.alpha = 1
        rightTabButton.isUserInteractionEnabled = true
        rightTabButton.alpha = 1
    }

}

protocol FilterTabDelegate {
    func leftTabSelected()
    func rightTabSelected()
}
