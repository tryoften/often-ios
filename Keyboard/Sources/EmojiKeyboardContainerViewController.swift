//
//  EmojiKeyboardContainerViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 2/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiKeyboardContainerViewController: UIViewController, EmojiSectionSelectable {
    var emojiTableView: EmojiKeyboardTableViewController
    var sectionSelectorView: EmojiSectionSelectorView
    var textProcessor: TextProcessingManager?
    
    // May not need the View Model in the new system - Plist info is only in there
    init(viewModel: EmojiKeyboardViewModel) {
        emojiTableView = EmojiKeyboardTableViewController(viewModel: viewModel)
        
        sectionSelectorView = EmojiSectionSelectorView()
        
        super.init(nibName: nil, bundle: nil)
        
        sectionSelectorView.sectionSelectionDelegate = self
        
        view.backgroundColor = ClearColor
        
        view.addSubview(emojiTableView.view)
        view.addSubview(sectionSelectorView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emojiTableView.view.frame = view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sectionSelectorView.frame = CGRectMake(view.frame.width - 40, 0, 40, view.frame.height)
    }
    
    // MARK: EmojiSectionSelectable
    func scrollToEmojiSection(section: Int) {
        emojiTableView.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
}
