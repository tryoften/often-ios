//
//  BrowseViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var coverPhotoView: UIImageView!
    var pageControl: UIPageControl!
    //var tracks: [Track]?
    var viewModel: BrowseViewModel?
    
//    init(viewModel: BrowseViewModel) {
//        self.viewModel = viewModel
//        super.init(
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        setupLayout()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func setupLayout(){
        
    }
}
