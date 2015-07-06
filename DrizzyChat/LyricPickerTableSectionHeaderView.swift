//
//  LyricPickerTableSectionHeaderView.swift
//  October
//
//  Created by Luc Succes on 7/5/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class LyricPickerTableSectionHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel
    var highlightColorView: UIView
    
    override convenience init(reuseIdentifier: String?) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 10)
        
        highlightColorView = UIView()
        highlightColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundView = UIView()
        contentView.addSubview(titleLabel)
        contentView.addSubview(highlightColorView)
        contentView.backgroundColor = UIColor(fromHexString: "#f7f7f7").colorWithAlphaComponent(0.9)
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_left == contentView.al_left + 15,
            titleLabel.al_top == contentView.al_top,
            titleLabel.al_bottom == contentView.al_bottom,
            
            highlightColorView.al_bottom == contentView.al_bottom,
            highlightColorView.al_width == contentView.al_width,
            highlightColorView.al_left == contentView.al_left,
            highlightColorView.al_height == 2.0
        ])
    }

}
