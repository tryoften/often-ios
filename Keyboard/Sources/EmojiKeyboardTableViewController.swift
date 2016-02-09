//
//  EmojiKeyboardCollectionViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 2/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

private let EmojiCellReuseIdentifier = "emojiCell"

class EmojiKeyboardTableViewController: UITableViewController {
    var viewModel: EmojiKeyboardViewModel
    
    enum EmojiReuseIdentifier: String {
        case Nature = "Nature"
        case Objects = "Objects"
        case People = "People"
        case Places = "Places"
        case Symbols = "Symbols"
    }
    
    init(viewModel: EmojiKeyboardViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        if let tableView = tableView {
            tableView.registerClass(EmojiKeyboardTableViewCell.self, forCellReuseIdentifier: EmojiReuseIdentifier.Nature.rawValue)
            tableView.registerClass(EmojiKeyboardTableViewCell.self, forCellReuseIdentifier: EmojiReuseIdentifier.Objects.rawValue)
            tableView.registerClass(EmojiKeyboardTableViewCell.self, forCellReuseIdentifier: EmojiReuseIdentifier.People.rawValue)
            tableView.registerClass(EmojiKeyboardTableViewCell.self, forCellReuseIdentifier: EmojiReuseIdentifier.Places.rawValue)
            tableView.registerClass(EmojiKeyboardTableViewCell.self, forCellReuseIdentifier: EmojiReuseIdentifier.Symbols.rawValue)
            tableView.registerClass(EmojiSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "emojiSection")
            tableView.backgroundView = UIView()
            tableView.backgroundView?.backgroundColor = UIColor(fromHexString: "#EDEDED")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sectionCount = viewModel.emojis?.keys.count {
            return sectionCount
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("emojiSection") as? EmojiSectionHeaderView
    
        if section == 0 {
            headerView?.titleLabel.text = "Nature".uppercaseString
        } else if section == 1 {
            headerView?.titleLabel.text = "Objects".uppercaseString
        } else if section == 2 {
            headerView?.titleLabel.text = "People".uppercaseString
        } else if section == 3 {
            headerView?.titleLabel.text = "Places".uppercaseString
        } else {
            headerView?.titleLabel.text = "Symbols".uppercaseString
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = ""
        if indexPath.section == 0 {
            reuseIdentifier = "Nature"
        } else if indexPath.section == 1 {
            reuseIdentifier = "Objects"
        } else if indexPath.section == 2 {
            reuseIdentifier = "People"
        } else if indexPath.section == 3 {
            reuseIdentifier = "Places"
        } else {
            reuseIdentifier = "Symbols"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? EmojiKeyboardTableViewCell
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let emojiSection = reuseIdentifier
        
        let currentEmojiSet = viewModel.emojis![emojiSection] as? [String]
        let rows = (currentEmojiSet?.count)! / 8
        
        for i in 0...(currentEmojiSet?.count)! - 1 {
            let button = UIButton()
            button.setTitle("\(currentEmojiSet![i])", forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(25.0)
            button.frame = CGRectMake(CGFloat(i % 8) * ((screenWidth - 40) / 8), CGFloat(i / 8) * 30, 30, 30)
            cell?.addSubview(button)
        }
        
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let emojiSection: String
        if indexPath.section == 0 {
            emojiSection = "Nature"
        } else if indexPath.section == 1 {
            emojiSection = "Objects"
        } else if indexPath.section == 2 {
            emojiSection = "People"
        } else if indexPath.section == 3 {
            emojiSection = "Places"
        } else {
            emojiSection = "Symbols"
        }
        
        let currentEmojiSet = viewModel.emojis![emojiSection] as? [String]
        let sectionHeight = CGFloat(((currentEmojiSet?.count)! / 8) * 30)
        
        return CGFloat((((currentEmojiSet?.count)! / 8) + 1) * 30)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
