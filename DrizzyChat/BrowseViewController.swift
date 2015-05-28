//
//  BrowseViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UITableViewDelegate {

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
    
    func setupLayout(){
        
    }
}
