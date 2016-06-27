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
    
    init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        self.viewModel = viewModel
        
        packSliderView = PackSliderView()
        packSliderView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelBarView = KeyboardCancelBar()
        cancelBarView.translatesAutoresizingMaskIntoConstraints = false
        
        dismissalView = UIView()
        dismissalView.translatesAutoresizingMaskIntoConstraints = false
        dismissalView.backgroundColor = ClearColor
        
        super.init(collectionViewLayout: KeyboardMediaItemPackPickerViewController.provideLayout())
        
        self.textProcessor = textProcessor
        
        packSliderView.slider.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.sliderDidChange(_:)), for: .valueChanged)
        packSliderView.slider.minimumValue = 40
        
        collectionView?.contentInset = UIEdgeInsets(top: 4, left: 40, bottom: 36.5, right: 9)
        
        packServiceListener = viewModel.didUpdatePacks.on { [weak self] items in
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
        packServiceListener = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap)))
        cancelBarView.cancelButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap), for: .touchUpInside)
        dismissalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(KeyboardMediaItemPackPickerViewController.cancelButtonDidTap)))
        collectionView!.register(KeyboardMediaItemPackHeaderView.self, forCellWithReuseIdentifier: KeyboardMediaItemPackHeaderViewCellReuseIdentifier)
        collectionView!.register(BrowseMediaItemCollectionViewCell.self, forCellWithReuseIdentifier: PacksCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.clear()
        collectionView!.showsHorizontalScrollIndicator = false
        viewModel.fetchData()
    }
    
    func setupLayout() {
        collectionView?.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + KeyboardPackPickerDismissalViewHeight, width: view.bounds.width, height: view.bounds.height - KeyboardPackPickerDismissalViewHeight)
        
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
        layout.itemSize = CGSize(width: ArtistCollectionViewCellWidth, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 9.0
        layout.minimumLineSpacing = 9.0
        layout.sectionInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 12.0, right: 0)
        return layout
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath as NSIndexPath).section == 0 {
            return CGSize(width: 96.5, height: 200)
        }
        
        return CGSize(width: ArtistCollectionViewCellWidth, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        let count = viewModel.mediaItems.count <= 1 ? 0: viewModel.mediaItems.count
        
        self.packSliderView.slider.maximumValue = Float(ArtistCollectionViewCellWidth * CGFloat(count))
        
        return viewModel.mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.5, left: 4.5, bottom: 4.5, right: 4.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyboardMediaItemPackHeaderViewCellReuseIdentifier, for: indexPath) as? KeyboardMediaItemPackHeaderView else {
                return UICollectionViewCell()
            }
            
            cell.addPacks.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.addPacksButtonDidTap(_:)) , for: .touchUpInside)
            cell.recentButton.addTarget(self, action: #selector(KeyboardMediaItemPackPickerViewController.recentButtonDidTap(_:)), for: .touchUpInside)
            
            return cell
        default:
            let cell =  parsePackItemData(viewModel.mediaItems, indexPath: indexPath, collectionView: collectionView) as BrowseMediaItemCollectionViewCell
            cell.style = .keyboard
            cell.shareButton.tag = (indexPath as NSIndexPath).row
            cell.shareButton.addTarget(self, action: #selector(sharePackButtonDidTap), for: .touchUpInside)
            
            
            if let pack = viewModel.mediaItems[(indexPath as NSIndexPath).row] as? PackMediaItem, let packId = pack.pack_id, let currentPackID = viewModel.pack?.pack_id {
                if packId == currentPackID {
                    cell.highlightColorBorder.isHidden = false
                }
            }
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pack = viewModel.mediaItems[(indexPath as NSIndexPath).row] as? PackMediaItem else {
            return
        }
        
        presentPack(pack)
    }
    
    func addPacksButtonDidTap(_ sender: UIButton) {
        openURL(URL(string: OftenCallbackURL)!)
    }
    
    func presentPack(_ pack: PackMediaItem) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = 0
        
        delegate?.keyboardMediaItemPackPickerViewControllerDidSelectPack(self, pack: pack)
        dismiss(animated: true, completion: nil)
    }
    
    func recentButtonDidTap(_ sender: UIButton) {
        guard let pack = PacksService.defaultInstance.recentsPack else {
            return
        }
        
        presentPack(pack)
    }
    
    func cancelButtonDidTap()  {
        dismiss(animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        packSliderView.slider.value = Float(scrollView.contentOffset.x)
    }
    
    func sliderDidChange(_ sender: UISlider) {
        if sender.value > 40 {
            collectionView?.setContentOffset(CGPoint(x: CGFloat(sender.value) , y: -4), animated: false)
        } else {
            collectionView?.setContentOffset(CGPoint(x: -40 , y: -4), animated: false)
        }
    }
    
    func centerOnDefaultCard() {
        let count = viewModel.mediaItems.count
        
        if count > 2 {
            for i in 1..<count {
                if let currentPackID = viewModel.pack,
                    let pack = viewModel.mediaItems[i] as? PackMediaItem where  currentPackID == pack {
                    scrollToCellAtIndex(i)
                }
            }
        }
    }
    
    func scrollToCellAtIndex(_ index: Int) {
        if let collectionView = collectionView {
            var xPosition = CGFloat(index) * (ArtistCollectionViewCellWidth + 9.0)
                - (collectionView.frame.size.width - ArtistCollectionViewCellWidth) / 2
            xPosition = max(0, min(xPosition, collectionView.contentSize.width)) + 40
            
            collectionView.setContentOffset(CGPoint(x: xPosition, y: -4), animated: true)
        }
    }
    
    // MARK: LaunchMainApp
    func openURL(_ url: URL) {
        do {
            let application = try BaseKeyboardContainerViewController.sharedApplication(self)
            application.perform(#selector(KeyboardMediaItemPackPickerViewController.openURL(_:)), with: url)
        }
        catch {
            
        }
    }
    
    func sharePackButtonDidTap(_ sender: UIButton) {
        guard let pack = viewModel.mediaItems[sender.tag] as? PackMediaItem, name = pack.name, link = pack.shareLink else {
            return
        }
        textProcessor?.insertText("Yo check out this \(name) keyboard I found on Often! \(link)")
    }
    
}

protocol KeyboardMediaItemPackPickerViewControllerDelegate: class {
    func keyboardMediaItemPackPickerViewControllerDidSelectPack(_ packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem)
}
