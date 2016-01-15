//
//  BrowseHeaderView.swift
//  Often
//
//  Created by Kervins Valcourt on 12/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class BrowseHeaderView: UICollectionReusableView, UIScrollViewDelegate {
    var scrollView: UIScrollView
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var artistNames: [String]
    var pageViews: [UIImageView?]
    var featureLabel: UILabel
    var featureItemTitleLabel: UILabel
    var tintView: UIImageView
    var screenWidth: CGFloat
    var tapRecognizer: UITapGestureRecognizer?
    var timer: NSTimer?
    weak var delegate: BrowseHeaderViewDelegate?

    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 3 + screenWidth) / (screenWidth * 3)))
    }

    var featuredArtists: [MediaItem] {
        didSet(value) {
            updateFeaturedArtists(value)
        }
    }

    static var preferredSize: CGSize {
        return CGSizeMake(
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height / 3 - 10
        )
    }
    

    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width

        pageImages = [UIImage(named: "g-eazy")!, UIImage(named: "JBeiber")!]
        artistNames = ["G-Eazy".uppercaseString, "Justin Bieber".uppercaseString]
        pageViews = [UIImageView?]()

        pageCount = 0

        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        pagesScrollViewSize = scrollView.frame.size

        tintView = UIImageView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.userInteractionEnabled = false
        tintView.image = UIImage(named: "tintGradient")!

        featureLabel = TOMSMorphingLabel()
        featureLabel.textAlignment = .Center
        featureLabel.text = "Featured Artist".uppercaseString
        featureLabel.font = TrendingHeaderViewSongTitleLabelTextFont
        featureLabel.textColor = TrendingHeaderViewNameLabelTextColor
        featureLabel.translatesAutoresizingMaskIntoConstraints = false
        featureLabel.alpha = 0.74

        featureItemTitleLabel = TOMSMorphingLabel()
        featureItemTitleLabel.textAlignment = .Center
        featureItemTitleLabel.text = "g-eazy".uppercaseString
        featureItemTitleLabel.font = TrendingHeaderViewArtistNameLabelTextFont
        featureItemTitleLabel.textColor = TrendingHeaderViewNameLabelTextColor
        featureItemTitleLabel.translatesAutoresizingMaskIntoConstraints = false


        featuredArtists = [MediaItem]()

        super.init(frame: frame)

        tapRecognizer = UITapGestureRecognizer(target: self, action: "featuredArtistsDidTap:")
        scrollView.addGestureRecognizer(tapRecognizer!)

        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)

        scrollView.delegate = self

        backgroundColor = TrendingHeaderViewBackgroundColor
        clipsToBounds = true

        addSubview(scrollView)
        addSubview(tintView)
        addSubview(featureLabel)
        addSubview(featureItemTitleLabel)
        
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupPages()
        loadVisiblePages()
    }

    func setupPages() {
        pageCount = pageImages.count

        for _ in 0..<pageCount {
            pageViews.append(nil)
        }

        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.8 {
                    let val = progressiveness - 0.1
                    self.featureLabel.alpha = val
                    self.featureItemTitleLabel.alpha = val
                } else {
                    self.featureLabel.alpha = 0.74
                     self.featureItemTitleLabel.alpha = 1
                }
            }
        }
    }

    func loadVisiblePages() {
        /// visible pages
        let pageWidth = screenWidth
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))

        /// Which page to load
        let firstPage = page - 1
        let lastPage = page + 1

        featureItemTitleLabel.text = artistNames[page]

        /// Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }

        /// Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }

        /// Purge anything after the last page
        for var index = lastPage + 1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }

    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            /// If it's outside the range of what you have to display, then do nothing
            return
        }

        if let pageView = pageViews[page] {
            /// view already loaded
        } else {
            /// frame of content is the size of the header
            let frame = scrollView.bounds

            /// new image view to be placed inside of the content area just made
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.translatesAutoresizingMaskIntoConstraints = false
            newPageView.clipsToBounds = true
            newPageView.contentMode = .ScaleAspectFill

            scrollView.addSubview(newPageView)

            scrollView.addConstraints([
                newPageView.al_top == scrollView.al_top,
                newPageView.al_height == scrollView.al_height,
                newPageView.al_width == screenWidth,
                newPageView.al_left == scrollView.al_left + frame.size.width * CGFloat(page)
            ])

            pageViews[page] = newPageView
        }
    }

    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            /// If it's outside the range to display, then do nothing
            return
        }

        /// Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }

    func scrollToNextPage() {
        let xOffset = UIScreen.mainScreen().bounds.width * CGFloat((currentPage + 1) % pageCount)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        loadVisiblePages()

        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
    }

    func setLayout() {
        addConstraints([
            featureLabel.al_right == al_right - 20,
            featureLabel.al_left == al_left + 20,
            featureLabel.al_top == featureItemTitleLabel.al_bottom + 4,

            featureItemTitleLabel.al_centerY == scrollView.al_centerY,
            featureItemTitleLabel.al_right == al_right - 20,
            featureItemTitleLabel.al_left == al_left + 20,
            featureItemTitleLabel.al_height == 20,
            featureItemTitleLabel.al_centerX == al_centerX,

            scrollView.al_top == al_top,
            scrollView.al_width == screenWidth,
            scrollView.al_bottom == al_bottom,

            tintView.al_width == screenWidth,
            tintView.al_top == al_top,
            tintView.al_bottom == al_bottom
        ])

}

    func featuredArtistsDidTap(sender: UIButton) {
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + screenWidth) / (screenWidth * 2.0)))
        if page < featuredArtists.count {
            delegate?.browseHeaderDidSelectFeaturedArtist(self, artist: featuredArtists[page])
            timer?.invalidate()
        }
    }


    func updateFeaturedArtists(artists: [MediaItem]) {
        if !artists.isEmpty {
            delegate?.browseHeaderDidLoadFeaturedArtists(self, artists: artists)
            setupPages()
        }

    }
}

protocol BrowseHeaderViewDelegate: class {
    func browseHeaderDidLoadFeaturedArtists(browseHeaderView: UICollectionReusableView, artists: [MediaItem])
    func browseHeaderDidSelectFeaturedArtist(browseHeaderView: UICollectionReusableView, artist: MediaItem)
}
