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

        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = MainBackgroundColor

        setupNavBar()

        viewModel.delegate = self

        searchBar.textField.delegate = self

        giphyResultCollectionView.dataSource = self
        giphyResultCollectionView.delegate = self
        giphyResultCollectionView.registerClass(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifCellReuseIdentifier)

        viewModel.fetchTrendingData()

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GiphySearchViewController.showHUD), userInfo: nil, repeats: false)

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

    func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: false)

        let brandLabel = UILabel(frame: CGRectMake(0, 0, 64, 20))
        brandLabel.textAlignment = .Center
        brandLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!,
                               letterSpacing: 1.0,
                               color: UIColor.oftBlackColor(),
                               text: "Add GIF")

        navigationItem.titleView = brandLabel

        let topLeftBarButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(GiphySearchViewController.cancelButtonDidTap))
        topLeftBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftBlackColor()
            ]), forState: .Normal)


        updateNextButtonState(false)

        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 19

        navigationItem.leftBarButtonItems = [fixedSpace, topLeftBarButton]
    }

    func updateNextButtonState(enable: Bool) {
        let topRightBarButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(GiphySearchViewController.nextButtonDidTap))
        topRightBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteTwoColor()
            ]), forState: .Disabled)
        topRightBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftVividPurpleColor()
            ]), forState: .Normal)
        topRightBarButton.enabled = enable

        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 19

        navigationItem.rightBarButtonItems = [fixedSpace, topRightBarButton]
    }

    func setupLayout() {
        view.addConstraints([
            searchBar.al_top == view.al_top + 9,
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.hidden =  false
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = WhiteColor
        navigationController?.navigationBar.barTintColor = MainBackgroundColor

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchButton.addTarget(self, action: #selector(GiphySearchViewController.searchButtonDidTap), forControlEvents: .TouchUpInside)
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

    func nextButtonDidTap() {
        guard let gif = viewModel.selectedGif else {
            return
        }

        let vc = CategoryAssignmentViewController(viewModel: AssignCategoryViewModel(mediaItem: gif))
        navigationController?.pushViewController(vc, animated: true)

    }

    func cancelButtonDidTap() {
        navigationController?.popViewControllerAnimated(true)
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
            updateNextButtonState(!cell.searchOverlayView.hidden)

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