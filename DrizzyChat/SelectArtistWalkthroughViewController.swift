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
    var selectedArtistes = [NSNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.allowsSelection = false
        
        viewModel.getListOfArtists()
        
        tableView.registerClass(SignUpAddArtistsTableViewCell.classForCoder(), forCellReuseIdentifier: AddArtistsTableViewCellReuseIdentifier)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var navBar = NavBarTitleView(frame: CGRectMake(0,0, 150, 40))
        navBar.navBarTitle.text =  "add artists".uppercaseString
        navigationItem.titleView = navBar
        
        navigationController?.navigationBar.hidden = false
    }
    
    override func setupLayout() {
        super.setupLayout()

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
        let titleString = "choose at least 3".uppercaseString
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
        let cell : SignUpAddArtistsTableViewCell = SignUpAddArtistsTableViewCell(style: .Default, reuseIdentifier: AddArtistsTableViewCellReuseIdentifier)
        
        let lyricCount = viewModel.artistsList[indexPath.row].lyricCount as NSNumber
        
        for objects in selectedArtistes {
            if objects.integerValue == indexPath.row {
                cell.selectionButton.selected = true
            }
        }
        
        cell.lyricsCountLabel!.text = "\(lyricCount) lyrics"
        cell.artistNameLabel!.text = viewModel.artistsList[indexPath.row].name
        cell.artistImageView.setImageWithURL(NSURL(string: viewModel.artistsList[indexPath.row].imageURLLarge), placeholderImage: UIImage(named: "placeholder")!)
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
        
        slideUpNextButton()
    }
    
    func slideUpNextButton() {
        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            if self.selectedArtistes.count >= 3 && self.didAnimateUp  {
                self.nextButton.hidden = false
                self.nextButton.frame.origin.y -= 50
                insets = UIEdgeInsets(top: 0, left: 0, bottom: self.nextButton.frame.height, right: 0)
                self.tableView.contentInset = insets
                self.didAnimateUp = false
            } else if self.selectedArtistes.count <= 2 && self.didAnimateUp == false  {
                self.nextButton.frame.origin.y += 50
                self.didAnimateUp = true
                self.tableView.contentInset = insets
                self.hideButton = true
            }
            }, completion: {
                (finished: Bool) in
                if self.hideButton {
                    self.nextButton.hidden = true
                    self.hideButton = false
                }
        })
    }

    override func didTapNavButton() {
        for objects in selectedArtistes {
            let keyboardId = viewModel.artistsList[objects.integerValue].keyboardId
            if (keyboardId != "") {
                viewModel.artistSelectedList?.append(keyboardId)
            }
        }
        
        if ArtistsSelectedListIsValid(viewModel.artistSelectedList!) {
            viewModel.sessionManager.setKeyboardsOnCurrentUser(viewModel.artistSelectedList!, completion: { (user, error) in
                if error == nil {
                    let postSelectArtistvc = SignUpPostAddArtistsLoaderViewController(viewModel: self.viewModel)
                    self.navigationController?.pushViewController(postSelectArtistvc, animated: true)
                }
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
