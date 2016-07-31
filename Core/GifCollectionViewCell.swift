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

class GifCollectionViewCell: BaseMediaItemCollectionViewCell {
    private var overlayView: GifCellOverlayView
    private var progressView: UIProgressView
    var backgroundImageView: FLAnimatedImageView
    
    var animatedImage: FLAnimatedImage? {
        return backgroundImageView.animatedImage
    }

    var searchOverlayView: SearchOverlayView

    override var overlayVisible: Bool {
        didSet {
            if overlayVisible {
                overlayView.hidden = false
                overlayView.startLoader()

                delay(2.5) {
                    self.overlayVisible = false
                    self.overlayView.reset()
                }
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


    
    override init(frame: CGRect) {
        backgroundImageView = FLAnimatedImageView()
        
        overlayView = GifCellOverlayView()
        overlayView.hidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        searchOverlayView = SearchOverlayView()
        searchOverlayView.hidden = true
        searchOverlayView.translatesAutoresizingMaskIntoConstraints = false

        progressView = UIProgressView()
        progressView.progressTintColor = TealColor
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        itemFavorited = false
        overlayVisible = false

        backgroundColor = UIColor.oftBlack74Color()
        
        addSubview(backgroundImageView)
        addSubview(progressView)
        addSubview(overlayView)
        addSubview(searchOverlayView)

        setupLayout()
        layer.cornerRadius = 2.0
        clipsToBounds = true
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

            searchOverlayView.al_top == contentView.al_top,
            searchOverlayView.al_bottom == contentView.al_bottom,
            searchOverlayView.al_left == contentView.al_left,
            searchOverlayView.al_right == contentView.al_right,

            progressView.al_bottom == contentView.al_bottom,
            progressView.al_left == contentView.al_left,
            progressView.al_right == contentView.al_right,
            progressView.al_height == 4.0
        ])
    }

    func showDoneMessage() {
        delay(2.0) {
            self.overlayView.showSuccessMessage()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        backgroundImageView.frame = bounds
    }
    
    func reset() {
        overlayView.hidden = true
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        overlayView.hidden = true
        searchOverlayView.hidden = true
        backgroundImageView.nk_displayImage(nil)
        backgroundImageView.nk_cancelLoading()
        progressView.progress = 0
        progressView.alpha = 1
    }

    func setImage(image: UIImage) {
        backgroundImageView.image = image
    }
    
    func setImageWith(URL: NSURL) {
        self.setImageWith(ImageRequest(URL: URL))
    }

    func setImageWithData(data: NSData) {
        let image = FLAnimatedImage(animatedGIFData: data)
        backgroundImageView.animatedImage = image

    }

    func setImageWith(request: ImageRequest) {
        let task = self.backgroundImageView.nk_setImageWith(request)
        task.progressHandler = { [weak self, weak task] _ in
            guard let task = task where task == self?.backgroundImageView.nk_imageTask else {
                return
            }

            self?.progressView.setProgress(Float(task.progress.fractionCompleted), animated: true)

            if task.progress.fractionCompleted == 1 {

                UIView.animateWithDuration(0.2) {
                    self?.progressView.alpha = 0
                }
            }
        }
        if task.state == .Completed {
            progressView.alpha = 0
        }                               
    }

}
