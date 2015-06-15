//
//  SignUpAddArtistsTableViewCell.swift
//  
//
//  Created by Kervins Valcourt on 6/2/15.
//
//

import Foundation

class SignUpAddArtistsTableViewCell: UITableViewCell {
    var artistNameLabel : UILabel!
    var lyricsCountLabel : UILabel!
    var artistImageView : UIImageView!
    var selectionButton : UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        artistImageView = UIImageView()
        artistImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistImageView.contentMode = .ScaleAspectFill
        artistImageView.backgroundColor = UIColor.blueColor()
        artistImageView.layer.cornerRadius  = 20
        artistImageView.layer.masksToBounds = true
        
        
        artistNameLabel = UILabel()
        artistNameLabel.textAlignment = .Left
        artistNameLabel.font = UIFont(name: "OpenSans", size: 14)
        artistNameLabel.textColor = UIColor(fromHexString: "#202020")
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        lyricsCountLabel = UILabel()
        lyricsCountLabel.textAlignment = .Left
        lyricsCountLabel.font = UIFont(name: "OpenSans", size: 10)
        lyricsCountLabel.textColor = SubtitleGreyColor
        lyricsCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        selectionButton = UIButton()
        selectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        selectionButton.setImage(UIImage(named: "Unselected"), forState: .Normal)
        selectionButton.setImage(UIImage(named: "SelectedButton"), forState: .Selected)
        
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(artistImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(lyricsCountLabel)
        contentView.addSubview(selectionButton)
        
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            artistImageView.al_left == al_left + 15,
            artistImageView.al_width == 40,
            artistImageView.al_height == 40,
            artistImageView.al_centerY == al_centerY,
            
            artistNameLabel.al_top == al_top + 15,
            artistNameLabel.al_left == artistImageView.al_right + 20,
            artistNameLabel.al_centerX == al_centerX,
            
            lyricsCountLabel.al_top == artistNameLabel.al_bottom,
            lyricsCountLabel.al_left == artistImageView.al_right + 20,
            lyricsCountLabel.al_centerX == al_centerX,
            
            
            selectionButton.al_centerY == al_centerY,
            selectionButton.al_width == 40,
            selectionButton.al_height == 40,
            selectionButton.al_right == al_right - 5,
            ])
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: "signUpAddArtistsTableViewCell")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}