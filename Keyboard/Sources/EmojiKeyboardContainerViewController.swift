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
    
    init(viewModel: EmojiKeyboardViewModel) {
        emojiTableView = EmojiKeyboardTableViewController(viewModel: viewModel)
        
        sectionSelectorView = EmojiSectionSelectorView()
        sectionSelectorView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        sectionSelectorView.sectionSelectionDelegate = self
        
        view.backgroundColor = ClearColor
        
        view.addSubview(emojiTableView.view)
        view.addSubview(sectionSelectorView)
        
        setupLayout()
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
    
    // MARK: EmojiSectionSelectable
    func scrollToEmojiSection(section: Int) {
        emojiTableView.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func setupLayout() {
        view.addConstraints([
            sectionSelectorView.al_right == view.al_right,
            sectionSelectorView.al_top == view.al_top,
            sectionSelectorView.al_bottom == view.al_bottom,
            sectionSelectorView.al_width == 40
        ])
    }
}
