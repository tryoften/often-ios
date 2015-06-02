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
        artistImageView.contentMode = .ScaleAspectFit
        artistImageView.image = UIImage(named: "ArtistPicture")
        
        artistNameLabel = UILabel()
        artistNameLabel.textAlignment = .Left
        artistNameLabel.font = UIFont(name: "OpenSans", size: 14)
        artistNameLabel.textColor = UIColor(fromHexString: "#202020")
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistNameLabel.text = "Sam Smith"
        
        lyricsCountLabel = UILabel()
        lyricsCountLabel.textAlignment = .Left
        lyricsCountLabel.font = UIFont(name: "OpenSans", size: 14)
        lyricsCountLabel.textColor = UIColor(fromHexString: "#202020")
        lyricsCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricsCountLabel.text = "128 Lyrics"
        
        selectionButton = UIButton()
        selectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        selectionButton.setImage(UIImage(named: "Unselected"), forState: .Normal)
        
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
            
            artistImageView.al_left == al_left + 5,
            artistImageView.al_width == 40,
            artistImageView.al_height == 40,
            artistImageView.al_centerY == al_centerY,
            
            artistNameLabel.al_top == al_top + 20,
            artistNameLabel.al_left == artistImageView.al_right + 15,
            artistNameLabel.al_right == selectionButton.al_left - 5,
            artistNameLabel.al_height == 20,
            artistNameLabel.al_centerX == al_centerX,
            
            lyricsCountLabel.al_top == artistNameLabel.al_bottom,
            lyricsCountLabel.al_left == artistImageView.al_right + 5,
            lyricsCountLabel.al_right == selectionButton.al_left - 5,
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