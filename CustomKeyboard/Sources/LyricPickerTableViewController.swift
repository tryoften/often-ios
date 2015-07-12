//
//  LyricPickerTableViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift

class LyricPickerTableViewController: UITableViewController, UITableViewDelegate, SectionPickerViewDelegate,
    LyricTableViewCellDelegate, LyricFilterBarDelegate, LyricPickerViewModelDelegate {

    weak var delegate: LyricPickerDelegate?
    var viewModel: LyricPickerViewModel
    var selectedRows = [Int: Bool]()
    var selectedRow: NSIndexPath?
    var selectedCell: LyricTableViewCell?
    var animatingCell: Bool!
    var searchModeOn: Bool!
    
    init(viewModel: LyricPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animatingCell = false
        searchModeOn = false

        tableView.backgroundColor = KeyboardTableViewBackgroundColor
        tableView.registerClass(LyricTableViewCell.self, forCellReuseIdentifier: LyricTableViewCellIdentifier)
        tableView.registerClass(LyricPickerTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLyricsInSection(section)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("sectionHeader") as? LyricPickerTableSectionHeaderView
        
        if let category = viewModel.categoryAtIndex(section) {
            let title = viewModel.sectionTitleAtIndex(section)
            headerView?.title = title
            headerView?.lyricsCount = category.lyricsCount
            headerView?.highlightColorView.backgroundColor = category.highlightColor
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LyricTableViewCellIdentifier, forIndexPath: indexPath) as! LyricTableViewCell
        
        if let lyric = viewModel.lyricAtIndexInSection(indexPath.row, section: indexPath.section) {
            cell.lyric = lyric
            cell.delegate = self
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LyricTableViewCell
        
        selectedRow = indexPath
        selectedCell = cell
        
        if let lyric = viewModel.lyricAtIndexInSection(indexPath.row, section: indexPath.section) {
            self.viewModel.getTrackForLyric(lyric, completion: { track in
                cell.shareVC!.lyric = lyric
                cell.metadataView.track = track
            })
        }
        
        animatingCell = true
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.animatingCell = false
        })
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        CATransaction.commit()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = nil
        selectedCell = nil
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if interfaceOrientation == .LandscapeLeft
            || interfaceOrientation == .LandscapeRight {

            if indexPath == selectedRow {
                return 167
            }
        }
        
        if indexPath == selectedRow {
            return KeyboardHeight - SectionPickerViewHeight - 25.0
        }
        return LyricTableViewCellHeight
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == .LandscapeLeft
            || toInterfaceOrientation == .LandscapeRight {
                tableView.reloadData()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestRow()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if selectedRow != nil && !animatingCell && !scrollView.decelerating {
            selectedRow = nil
            selectedCell = nil
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            CATransaction.commit()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }
    
    func scrollToNearestRow() {
        var point = tableView.contentOffset
        point.y = point.y + LyricTableViewCellHeight / 2
        
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            if isRowPresentInTableView(indexPath) {
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            }
        }
    }
    
    func isRowPresentInTableView(indexPath: NSIndexPath) -> Bool {
        if indexPath.section < tableView.numberOfSections() {
            if indexPath.row < tableView.numberOfRowsInSection(indexPath.section) {
                return true
            }
        }
        return false
    }
    
    // MARK: SectionPickerViewDelegate
    
    func didSelectSection(sectionPickerView: CategoriesPanelView, category: Category, index: Int) {
        selectedRow = nil
        selectedCell = nil
        
        let indexPath = NSIndexPath(forRow: 0, inSection: index)
        
        if self.tableView.numberOfSections() > 0 && self.tableView.numberOfRowsInSection(0) > 0 {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }

    // MARK: LyricTableViewCellDelegate
    
    func lyricTableViewCellDidSelect(cell: LyricTableViewCell) {
        if tableView.decelerating {
            return
        }
        
        if let indexPath = tableView.indexPathForCell(cell) {
            selectedRow = indexPath
            var selected = selectedRows[indexPath.row]
            
            if selected == nil || selected == false {
                delegate?.didPickLyric(self, shareVC: cell.shareVC, lyric: cell.lyric)
                var data = [NSString: AnyObject]()
                data["lyric"] = cell.lyric

                var notification = NSNotification(name: LyricSelectedEventIdentifier, object: nil, userInfo: data)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        }
    }
    
    // MARK: LyricFilterBarDelegate

    func lyricFilterBarShouldShowKeyboard(lyricFilterBar: LyricFilterBar, showKeyboard: Bool) {
    }
    
    func lyricFilterBarStateDidChange(lyricFilterBar: LyricFilterBar, hidden: Bool) {
    }
    
    func lyricFilterBarTextDidChange(lyricFilterBar: LyricFilterBar, searchText: String) {
    }
    
    // MARK: LyricPickerViewModelDelegate
    
    func lyricPickerViewModelDidLoadData(viewModel: LyricPickerViewModel, categories: [Category]) {
        tableView.reloadData()
    }
}

protocol LyricPickerDelegate: class {
    func didPickLyric(lyricPicker: LyricPickerTableViewController,shareVC: ShareViewController, lyric: Lyric?)
}
