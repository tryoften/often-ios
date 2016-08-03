//
//  GiphySearchViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class GiphySearchViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate,
    GiphySearchViewModelDelegate {
    private var viewModel: GiphySearchViewModel
    private var searchBar: SearchBarView
    private var giphyResultCollectionView: UICollectionView
    private var HUDMaskView: UIView?
    private var hudTimer: NSTimer?
    private var giphyLogo: PowerByGiphyView
    private var navigationView: AddContentNavigationView

    init(viewModel: GiphySearchViewModel) {
        self.viewModel = viewModel

        searchBar = SearchBarView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.textField.userInteractionEnabled = true

        giphyLogo = PowerByGiphyView()
        giphyLogo.translatesAutoresizingMaskIntoConstraints = false

        giphyResultCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: GiphySearchViewController.provideLayout())
        giphyResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        giphyResultCollectionView.backgroundColor = MainBackgroundColor
        
        navigationView = AddContentNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.setTitleText("Add GIF")
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = MainBackgroundColor

        navigationView.leftButton.addTarget(self, action: #selector(GiphySearchViewController.cancelButtonDidTap), forControlEvents: .TouchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(GiphySearchViewController.nextButtonDidTap), forControlEvents: .TouchUpInside)
        
        viewModel.delegate = self

        searchBar.textField.delegate = self

        giphyResultCollectionView.dataSource = self
        giphyResultCollectionView.delegate = self
        giphyResultCollectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)

        viewModel.fetchTrendingData()

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GiphySearchViewController.showHUD), userInfo: nil, repeats: false)

        view.addSubview(navigationView)
        view.addSubview(searchBar)
        view.addSubview(giphyResultCollectionView)
        view.addSubview(giphyLogo)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.mainScreen().bounds.width/2 - 12.5
        let height = width * (4/7)

        layout.itemSize = CGSizeMake(width, height)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 7.0
        layout.minimumLineSpacing = 7.0
        layout.sectionInset = UIEdgeInsets(top: 9.0, left: 9.0, bottom: 9.0, right: 9.0)
        return layout
    }

    func setupLayout() {
        view.addConstraints([
            navigationView.al_top == view.al_top,
            navigationView.al_left == view.al_left,
            navigationView.al_right == view.al_right,
            navigationView.al_height == 65,
            
            searchBar.al_top == navigationView.al_bottom + 9,
            searchBar.al_left == view.al_left + 9,
            searchBar.al_right == view.al_right - 9,
            searchBar.al_height == 44,

            giphyResultCollectionView.al_top == searchBar.al_bottom + 9,
            giphyResultCollectionView.al_left == view.al_left,
            giphyResultCollectionView.al_right == view.al_right,
            giphyResultCollectionView.al_bottom == view.al_bottom,

            giphyLogo.al_centerX == view.al_centerX,
            giphyLogo.al_height == 30,
            giphyLogo.al_width == 156,
            giphyLogo.al_bottom == view.al_bottom - 23.5
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchButton.addTarget(self, action: #selector(GiphySearchViewController.searchButtonDidTap), forControlEvents: .TouchUpInside)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.barStyle = .Default
    }

    func showHUD() {
        hudTimer?.invalidate()
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GiphySearchViewController.hideHUD), userInfo: nil, repeats: false)
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func hideHUD() {
        hudTimer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }
    
    func cancelButtonDidTap() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func nextButtonDidTap() {
        guard let gif = viewModel.selectedGif else {
            return
        }
        
        let vc = GifCategoryAssignmentViewController(viewModel: AssignCategoryViewModel(mediaItem: gif))
        navigationController?.pushViewController(vc, animated: true)
    }


    func searchButtonDidTap() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)

        guard let term = searchBar.textField.text else {
            return
        }

        if term != "" {
            showHUD()
            viewModel.searchRequestFor(term)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
        searchButtonDidTap()

        return true
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }


    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.giphyResults.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if viewModel.giphyResults.count == 0 {
            return UICollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let gif = viewModel.giphyResults[indexPath.row] as? GifMediaItem else {
            return cell
        }

        if let imageURL = gif.mediumImageURL {
            cell.setImageWith(imageURL)
        }

        if let currentGifID = viewModel.selectedGif?.giphy_id, gifID = gif.giphy_id {
            if currentGifID == gifID {
                cell.searchOverlayView.hidden = false
            }
        }

        cell.mediaLink = gif

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
        
        for cell in collectionView.visibleCells() {
            if let cell = cell as? GifCollectionViewCell where collectionView.indexPathForCell(cell) != indexPath {
                cell.searchOverlayView.hidden = true
            }
        }

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GifCollectionViewCell {
            cell.searchOverlayView.hidden = !cell.searchOverlayView.hidden
            navigationView.rightButton.enabled = !cell.searchOverlayView.hidden

            if !cell.searchOverlayView.hidden {
                viewModel.selectGifAddToPack(viewModel.giphyResults[indexPath.row])
            } else {
                viewModel.selectGifAddToPack(nil)
            }
        }
    }

    func giphySearchViewModelDelegateDataDidLoad(viewModel: GiphySearchViewModel, gifs: [GifMediaItem]?) {
        giphyResultCollectionView.reloadData()
        hideHUD()
    }
}