//
//  SearchSuggestionTableViewCell.swift
//  Often
//
//  Created by Luc Succes on 8/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ClearColor
        textLabel!.font = SubtitleFont
        selectionStyle = .None
    }

    required init(coder aDecoder: NSCoder) {
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

}
