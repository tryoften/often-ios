//
//  GifCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 4/13/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//
import Spring
import Nuke
import NukeAnimatedImagePlugin
import FLAnimatedImage

class GifCollectionViewCell : BaseMediaItemCollectionViewCell {
    var overlayView: GifCellOverlayView
    var backgroundImageView: FLAnimatedImageView
    var favoriteRibbon: UIImageView

    override var overlayVisible: Bool {
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
    
    override var itemFavorited: Bool {
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
        
        super.init(frame: frame)
        
        itemFavorited = false
        overlayVisible = false

        backgroundColor = UIColor.oftBlack74Color()
        
        addSubview(backgroundImageView)
        addSubview(overlayView)
        addSubview(favoriteRibbon)
        setupLayout()
        layer.cornerRadius = 2.0
        clipsToBounds = true
        
        overlayView.favoriteButton.addTarget(self, action: #selector(GifCollectionViewCell.didTapFavoriteButton(_:)), forControlEvents: .TouchUpInside)
        overlayView.favoriteButton.addTarget(self, action: #selector(GifCollectionViewCell.didTouchUpButton(_:)), forControlEvents: .TouchUpInside)
        overlayView.copyButton.addTarget(self, action: #selector(GifCollectionViewCell.didTapCopyButton(_:)), forControlEvents: .TouchUpInside)
        overlayView.copyButton.addTarget(self, action: #selector(GifCollectionViewCell.didTouchUpButton(_:)), forControlEvents: .TouchUpInside)

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
//        backgroundImageView.animatedImage = nil
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        overlayView.hidden = true
        self.backgroundImageView.nk_displayImage(nil)
        self.backgroundImageView.nk_cancelLoading()
    }

    func didTapFavoriteButton(button: SpringButton) {
        overlayView.favoriteButton.selected = !overlayView.favoriteButton.selected
        delegate?.mediaLinkCollectionViewCellDidToggleFavoriteButton(self, selected: overlayView.favoriteButton.selected)
    }
    
    func didTapCopyButton(button: SpringButton) {
        overlayView.copyButton.selected = !overlayView.copyButton.selected
        delegate?.mediaLinkCollectionViewCellDidToggleCopyButton(self, selected: overlayView.copyButton.selected)
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

    func setImageWith(URL: NSURL) {
        self.setImageWith(ImageRequest(URL: URL))
    }

    func setImageWith(request: ImageRequest) {
        let task = self.backgroundImageView.nk_setImageWith(request)
        task.progressHandler = { [weak self, weak task] _ in
            guard let task = task where task == self?.backgroundImageView.nk_imageTask else {
                return
            }

            if task.progress.fractionCompleted == 1 {
                if let image = task.response?.image {
                    self?.backgroundImageView.nk_displayImage(image)
                }
            }
        }
        if task.state == .Completed {
        }                               
    }

}
