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
    var layout: KeyboardLayout
    var layoutEngine: KeyboardLayoutEngine?
    var constraintsAdded: Bool = false
    var currentPage: Int = 0
    var allKeys: [KeyboardKeyButton] {
        get {
            var keys = [KeyboardKeyButton]()
            for page in layout.pages {
                for rowKeys in page.rows {
                    for key in rowKeys {
                        if let keyView = layoutEngine?.viewForKey(key) {
                            keys.append(keyView as KeyboardKeyButton)
                        }
                    }
                }
            }
            return keys
        }
    }
    
    enum EmojiReuseIdentifier: String {
        case Nature = "Nature"
        case Objects = "Objects"
        case People = "People"
        case Places = "Places"
        case Symbols = "Symbols"
    }
    
    init(viewModel: EmojiKeyboardViewModel) {
        self.viewModel = viewModel
        
        if let defaultLayout = KeyboardLayouts[.Emoji] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }
        
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
        cell?.keysContainerView.frame = (cell?.frame)!
        cell?.userInteractionEnabled = false // Because setupKeys not setting up Targets yet

        layoutEngine = KeyboardLayoutEngine(model: layout, superview: (cell?.keysContainerView)!, layoutConstants: LayoutConstants.self)
        layoutEngine?.layoutKeys(indexPath.row, uppercase: false, characterUppercase: false, shiftState: .Disabled)
        setupKeys()
      
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
        
        // Still using Plist
        let currentEmojiSet = viewModel.emojis![emojiSection] as? [String]
        let sectionHeight = CGFloat((((currentEmojiSet?.count)! / 8) + 1) * 30)
        
        return 650 //sectionHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func setupKeys() {
        let setupKey: (KeyboardKey) -> (KeyboardKeyButton?) = { key in
            if let keyView = self.layoutEngine?.viewForKey(key) {
                keyView.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                switch key {
                case .modifier(.SwitchKeyboard, _):
                    keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                case .modifier(.Backspace, _):
                    let cancelEvents: UIControlEvents = [
                        UIControlEvents.TouchUpInside,
                        UIControlEvents.TouchDragExit,
                        UIControlEvents.TouchUpOutside,
                        UIControlEvents.TouchCancel,
                        UIControlEvents.TouchDragOutside
                    ]
                    keyView.addTarget(self, action: "backspaceDown:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "backspaceUp:", forControlEvents: cancelEvents)
                case .modifier(.CapsLock, _):
                    keyView.addTarget(self, action: "shiftDown:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "shiftUp:", forControlEvents: .TouchUpInside)
                    keyView.addTarget(self, action: "shiftDoubleTapped:", forControlEvents: .TouchDownRepeat)
                case .modifier(.Space, _):
                    keyView.addTarget(self, action: "didTapSpaceButton:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseSpaceButton:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.CallService, _):
                    keyView.addTarget(self, action: "didTapCallKey:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseCallKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.Share, _):
                    keyView.addTarget(self, action: "didTapShareKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .modifier(.Enter, _):
                    keyView.addTarget(self, action: "didTapEnterKey:", forControlEvents: .TouchDown)
                    keyView.addTarget(self, action: "didReleaseEnterKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                case .changePage(_, _):
                    keyView.addTarget(self, action: "pageChangeTapped:", forControlEvents: .TouchDown)
                default:
                    break
                }
                
                if key.isCharacter {
                    if UIDevice.currentDevice().userInterfaceIdiom != UIUserInterfaceIdiom.Pad {
                        keyView.addTarget(self, action: "showPopup:", forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                        keyView.addTarget(keyView, action: "hidePopup", forControlEvents: [.TouchDragExit, .TouchCancel])
                        keyView.addTarget(self, action: "hidePopupDelay:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside])
                    }
                }
                
                if !key.isModifier {
                    keyView.addTarget(self, action: "highlightKey:", forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                    keyView.addTarget(self, action: "unHighlightKey:", forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                }
                
                if key.hasOutput {
                    keyView.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
                }
                
                return keyView
            }
            return nil
        }
        
        let page = layout.pages[currentPage]
        for rowKeys in page.rows {
            for key in rowKeys {
                setupKey(key)
            }
        }
        
    }
}
