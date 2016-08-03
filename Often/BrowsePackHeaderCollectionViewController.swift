//
//  PackScrollCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 3/22/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke
import Preheat

let BrowsePackHeaderViewIdentifier = "browseCell"

class BrowsePackHeaderCollectionViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    MediaItemGroupViewModelDelegate {
    private var viewModel: MediaItemGroupViewModel
    private var collectionView: UICollectionView
    private var preheatController: PreheatController<UICollectionView>?
    private var currentPage: Int
    private let scrollView: UIScrollView
    private let itemWidth: CGFloat
    private let width: CGFloat
    private var premiumIcon: UIImageView
    private var topBorderView: UIView

    static var padding: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 25.0
        }
        return 50.0
    }
    
    static var collectionViewHeight: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 270.0
        }
        return 230.0
    }
    
    init(viewModel: MediaItemGroupViewModel = MediaItemGroupViewModel(path: "featured/packs")) {
        self.viewModel = viewModel

        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout(UIScreen.mainScreen().bounds.width - (self.dynamicType.padding * 2), padding: self.dynamicType.padding))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false

        itemWidth = UIScreen.mainScreen().bounds.width - (self.dynamicType.padding * 2)
        width = itemWidth + (self.dynamicType.padding / 2)
        currentPage = 0

        premiumIcon = UIImageView(image: StyleKit.imageOfPremium(color: TealColor, frame: CGRectMake(0, 0, 25, 25)))
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
        premiumIcon.hidden = true

        topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = LightGrey

        scrollView = UIScrollView(frame: CGRectMake(0, 0, width, width))
        scrollView.pagingEnabled = true
        scrollView.hidden = true

        super.init(nibName: nil, bundle: nil)

        preheatController = PreheatController(view: collectionView)

        preheatController?.handler = { [weak self] in
            self?.preheatWindowChanged(addedIndexPaths: $0, removedIndexPaths: $1)
        }

        view.backgroundColor = UIColor.clearColor()

        viewModel.delegate = self
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        view.clipsToBounds = false

        view.addSubview(collectionView)
        view.addSubview(premiumIcon)
        view.addSubview(topBorderView)
        view.addSubview(scrollView)

        setupLayout()

        do {
            try viewModel.fetchData()
        } catch _ {}


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        view.addConstraints([
            collectionView.al_top == view.al_top,
            collectionView.al_left == view.al_left,
            collectionView.al_width == view.al_width,
            collectionView.al_height == self.dynamicType.collectionViewHeight,
            
            topBorderView.al_left == view.al_left,
            topBorderView.al_right == view.al_right,
            topBorderView.al_top == view.al_top,
            topBorderView.al_height == 0.5
        ])
    }

    class BrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
        class func provideCollectionFlowLayout(itemWidth: CGFloat, padding: CGFloat) -> UICollectionViewFlowLayout {
            let viewLayout = BrowseCollectionViewFlowLayout()
            viewLayout.scrollDirection = .Horizontal
            viewLayout.minimumInteritemSpacing = padding / 2
            viewLayout.minimumLineSpacing = padding / 2
            viewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0.0, right: padding)
            viewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * (2/3))
            return viewLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.mainScreen().bounds.width
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width - screenWidth) / 2, 0, (self.view.frame.size.width - screenWidth) / 2)
        collectionView.panGestureRecognizer.enabled = false
        collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
        collectionView.backgroundColor = BrowseHeaderCollectionViewControllerBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClass(BrowsePackHeaderCollectionViewCell.self, forCellWithReuseIdentifier: BrowsePackHeaderViewIdentifier)

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        preheatController?.enabled = true
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        preheatController?.enabled = false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getCurrentPage() -> Int {
        let width = scrollView.frame.size.width
        return Int(floor((scrollView.contentOffset.x + (0.5 * width)) / width))
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if currentPage != getCurrentPage() {
            currentPage = getCurrentPage()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        var contentOffset: CGPoint = scrollView.contentOffset

        if scrollView == self.scrollView {
            contentOffset.x = contentOffset.x - collectionView.contentInset.left
            collectionView.contentOffset = contentOffset
        }
    }

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = viewModel.groupAtIndex(section) else {
            return 0
        }

        scrollView.contentSize = CGSizeMake(width * CGFloat(group.items.count), width)

        return group.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(BrowsePackHeaderViewIdentifier, forIndexPath: indexPath) as? BrowsePackHeaderCollectionViewCell, let group = viewModel.groupAtIndex(indexPath.section) else {
            return UICollectionViewCell()
        }

        switch group.type {
        case .Pack:
            guard let pack = group.items[indexPath.row] as? PackMediaItem else {
                return BrowsePackHeaderCollectionViewCell()
            }
            
            if let title = pack.name {
                cell.titleLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                                            letterSpacing: 1.0,
                                            color: WhiteColor,
                                            text: title.uppercaseString)
            }


            if let imageURL = pack.largeImageURL {
                cell.artistImage.nk_setImageWith(imageURL)
            }
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let group = viewModel.groupAtIndex(indexPath.section), let pack = group.items[indexPath.row] as? PackMediaItem, let Id = pack.pack_id else {
            return
        }

        let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: Id), textProcessor: nil)
        navigationController?.navigationBar.hidden = false
        navigationController?.pushViewController(packVC, animated: true)
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView.reloadData()
    }

    // MARK: PreheatControllerDelegate
    func requestForIndexPaths(indexPaths: [NSIndexPath]) -> [ImageRequest]? {
        var imageRequest: [ImageRequest] = []

        for index in indexPaths {
            if let group = viewModel.groupAtIndex(index.section),
                pack = group.items[index.row] as? PackMediaItem,
                url = pack.largeImageURL {

                imageRequest.append (ImageRequest(URL: url))
            }
        }

        return imageRequest
    }

    func preheatWindowChanged(addedIndexPaths added: [NSIndexPath], removedIndexPaths removed: [NSIndexPath]) {
        guard let startPreheatingImages = requestForIndexPaths(added),
            let stopPreheatingImages = requestForIndexPaths(removed) else {
                return
        }

        Nuke.startPreheatingImages(startPreheatingImages)
        Nuke.stopPreheatingImages(stopPreheatingImages)
    }
}



