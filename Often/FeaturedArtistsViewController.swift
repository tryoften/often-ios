//
//  FeaturedArtistsCollectionViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 1/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

private let FeaturedArtistsCellReuseIdentifier = "Cell"

class FeaturedArtistsCollectionViewController: UIViewController, UIScrollViewDelegate, MediaItemGroupViewModelDelegate {
    var viewModel: MediaItemGroupViewModel
    var scrollView: UIScrollView
    var pageCount: Int

    var pageWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }

    private var timer: NSTimer?

    init() {
        viewModel = MediaItemGroupViewModel(path: "featured/artists")
        pageCount = 0

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        scrollView.showsHorizontalScrollIndicator = false

        super.init(nibName: nil, bundle: nil)

        viewModel.delegate = self

        view.addSubview(scrollView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)

        do {
            try viewModel.fetchData()
        } catch _ {}

    }

    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            scrollView.al_bottom == view.al_bottom,
            scrollView.al_top == view.al_top,
            scrollView.al_left == view.al_left,
            scrollView.al_right == view.al_right,
        ]

        view.addConstraints(constraints)
    }

    func scrollToNextPage() {
        let xOffset = pageWidth * CGFloat((currentPage + 1) % pageCount)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }


    func setupPages() {
        guard let group = viewModel.groups.first else {
            return
        }
        
        pageCount = group.items.count

        scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageCount),
            height: scrollView.frame.size.height)
    }

    func loadVisiblePages() {
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }

    func loadPage(page: Int) {
        guard let artist = viewModel.groups.first?.items[page] as? ArtistMediaItem else {
            return
        }

        let featuedArtistView = FeaturedArtistView()

        featuedArtistView.translatesAutoresizingMaskIntoConstraints = false

        if let name = artist.name {
            featuedArtistView.titleLabel.text = name.uppercaseString
        }

        featuedArtistView.featureLabel.text = "Featured Artist".uppercaseString

        if let image = artist.largeImage, let imageURL = NSURL(string: image) {
            featuedArtistView.imageView.setImageWithAnimation(imageURL)
        }

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapFeaturedArtist")

        featuedArtistView.addGestureRecognizer(tapRecognizer)
        
        scrollView.addSubview(featuedArtistView)

        scrollView.addConstraints([
            featuedArtistView.al_top == scrollView.al_top,
            featuedArtistView.al_height == scrollView.al_height,
            featuedArtistView.al_width == pageWidth,
            featuedArtistView.al_left == scrollView.al_left + pageWidth * CGFloat(page)
            ])

    }

    func didTapFeaturedArtist() {
        timer?.invalidate()
        showNavigationBar(true)

        guard let artistMediaItem = viewModel.groups.first?.items[currentPage] as? ArtistMediaItem else {
            return
        }

        let browseVC = BrowseArtistCollectionViewController(artistId: artistMediaItem.id, viewModel: BrowseViewModel())
        navigationController?.pushViewController(browseVC, animated: true)
        containerViewController?.resetPosition()
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        setupPages()
    }
}