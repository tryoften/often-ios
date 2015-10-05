//
//  SearchSuggestionTableViewCell.swift
//  Often
//
//  Created by Luc Succes on 8/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {
    var resultsCountLabel: UILabel

    
    var resultsCount: Int? {
        didSet {
            if let resultsCount = resultsCount {
                let attributes: [String: AnyObject] = [
                    NSKernAttributeName: NSNumber(float: 1.5),
                    NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 10)!,
                    NSForegroundColorAttributeName: UIColor.grayColor()
                ]
                let attributedString = NSAttributedString(string: "\(resultsCount) results".uppercaseString, attributes: attributes)
                resultsCountLabel.attributedText = attributedString
            } else {
                resultsCountLabel.text = ""
            }
        }
    }
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        resultsCountLabel = UILabel()
        resultsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ClearColor
        textLabel!.font = SubtitleFont
        selectionStyle = .None
        
        contentView.addSubview(resultsCountLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        addConstraints([
            resultsCountLabel.al_right == contentView.al_right - 15,
            resultsCountLabel.al_centerY == contentView.al_centerY
        ])
    }

}
