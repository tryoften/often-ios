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

    (TODO): need to figure out formatting for the artist name (Perhaps, parsing + all caps)
*/

class TrendingHeaderView: UICollectionReusableView, UIScrollViewDelegate {
    var featuredButton: UIButton?
    var scrollView: UIScrollView?
    var pageControl: UIPageControl?
    var nameLabel: UILabel?
    var topLabel: UILabel?
    var artistsButton: UIButton?
    var lyricsButton: UIButton?
    var tabView: UIView?
    var tintView: UIView?
    var screenWidth: CGFloat
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var lyricDelegate: lyricTabDelegate?
    var artistDelegate: artistTabDelegate?
    
    /// testing
    var pageImages: [UIImage] = [
        UIImage(named: "rome-fortune")!,
        UIImage(named: "chance-the-rapper")!,
        UIImage(named: "meek-mill")!
    ]
    
    var pageViews: [UIImageView?] = []
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        pageCount = pageImages.count
        
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView?.pagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl?.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl?.currentPage = 0
        pageControl?.numberOfPages = pageCount
        
        tintView = UIView()
        tintView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        tintView?.userInteractionEnabled = false
        tintView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18)
        
        tabView = UIView()
        tabView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabView?.backgroundColor = UIColor.blackColor()
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        pagesScrollViewSize = scrollView!.frame.size
        scrollView?.contentSize = CGSize(width: screenWidth * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        topLabel = UILabel()
        topLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        topLabel?.textAlignment = .Center
        topLabel?.font = UIFont(name: "OpenSans", size: 18.0)
        topLabel?.text = "TRENDING"
        topLabel?.textColor = UIColor.whiteColor()
        topLabel?.alpha = 0
        
        nameLabel = UILabel()
        nameLabel?.textAlignment = .Center
        nameLabel?.font = UIFont(name: "Oswald-Light", size: 24.0)
        nameLabel?.textColor = UIColor.whiteColor()
        nameLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel?.text = "R O M E  F O R T U N E"
        
        featuredButton = UIButton(frame: CGRectMake(0.0, 0.0, 85.0, 10.0))
        featuredButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        featuredButton?.setTitle("FEATURED", forState: UIControlState.Normal)
        featuredButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 10.0)
        featuredButton?.backgroundColor = UIColor.whiteColor()
        featuredButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        artistsButton = UIButton()
        artistsButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistsButton?.setTitle("ARTISTS", forState: UIControlState.Normal)
        artistsButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14.0)
        artistsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
        
        lyricsButton = UIButton()
        lyricsButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        lyricsButton?.setTitle("LYRICS", forState: UIControlState.Normal)
        lyricsButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14.0)
        lyricsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        super.init(frame: frame)
        
        featuredButton?.addTarget(self, action: "featuredTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        artistsButton?.addTarget(self, action: "artistsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        lyricsButton?.addTarget(self, action: "lyricsTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView?.delegate = self
        
        backgroundColor = UIColor.blackColor()
        clipsToBounds = true
        
        addSubview(scrollView!)
        addSubview(pageControl!)
        addSubview(tintView!)
        addSubview(topLabel!)
        addSubview(nameLabel!)
        addSubview(featuredButton!)
        addSubview(tabView!)
        addSubview(artistsButton!)
        addSubview(lyricsButton!)
        
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadVisiblePages()
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            UIView.animateWithDuration(0.4, animations: {
                if attributes.progressiveness <= 0.55 {
                    self.topLabel?.alpha = 1
                    self.nameLabel?.alpha = 0
                    self.featuredButton?.alpha = 0
                    
                } else if attributes.progressiveness <= 0.8 {
                    self.pageControl?.alpha = 0
                    
                } else if attributes.progressiveness > 1 {
                    /// blur the scroll view's current image with the progressiveness
                } else {2
                    self.topLabel?.alpha = 0
                    self.nameLabel?.alpha = 1
                    self.featuredButton?.alpha = 1
                    self.pageControl?.alpha = 1
                }
            })
        }
    }
    
    func loadVisiblePages() {
        /// visible pages
        let pageWidth = screenWidth
        let page = Int(floor((scrollView!.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl!.currentPage = page
        if page == 0 {
            nameLabel?.text = "R O M E  F O R T U N E"
        } else if page == 1 {
            nameLabel?.text = "C H A N C E  T H E  R A P P E R"
        } else if page == 2 {
            nameLabel?.text = "M E E K  M I L L"
        }
        
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
            var frame = scrollView!.bounds
            
            /// new image view to be placed inside of the content area just made
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            newPageView.clipsToBounds = true
            newPageView.contentMode = .ScaleAspectFill
            scrollView!.addSubview(newPageView)
            
            scrollView!.addConstraints([
                newPageView.al_top == scrollView!.al_top,
                newPageView.al_height == scrollView!.al_height,
                newPageView.al_width == screenWidth,
                newPageView.al_left == scrollView!.al_left + frame.size.width * CGFloat(page)
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
            topLabel!.al_top == al_top + 10,
            topLabel!.al_centerX == al_centerX,
            
            nameLabel!.al_centerY == scrollView!.al_centerY,
            nameLabel!.al_width == 280,
            nameLabel!.al_centerX == al_centerX,
            
            featuredButton!.al_height == 20,
            featuredButton!.al_width == 70,
            featuredButton!.al_top == nameLabel!.al_bottom + 5,
            featuredButton!.al_centerX == nameLabel!.al_centerX,
            
            pageControl!.al_centerX == scrollView!.al_centerX,
            pageControl!.al_bottom == scrollView!.al_bottom - 20,
            
            scrollView!.al_top == al_top,
            scrollView!.al_width == screenWidth,
            scrollView!.al_bottom == tabView!.al_top,
            
            tintView!.al_width == screenWidth,
            tintView!.al_top == al_top,
            tintView!.al_bottom == tabView!.al_top
        ])
        
        addConstraints([
            tabView!.al_bottom == al_bottom,
            tabView!.al_height == 50,
            tabView!.al_width == screenWidth
        ])
        
        addConstraints([
            artistsButton!.al_height == 50,
            artistsButton!.al_width == (screenWidth / 2) - 5,
            artistsButton!.al_left == tabView!.al_left,
            artistsButton!.al_top == tabView!.al_top,
            
            lyricsButton!.al_height == 50,
            lyricsButton!.al_width == (screenWidth / 2) - 5,
            lyricsButton!.al_top == tabView!.al_top,
            lyricsButton!.al_left == artistsButton!.al_right + 5,
        ])
    }
    
    func featuredTapped(sender: UIButton) {
        println("Featured Tapped")
    }
    
    func artistsTapped(sender: UIButton) {
        artistsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
        lyricsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        self.artistDelegate?.artistDidTap()
    }
    
    func lyricsTapped(sender: UIButton) {
        artistsButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        lyricsButton?.setTitleColor(UIColor(fromHexString: "#FFB316"), forState: UIControlState.Normal)
        self.lyricDelegate?.lyricDidTap()
    }
}

protocol lyricTabDelegate {
    func lyricDidTap()
}

protocol artistTabDelegate {
    func artistDidTap()
}
