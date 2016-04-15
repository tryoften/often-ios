//
//  GifCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//
import Spring

class GifCollectionViewCell : UICollectionViewCell {
    
    var overlayView: GifCellOverlayView
    var backgroundImageView: FLAnimatedImageView
    var favoriteRibbon: UIImageView
    
    var gifURL: NSURL? {
        didSet {
            if let animatedURL = gifURL {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: animatedURL)
                    let animatedImage = FLAnimatedImage(animatedGIFData: data)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.backgroundImageView.animatedImage = animatedImage
                    }
                }
            }
        }
    }
    
    var overlayVisible: Bool {
        didSet {
            if overlayVisible {
                overlayView.hidden = false
                overlayView.showButtons({})
                overlayView.favoriteButton.selected = itemFavorited
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.overlayView.alpha = 0.0
                    }, completion: { done in
                        self.overlayView.hidden = true
                        self.overlayView.alpha = 1.0
                })
            }
        }
    }
    
    var itemFavorited: Bool {
        didSet {
            overlayView.favoriteButton.selected = itemFavorited
            favoriteRibbon.hidden = !itemFavorited
        }
    }
    
    override init(frame: CGRect) {
        backgroundImageView = FLAnimatedImageView()
        
        favoriteRibbon = UIImageView()
        favoriteRibbon.translatesAutoresizingMaskIntoConstraints = false
        favoriteRibbon.image = StyleKit.imageOfFavoritedstate(frame: CGRectMake(0, 0, 62, 62), scale: 0.5)
        favoriteRibbon.hidden = true
        
        overlayView = GifCellOverlayView()
        overlayView.hidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        overlayVisible = false
        itemFavorited = false
        
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(overlayView)
        addSubview(favoriteRibbon)
        setupLayout()
        layer.cornerRadius = 2.0
        clipsToBounds = true
        
        overlayView.favoriteButton.addTarget(self, action: "didTapFavoriteButton:", forControlEvents: .TouchUpInside)
        overlayView.favoriteButton.addTarget(self, action: "didTouchUpButton:", forControlEvents: .TouchUpInside)
        overlayView.copyButton.addTarget(self, action: "didTapCopyButton:", forControlEvents: .TouchUpInside)
        overlayView.copyButton.addTarget(self, action: "didTouchUpButton:", forControlEvents: .TouchUpInside)

    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        addConstraints([
            overlayView.al_top == contentView.al_top,
            overlayView.al_bottom == contentView.al_bottom,
            overlayView.al_left == contentView.al_left,
            overlayView.al_right == contentView.al_right,
            
            favoriteRibbon.al_right == al_right,
            favoriteRibbon.al_bottom == al_bottom
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        backgroundImageView.frame = bounds
    }
    
    func reset() {
        overlayView.hidden = true
    }
    
    func didTapFavoriteButton(button: SpringButton) {
        overlayView.favoriteButton.selected = !overlayView.favoriteButton.selected
        // hook up what happens when favorite button hit
//        delegate?.mediaLinkCollectionViewCellDidToggleFavoriteButton(self, selected: overlayView.favoriteButton.selected)
    }
    
    func didTapCopyButton(button: SpringButton) {
        overlayView.copyButton.selected = !overlayView.copyButton.selected
        // hook up what happens when copy button is hit
//        delegate?.mediaLinkCollectionViewCellDidToggleCopyButton(self, selected: overlayView.copyButton.selected)
    }
    
    func didTouchUpButton(button: SpringButton?) {
        if let button = button {
            animateButton(button)
        }
    }
    
    //MARK: Button Animation
    func animateButton(button: SpringButton) {
        if button == overlayView.favoriteButton {
            button.animation = "pop"
            button.duration = 0.3
            button.curve = "easeIn"
        }
        
        button.animate()
        
        if button == overlayView.copyButton {
            if overlayView.copyButton.selected {
                UIView.animateWithDuration(0.3, animations: {
                    button.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 180.0)
                })
            }
        }
    }
    
}
