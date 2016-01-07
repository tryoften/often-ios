//
//  BrowseViewController.swift
//  Often
//
//  Created by Luc Succes on 12/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length

import UIKit

enum BrowseSection: Int {
    case TrendingLyrics = 0
    case TrendingArtists = 1
    case TrendingSongs = 2
}

let cellReuseIdentifier = "cell"
let songCellReuseIdentifier = "songCell"

class BrowseViewController: FullScreenCollectionViewController,
    UICollectionViewDelegateFlowLayout,
    TextProcessingManagerDelegate {
    var lyricsHorizontalVC: TrendingLyricsHorizontalCollectionViewController?
    var artistsHorizontalVC: TrendingArtistsHorizontalCollectionViewController?
    var viewModel: TrendingLyricsViewModel
    var searchViewController: SearchViewController?
    var textProcessor: TextProcessingManager?


    init(collectionViewLayout: UICollectionViewLayout, viewModel: TrendingLyricsViewModel, textProcessor: TextProcessingManager? ) {
        self.viewModel = viewModel
        self.textProcessor = textProcessor

        super.init(collectionViewLayout: collectionViewLayout)
        self.textProcessor?.delegate = self

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.registerClass(MediaLinkCollectionViewCell.self, forCellWithReuseIdentifier: songCellReuseIdentifier)
        collectionView?.registerClass(MediaLinksSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier)
        automaticallyAdjustsScrollViewInsets = false

        setupSearchBar()
    }

    func setupSearchBar() {
        let baseURL = Firebase(url: BaseURL)
        searchViewController = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: self.textProcessor!,
            SearchBarControllerClass: KeyboardSearchBarController.self,
            SearchBarClass: KeyboardSearchBar.self)

        guard let searchViewController = searchViewController else {
            return
        }

        if let keyboardSearchBarController = searchViewController.searchBarController as? KeyboardSearchBarController {
            keyboardSearchBarController.textProcessor = textProcessor!
        }

        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)
        view.addSubview(searchViewController.searchBarController.view)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }

    class func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = BrowseSection(rawValue: section) else {
            return 0
        }

        switch section {
        case .TrendingLyrics:
            return 1
        case .TrendingArtists:
            return 1
        case .TrendingSongs:
            return 5
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaLinksSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaLinksSectionHeaderView, let section = BrowseSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch section {
        case .TrendingLyrics:
            cell.topSeperator.hidden = true
            cell.leftText = "Trending Lyrics"
        case .TrendingArtists:
            cell.topSeperator.hidden = false
            cell.leftText = "Top Artists"
        case .TrendingSongs:
            cell.topSeperator.hidden = false
            cell.leftText = "Top Songs"
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let section = BrowseSection(rawValue: indexPath.section) else {
            return baseSize
        }

        switch section {
        case .TrendingLyrics:
            return CGSizeMake(screenWidth, 125)
        case .TrendingArtists:
            return CGSizeMake(screenWidth, 230)
        case .TrendingSongs:
            return CGSizeMake(screenWidth - 20, 115)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let section = BrowseSection(rawValue: section) else {
            return UIEdgeInsetsZero
        }

        switch section {
        case .TrendingLyrics:
            return UIEdgeInsetsZero
        case .TrendingArtists:
            return UIEdgeInsetsZero
        case .TrendingSongs:
            return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 36)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let section = BrowseSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .TrendingLyrics:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let lyricsHorizontalVC = provideTrendingLyricsHorizontalCollectionViewController()

            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(lyricsHorizontalVC.view)
            lyricsHorizontalVC.view.frame = cell.bounds

            return cell
        case .TrendingArtists:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            let artistsHorizontalVC = provideTrendingArtistsHorizontalCollectionViewController()

            cell.contentView.addSubview(artistsHorizontalVC.view)
            artistsHorizontalVC.view.frame = cell.bounds

            self.artistsHorizontalVC = artistsHorizontalVC
            return cell
        case .TrendingSongs:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(songCellReuseIdentifier, forIndexPath: indexPath) as? MediaLinkCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.reset()
            cell.sourceLogoView.image = UIImage(named: "genius")
            cell.mainTextLabel.text = "3500"
            cell.leftHeaderLabel.text = "Travis Scott ft 2 Chainz & Future"
            cell.leftMetadataLabel.text = "Single"
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            return cell
        }
    }

    func provideTrendingLyricsHorizontalCollectionViewController() -> TrendingLyricsHorizontalCollectionViewController {
        if lyricsHorizontalVC == nil {
            lyricsHorizontalVC = TrendingLyricsHorizontalCollectionViewController()
            addChildViewController(lyricsHorizontalVC!)
        }
        return lyricsHorizontalVC!
    }

    func provideTrendingArtistsHorizontalCollectionViewController() -> TrendingArtistsHorizontalCollectionViewController {
        if artistsHorizontalVC == nil {
            artistsHorizontalVC = TrendingArtistsHorizontalCollectionViewController()
            addChildViewController(artistsHorizontalVC!)
        }
        
        return artistsHorizontalVC!
    }

    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }

    func textProcessingManagerDidDetectFilter(textProcessingManager: TextProcessingManager, filter: Filter) {
    }

    func textProcessingManagerDidTextContainerFilter(text: String) -> Filter? {
        return nil
    }

    func textProcessingManagerDidReceiveSpellCheckSuggestions(textProcessingManager: TextProcessingManager, suggestions: [SuggestItem]) {
    }

    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
    }

}