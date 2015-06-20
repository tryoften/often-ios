//
//  SelectArtistWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SelectArtistWalkthroughViewController: WalkthroughViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    let kCellIdentifier = "signUpAddArtistsTableViewCell"
    var selectedArtistes = [NSNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.allowsSelection = false
        
        viewModel.delegate = self
        viewModel.getListOfArtists()
        
        tableView.registerClass(SignUpAddArtistsTableViewCell.classForCoder(), forCellReuseIdentifier: kCellIdentifier)
        
        setupNavBar("done")
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "add artists".uppercaseString
        
    }
    
    override func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            tableView.al_top == view.al_top,
            tableView.al_bottom == view.al_bottom,
            tableView.al_left == view.al_left,
            tableView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artistsList.count
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //TODO: make a view for this
        var recommendedLabel = UILabel()
        let titleString = "recommended".uppercaseString
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        let headerView = UIView()
        var spacer = UIView()
        
        recommendedLabel.frame = CGRectMake(20, 8, tableView.frame.size.width, 20)
        recommendedLabel.font = UIFont(name: "OpenSans", size: 9)
        
        title.addAttribute(NSFontAttributeName, value: recommendedLabel.font!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.0, range: titleRange)
        
        recommendedLabel.attributedText = title
        
        spacer.frame = CGRectMake(0, 34, tableView.frame.size.width, 1)
        spacer.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(recommendedLabel)
        headerView.addSubview(spacer)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SignUpAddArtistsTableViewCell = SignUpAddArtistsTableViewCell(style: .Default, reuseIdentifier: kCellIdentifier)
        
        let lyricCount = viewModel.artistsList[indexPath.row].lyricCount as NSNumber
        
        for objects in selectedArtistes {
            if objects.integerValue == indexPath.row {
                cell.selectionButton.selected = true
            }
        }
        
        cell.lyricsCountLabel!.text = lyricCount.stringValue
        cell.artistNameLabel!.text = viewModel.artistsList[indexPath.row].name
        cell.artistImageView.setImageWithURL(NSURL(string: viewModel.artistsList[indexPath.row].imageURLLarge), placeholderImage: UIImage(named: "ArtistPicture")!)
        cell.selectionButton.addTarget(self, action: "didTapSelectButton:", forControlEvents: .TouchUpInside)
        cell.selectionButton.tag = indexPath.row
        
        return cell
    }
    
    func didTapSelectButton(sender : UIButton) {
        let buttonTag = NSNumber(integer: sender.tag)
        
        sender.selected = !sender.selected
        
        if sender.selected {
            selectedArtistes.append(buttonTag)
        } else  {
            for objects in selectedArtistes {
                if objects == buttonTag {
                    if let foundIndex = find(selectedArtistes, objects) {
                        selectedArtistes.removeAtIndex(foundIndex)
                    }
                }
            }
        }
    }
    
    override func didTapNavButton() {
        for objects in selectedArtistes {
            let keyboardId = viewModel.artistsList[objects.integerValue].keyboardId
            if (keyboardId != "") {
                viewModel.artistSelectedList?.append(keyboardId)
            }
        }
        println(viewModel.artistSelectedList!)
        if ArtistsSelectedListIsValid(viewModel.artistSelectedList!) {
            viewModel.sessionManager.setKeyboardsOnCurrentUser(viewModel.artistSelectedList!, completion: { (user, error) in
                self.presentViewController(TabBarController(), animated: true, completion: nil)
            })
        } else {
            println("need to pick at lest one")
            return
        }
        
    }
    
    func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist]) {
        tableView.reloadData()
    }
    
}
