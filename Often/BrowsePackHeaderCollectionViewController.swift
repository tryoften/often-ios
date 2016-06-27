//
//  PackScrollCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 3/22/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke

let BrowsePackHeaderViewIdentifier = "browseCell"

class BrowsePackHeaderCollectionViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    MediaItemGroupViewModelDelegate {
    private var viewModel: MediaItemGroupViewModel
    private var collectionView: UICollectionView
    private var currentPage: Int
    private let scrollView: UIScrollView
    private let itemWidth: CGFloat
    private let width: CGFloat
    private var titleLabel: UILabel
    private var subtitleLabel: UILabel
    private var premiumIcon: UIImageView
    private var topBorderView: UIView

    static var padding: CGFloat {
        return 80.0
    }
    
    init(viewModel: MediaItemGroupViewModel = MediaItemGroupViewModel(baseRef: nil, path: "featured/packs")) {
        self.viewModel = viewModel

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: BrowseCollectionViewFlowLayout.provideCollectionFlowLayout(UIScreen.main().bounds.width - (self.dynamicType.padding * 2), padding: self.dynamicType.padding))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false

        itemWidth = UIScreen.main().bounds.width - (self.dynamicType.padding * 2)
        width = itemWidth + (self.dynamicType.padding / 2)
        currentPage = 0

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        premiumIcon = UIImageView(image: StyleKit.imageOfPremium(color: TealColor!, frame: CGRect(x: 0, y: 0, width: 25, height: 25)))
        premiumIcon.translatesAutoresizingMaskIntoConstraints = false
        premiumIcon.isHidden = true

        topBorderView = UIView()
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = LightGrey

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        scrollView.isPagingEnabled = true
        scrollView.isHidden = true

        super.init(nibName: nil, bundle: nil)


        view.backgroundColor = UIColor.clear()

        viewModel.delegate = self
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        view.clipsToBounds = false

        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
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
//        view.addConstraints([
//            collectionView.al_top == view.al_top + 15,
//            collectionView.al_left == view.al_left,
//            collectionView.al_width == view.al_width,
//            collectionView.al_height == 260,
//
//            titleLabel.al_top == collectionView.al_bottom,
//            titleLabel.al_centerX == view.al_centerX,
//
//            premiumIcon.al_centerY == titleLabel.al_centerY,
//            premiumIcon.al_left == titleLabel.al_right + 5,
//
//            subtitleLabel.al_top == titleLabel.al_bottom + 5,
//            subtitleLabel.al_centerX == view.al_centerX,
//            subtitleLabel.al_left == view.al_left + 52,
//            subtitleLabel.al_right == view.al_right - 52,
//            subtitleLabel.al_height == 40,
//
//            topBorderView.al_left == view.al_left,
//            topBorderView.al_right == view.al_right,
//            topBorderView.al_top == view.al_top,
//            topBorderView.al_height == 0.5
//        ])
    }

    class BrowseCollectionViewFlowLayout: UICollectionViewFlowLayout {
        class func provideCollectionFlowLayout(_ itemWidth: CGFloat, padding: CGFloat) -> UICollectionViewFlowLayout {
            let viewLayout = BrowseCollectionViewFlowLayout()
            viewLayout.scrollDirection = .horizontal
            viewLayout.minimumInteritemSpacing = padding / 2
            viewLayout.minimumLineSpacing = padding / 2
            viewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0.0, right: padding)
            viewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            return viewLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.main().bounds.width
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsetsMake(0, (self.view.frame.size.width - screenWidth) / 2, 0, (self.view.frame.size.width - screenWidth) / 2)
        collectionView.panGestureRecognizer.isEnabled = false
        collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
        collectionView.backgroundColor = BrowseHeaderCollectionViewControllerBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BrowsePackHeaderCollectionViewCell.self, forCellWithReuseIdentifier: BrowsePackHeaderViewIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getCurrentPage() -> Int {
        let width = scrollView.frame.size.width
        return Int(floor((scrollView.contentOffset.x + (0.5 * width)) / width))
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentPage != getCurrentPage() {
            currentPage = getCurrentPage()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset: CGPoint = scrollView.contentOffset

        if scrollView == self.scrollView {
            contentOffset.x = contentOffset.x - collectionView.contentInset.left
            collectionView.contentOffset = contentOffset
        }

        updatePackMetaData()
    }

    func updatePackMetaData() {
        let centerPoint = CGPoint(x: collectionView.frame.size.width / 2 + scrollView.contentOffset.x, y: collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPathOfCentralCell = collectionView.indexPathForItem(at: centerPoint), let group = viewModel.groupAtIndex((indexPathOfCentralCell as NSIndexPath).section), let pack = group.items[(indexPathOfCentralCell as NSIndexPath).row] as? PackMediaItem {
            if let title = pack.name {
                titleLabel.setTextWith(UIFont(name: "Montserrat", size: 16.0)!,
                                       letterSpacing: 1.0,
                                       color: BlackColor!,
                                       text: title.uppercased())
            }

            if let subtitle = pack.description {
                subtitleLabel.setTextWith(UIFont(name: "OpenSans", size: 12)!,
                                          letterSpacing: 0.5,
                                          color: UIColor.oftDarkGrey74Color(),
                                          lineHeight: 1.1,
                                          text: subtitle)
            }

            premiumIcon.isHidden = !pack.premium
        }
        
        
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = viewModel.groupAtIndex(section) else {
            return 0
        }

        scrollView.contentSize = CGSize(width: width * CGFloat(group.items.count), height: width)

        return group.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowsePackHeaderViewIdentifier, for: indexPath) as? BrowsePackHeaderCollectionViewCell, let group = viewModel.groupAtIndex((indexPath as NSIndexPath).section) else {
            return UICollectionViewCell()
        }

        switch group.type {
        case .Pack:
            guard let pack = group.items[(indexPath as NSIndexPath).row] as? PackMediaItem else {
                return BrowsePackHeaderCollectionViewCell()
            }

            if let imageURL = pack.largeImageURL {
                cell.artistImage.nk_setImageWith(imageURL)
            }
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let group = viewModel.groupAtIndex((indexPath as NSIndexPath).section), let pack = group.items[(indexPath as NSIndexPath).row] as? PackMediaItem, let Id = pack.pack_id else {
            return
        }

        let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: Id), textProcessor: nil)
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(packVC, animated: true)
    }

    func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        collectionView.reloadData()
        updatePackMetaData()
    }

}



