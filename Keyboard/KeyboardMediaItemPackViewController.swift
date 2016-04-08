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

class KeyboardMediaItemPackPickerViewController: MediaItemsCollectionBaseViewController, MediaItemsViewModelDelegate {
    var viewModel: PacksService
    var packPanelView: PackPanelView
    weak var delegate: KeyboardMediaItemPackPickerViewControllerDelegate?
    var packServiceListener: Listener?
    var mediaItems: MediaItemGroup? {
        didSet {
            collectionView?.reloadData()
        }
    }

     init(viewModel: PacksService) {
        self.viewModel = viewModel

        packPanelView = PackPanelView()
        packPanelView.translatesAutoresizingMaskIntoConstraints = false

        super.init(collectionViewLayout: KeyboardMediaItemPackPickerViewController.provideLayout())

        collectionView?.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)

        viewModel.fetchCollection()

        packServiceListener = PacksService.defaultInstance.didUpdatePacks.on { items in
            self.collectionView?.reloadData()
        }

        view.backgroundColor = VeryLightGray
        view.addSubview(packPanelView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        packPanelView.cancelButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap(_:)), forControlEvents: .TouchUpInside)

        collectionView!.registerClass(KeyboardMediaItemPackHeaderView.self, forCellWithReuseIdentifier: KeyboardMediaItemPackHeaderViewCellReuseIdentifier)
        collectionView!.registerClass(BrowseMediaItemCollectionViewCell.self, forCellWithReuseIdentifier: PacksCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.showsHorizontalScrollIndicator = false
    }

    func setupLayout() {
        view.addConstraints([
            packPanelView.al_right == view.al_right,
            packPanelView.al_left == view.al_left,
            packPanelView.al_bottom == view.al_bottom,
            packPanelView.al_height == 40
            ])
    }

    class func provideLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(ArtistCollectionViewCellWidth, 210)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 12.5, left: 10.0, bottom: 12.0, right: 10.0)
        return layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

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
            cell.favoriteButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.favoriteButtonDidTap(_:)), forControlEvents: .TouchUpInside)
            cell.recentButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.recentButtonDidTap(_:)), forControlEvents: .TouchUpInside)

            return cell
        default:
            let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
            cell.addedBadgeView.hidden = true

            return cell
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let pack = viewModel.mediaItems[indexPath.row] as? PackMediaItem else {
            return
        }

        delegate?.keyboardMediaItemPackPickerViewControllerDidSelectPack(self, pack: pack)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func addPacksButtonDidTap(sender: UIButton) {
        openURL(NSURL(string: OftenCallbackURL)!)
    }

    func favoriteButtonDidTap(sender: UIButton) {
        let favoritesVC = KeyboardFavoritesViewController(viewModel: FavoritesService.defaultInstance)
        favoritesVC.transitioningDelegate = self
        favoritesVC.modalPresentationStyle = .Custom
        presentViewController(favoritesVC, animated: true, completion: nil)
    }

    func recentButtonDidTap(sender: UIButton) {
        let recentVC = KeyboardRecentsViewController(viewModel: RecentsViewModel())
        recentVC.transitioningDelegate = self
        recentVC.modalPresentationStyle = .Custom
        presentViewController(recentVC, animated: true, completion: nil)
    }

    func cancelButtonDidTap(sender: UIButton)  {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: MediaItemsViewModelDelegate
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User) {
    }

    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError) {
        collectionView?.hidden = false
    }

    func mediaLinksViewModelDidCreateMediaItemGroups(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup]) {
        mediaItems = viewModel.generateMediaItemGroups().first
    }

    // MARK: LaunchMainApp
    func openURL(url: NSURL) {
        do {
            let application = try self.sharedApplication()
             application.performSelector(#selector(KeyboardMediaItemPackPickerViewController.openURL(_:)), withObject: url)
        }
        catch {

        }
    }

    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.nextResponder()
        }

        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }

    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: true, resizePresentingViewController: false, lowerPresentingViewController: true)
        return animator
    }

}

protocol KeyboardMediaItemPackPickerViewControllerDelegate: class {
    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem)
}