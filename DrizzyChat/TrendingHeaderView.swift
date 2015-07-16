//
//  TrendingHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    TrendingHeaderView:

    Header view of the Trending view that displays:
    
    - Artist Cover Photo
    - Artist Name
    - Featured Button

*/

class TrendingHeaderView: UICollectionReusableView, UIScrollViewDelegate, TrendingHeaderDelegate {
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var pageViews: [UIImageView?]
    
    var featuredButton: UIButton
    var nameLabel: UILabel
    var topLabel: UILabel
    var artistsButton: UIButton
    var lyricsButton: UIButton
    var tabView: UIView
    var tintView: UIView
    var screenWidth: CGFloat
    var headerLoadedOnce = false
    var tapRecognizer: UITapGestureRecognizer?
    
    weak var lyricDelegate: LyricTabDelegate?
    weak var artistDelegate: ArtistTabDelegate?
    weak var featuredDelegate: FeaturedButtonDelegate?
    var featuredArtists: [Artist]
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        pageImages = [UIImage]()
        pageViews = [UIImageView?]()
        
        pageCount = 0
        
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.currentPage = 0
        
        pagesScrollViewSize = scrollView.frame.size
        
        tintView = UIView()
        tintView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tintView.userInteractionEnabled = false
        tintView.backgroundColor = TrendingHeaderViewTintViewBackgroundColor
        
        tabView = UIView()
        tabView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabView.backgroundColor = TrendingHeaderViewTabViewBackgroundColor
        
        topLabel = UILabel()
        topLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        topLabel.textAlignment = .Center
        topLabel.font = TrendingHeaderViewTopLabelFont
        topLabel.text = "TRENDING"
        topLabel.textColor = TrendingHeaderViewTopLabelBackgroundColor
        topLabel.alpha = 0
        
        nameLabel = TOMSMorphingLabel()
        nameLabel.textAlignment = .Center
        nameLabel.font = TrendingHeaderViewNameLabelTextFont
        nameLabel.textColor = TrendingHeaderViewNameLabelTextColor
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        featuredButton = UIButton(frame: CGRectMake(0.0, 0.0, 85.0, 10.0))
        featuredButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        featuredButton.setTitle("FEATURED", forState: UIControlState.Normal)
        featuredButton.titleLabel?.font = TrendingHeaderViewFeaturedButtonTextFont
        featuredButton.backgroundColor = TrendingHeaderViewFeaturedButtonBackgroundColor
        featuredButton.setTitleColor(TrendingHeaderViewFeaturedButtonFontColor, forState: UIControlState.Normal)
        
        artistsButton = UIButton()
        artistsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistsButton.setTitle("ARTISTS", forState: UIControlState.Normal)
        artistsButton.titleLabel?.font = TrendingHeaderViewArtistsButtonTextFont
        artistsButton.setTitleColor(TrendingHeaderViewArtistsButtonFontColor, forState: UIControlState.Normal)
        artistsButton.setTitleColor(TrendingHeaderViewArtistsButtonSelectedFontColor, forState: UIControlState.Selected)
        
        
        lyricsButton = UIButton()
        lyricsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricsButton.setTitle("LYRICS", forState: UIControlState.Normal)
        lyricsButton.titleLabel?.font = TrendingHeaderViewLyricsButtonTextFont
        lyricsButton.setTitleColor(TrendingHeaderViewLyricsButtonNormalFontColor, forState: .Normal)
        lyricsButton.setTitleColor(TrendingHeaderViewLyricsButtonSelectedFontColor, forState: UIControlState.Selected)
        lyricsButton.selected = true
        
        featuredArtists = [Artist]()
        
        super.init(frame: frame)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "featuredTapped:")
        scrollView.addGestureRecognizer(tapRecognizer!)
        
        featuredButton.addTarget(self, action: "featuredTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        artistsButton.addTarget(self, action: "artistsTapped:", forControlEvents: .TouchUpInside)
        lyricsButton.addTarget(self, action: "lyricsTapped:", forControlEvents: .TouchUpInside)
        
        scrollView.delegate = self
        
        backgroundColor = TrendingHeaderViewBackgroundColor
        clipsToBounds = true
        
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(tintView)
        addSubview(topLabel)
        addSubview(nameLabel)
        addSubview(featuredButton)
        addSubview(tabView)
        addSubview(artistsButton)
        addSubview(lyricsButton)
        
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if !featuredArtists.isEmpty {
            loadVisiblePages()
        }
    }
    
    func setupPages() {
        pageCount = pageImages.count
        
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness
            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.8 {
                    var val = progressiveness - 0.1
                    self.topLabel.alpha = 1 - val
                    self.nameLabel.alpha = val
                    self.featuredButton.alpha = val
                    self.pageControl.alpha = val
                } else {
                    self.topLabel.alpha = 0
                    self.nameLabel.alpha = 1
                    self.featuredButton.alpha = 1
                    self.pageControl.alpha = 1
                }
            }
        }
    }
    
    func loadVisiblePages() {
        /// visible pages
        let pageWidth = screenWidth
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        nameLabel.text = featuredArtists[page].displayName
        
        /// Which page to load
        let firstPage = page - 1
        let lastPage = page + 1
        
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
            var frame = scrollView.bounds
            
            /// new image view to be placed inside of the content area just made
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func setLayout() {
        addConstraints([
            topLabel.al_centerY == scrollView.al_centerY,
            topLabel.al_centerX == al_centerX,
            
            nameLabel.al_centerY == scrollView.al_centerY,
            nameLabel.al_width == 280,
            nameLabel.al_centerX == al_centerX,
            
            featuredButton.al_height == 20,
            featuredButton.al_width == 70,
            featuredButton.al_top == nameLabel.al_bottom + 5,
            featuredButton.al_centerX == nameLabel.al_centerX,
            
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 20,
            
            scrollView.al_top == al_top,
            scrollView.al_width == screenWidth,
            scrollView.al_bottom == tabView.al_top,
            
            tintView.al_width == screenWidth,
            tintView.al_top == al_top,
            tintView.al_bottom == tabView.al_top
        ])
        
        addConstraints([
            tabView.al_bottom == al_bottom,
            tabView.al_height == 50,
            tabView.al_width == screenWidth
        ])
        
        addConstraints([
            artistsButton.al_height == 50,
            artistsButton.al_width == (screenWidth / 2) - 5,
            artistsButton.al_left == tabView.al_left,
            artistsButton.al_top == tabView.al_top,
            
            lyricsButton.al_height == 50,
            lyricsButton.al_width == (screenWidth / 2) - 5,
            lyricsButton.al_top == tabView.al_top,
            lyricsButton.al_left == artistsButton.al_right + 5,
        ])
    }
    
    func featuredTapped(sender: UIButton) {
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + screenWidth) / (screenWidth * 2.0)))
        if page < featuredArtists.count {
            featuredDelegate?.featuredButtonDidTap(featuredArtists[page].id)
        }
    }
    
    func artistsTapped(sender: UIButton) {
        artistsButton.selected = true
        lyricsButton.selected = false
        
        self.artistDelegate?.artistDidTap()
    }
    
    func lyricsTapped(sender: UIButton) {
        artistsButton.selected = false
        lyricsButton.selected = true
        
        self.lyricDelegate?.lyricDidTap()
    }
    
    
    // MARK: TrendingHeaderDelegate
    
    func featuredArtistsDidLoad(artists: [Artist]) {
        if headerLoadedOnce == false {
            featuredArtists = artists
            for artist in featuredArtists {
                if let url = NSURL(string: artist.imageURLLarge),
                    let data = NSData(contentsOfURL: url),
                    let image = UIImage(data: data) {
                        pageImages.append(image)
                } else {
                    pageImages.append(UIImage(named: "placeholder")!)
                }
            }
            headerLoadedOnce = true
        }
        
        setupPages()
    }
}

protocol FeaturedButtonDelegate: class {
    func featuredButtonDidTap(artistId: String)
}

protocol LyricTabDelegate: class {
    func lyricDidTap()
}

protocol ArtistTabDelegate: class {
    func artistDidTap()
}