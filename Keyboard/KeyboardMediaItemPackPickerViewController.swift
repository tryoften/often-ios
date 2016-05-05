//
//  KeyboardMediaItemPackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

private let KeyboardMediaItemPackHeaderViewCellReuseIdentifier = "PackHeaderViewCell"
private let PacksCellReuseIdentifier = "TrendingArtistsCell"

class KeyboardMediaItemPackPickerViewController: MediaItemsCollectionBaseViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: PacksService
    private var packSliderView: PackSliderView
    private var dismissalView: UIView
    private var cancelBarView: KeyboardCancelBar
    weak var delegate: KeyboardMediaItemPackPickerViewControllerDelegate?
    private var packServiceListener: Listener?

    init(viewModel: PacksService) {
        self.viewModel = viewModel

        packSliderView = PackSliderView()
        packSliderView.translatesAutoresizingMaskIntoConstraints = false

        cancelBarView = KeyboardCancelBar()
        cancelBarView.translatesAutoresizingMaskIntoConstraints = false

        dismissalView = UIView()
        dismissalView.translatesAutoresizingMaskIntoConstraints = false
        dismissalView.backgroundColor = ClearColor

        super.init(collectionViewLayout: KeyboardMediaItemPackPickerViewController.provideLayout())

        packSliderView.slider.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.sliderDidChange(_:)), forControlEvents: .ValueChanged)
        packSliderView.slider.minimumValue = 40

        collectionView?.contentInset = UIEdgeInsets(top: 4, left: 40, bottom: 36.5, right: 9)

        viewModel.fetchCollection()

        packServiceListener = viewModel.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.reloadData()
            self?.centerOnDefaultCard()
        }

        view.backgroundColor = ClearColor
        collectionView?.backgroundColor = VeryLightGray

        view.addSubview(packSliderView)
        view.addSubview(cancelBarView)
        view.addSubview(dismissalView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        packServiceListener?.stopListening()
        packServiceListener = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap)))
        cancelBarView.cancelButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap), forControlEvents: .TouchUpInside)
        dismissalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap)))
        collectionView!.registerClass(KeyboardMediaItemPackHeaderView.self, forCellWithReuseIdentifier: KeyboardMediaItemPackHeaderViewCellReuseIdentifier)
        collectionView!.registerClass(BrowseMediaItemCollectionViewCell.self, forCellWithReuseIdentifier: PacksCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false
    }

    func setupLayout() {
        collectionView?.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + KeyboardPackPickerDismissalViewHeight, view.bounds.width, view.bounds.height - KeyboardPackPickerDismissalViewHeight)

        view.addConstraints([
            dismissalView.al_top == view.al_top,
            dismissalView.al_height == KeyboardPackPickerDismissalViewHeight,
            dismissalView.al_right == view.al_right,
            dismissalView.al_left == view.al_left,

            packSliderView.al_right == view.al_right,
            packSliderView.al_left == cancelBarView.al_right,
            packSliderView.al_bottom == view.al_bottom,
            packSliderView.al_height == 40,

            cancelBarView.al_left == view.al_left,
            cancelBarView.al_top == view.al_top + KeyboardPackPickerDismissalViewHeight,
            cancelBarView.al_bottom == view.al_bottom,
            cancelBarView.al_width == 31
        ])
    }

    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(ArtistCollectionViewCellWidth, 200)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 12.0, right: 0)
        return layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSizeMake(96.5, 200)
        }

        return CGSizeMake(ArtistCollectionViewCellWidth, 200)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        let count = viewModel.mediaItems.count <= 1 ? 0: viewModel.mediaItems.count

        self.packSliderView.slider.maximumValue = Float(ArtistCollectionViewCellWidth * CGFloat(count))

        return viewModel.mediaItems.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.5, left: 4.5, bottom: 4.5, right: 4.5)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(KeyboardMediaItemPackHeaderViewCellReuseIdentifier, forIndexPath: indexPath) as? KeyboardMediaItemPackHeaderView else {
                return UICollectionViewCell()
            }

            cell.addPacks.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.addPacksButtonDidTap(_:)) , forControlEvents: .TouchUpInside)
            cell.recentButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.recentButtonDidTap(_:)), forControlEvents: .TouchUpInside)

            return cell
        default:
            let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
            cell.addedBadgeView.hidden = true

            if let pack = viewModel.mediaItems[indexPath.row] as? PackMediaItem, let packId = pack.pack_id, let currentPackID = viewModel.pack?.pack_id {
                if packId == currentPackID {
                    cell.highlightColorBorder.hidden = false
                }
            }

            return cell
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let pack = viewModel.mediaItems[indexPath.row] as? PackMediaItem else {
            return
        }

        presentPack(pack)
    }

    func addPacksButtonDidTap(sender: UIButton) {
        openURL(NSURL(string: OftenCallbackURL)!)
    }

    func presentPack(pack: PackMediaItem) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = 0

        delegate?.keyboardMediaItemPackPickerViewControllerDidSelectPack(self, pack: pack)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func recentButtonDidTap(sender: UIButton) {
        guard let pack = PacksService.defaultInstance.recentsPack else {
            return
        }

        presentPack(pack)
    }

    func cancelButtonDidTap()  {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

        packSliderView.slider.value = Float(scrollView.contentOffset.x)
    }

    func sliderDidChange(sender: UISlider) {
        if sender.value > 40 {
            collectionView?.setContentOffset(CGPointMake(CGFloat(sender.value) , -4), animated: false)
        } else {
            collectionView?.setContentOffset(CGPointMake(-40 , -4), animated: false)
        }
    }

    func centerOnDefaultCard() {
        let count = viewModel.mediaItems.count
        for i in 1..<count {
            if let currentPackID = viewModel.pack,
                let pack = viewModel.mediaItems[i] as? PackMediaItem where  currentPackID == pack {
                scrollToCellAtIndex(i)
            }
        }
    }

    func scrollToCellAtIndex(index: Int) {
        if let collectionView = collectionView {
            var xPosition = CGFloat(index) * (ArtistCollectionViewCellWidth + 9.0)
                - (collectionView.frame.size.width - ArtistCollectionViewCellWidth) / 2
            xPosition = max(0, min(xPosition, collectionView.contentSize.width)) + 40

            collectionView.setContentOffset(CGPointMake(xPosition, -4), animated: true)
        }
    }

    // MARK: LaunchMainApp
    func openURL(url: NSURL) {
        do {
            let application = try BaseKeyboardContainerViewController.sharedApplication(self)
             application.performSelector(#selector(KeyboardMediaItemPackPickerViewController.openURL(_:)), withObject: url)
        }
        catch {

        }
    }
}

protocol KeyboardMediaItemPackPickerViewControllerDelegate: class {
    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem)
}