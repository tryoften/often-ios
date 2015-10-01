//
//  SignupViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupViewController: UIViewController, UIScrollViewDelegate {
    var viewModel: SignupViewModel
    var signupView: SignupView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [UIImageView]
    var pageImages: [UIImage]
    var pagesubTitle: [String]

    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        signupView = SignupView()
        signupView.translatesAutoresizingMaskIntoConstraints = false
        
        pageWidth = screenWidth - 40
        
        pagesScrollViewSize = signupView.scrollView.frame.size
        
        pageCount = 0
        
        pageViews = [UIImageView]()
        
        pageImages = [
            UIImage(named: "productWalkthroughStep_1")!,
            UIImage(named: "productWalkthroughStep_2")!,
            UIImage(named: "productWalkthroughStep_3")!,
            UIImage(named: "productWalkthroughStep_4")!,
        ]
        
        pagesubTitle = [
            "The non-basic keyboard. Share the latest videos, songs, GIFs & news from any app.",
            "The first Hip Hop and Pop Culture powered search experience. No Bullsh*t.",
            "Know what you’re looking for? Use an app directly by hashtagging it’s name. #Easy",
            "Save your favorite songs, videos, GIF’s and links to easily share them again later."
        ]

        super.init(nibName: nil, bundle: nil)
        
        signupView.scrollView.delegate = self
        
        view.addSubview(signupView)
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupView.createAccountButton.addTarget(self,  action: "didTapcreateAccountButton:", forControlEvents: .TouchUpInside)
        signupView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        setupPages()
        loadVisiblePages()
    }
    
    
    func loadVisiblePages() {
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = pageImages[page]
        imageView.contentMode = .ScaleAspectFit
        
        signupView.scrollView.addSubview(imageView)
        
        signupView.scrollView.addConstraints([
            imageView.al_top == signupView.scrollView.al_top,
            imageView.al_height == signupView.scrollView.al_height,
            imageView.al_width == signupView.scrollView.al_width,
            imageView.al_left == signupView.scrollView.al_left + pageWidth * CGFloat(page)
            ])
        
        pageViews.append(imageView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let subtitleString = pagesubTitle[currentPage]
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
        
        signupView.pageControl.currentPage = currentPage
        signupView.subtitleLabel.text = subtitleString
        signupView.subtitleLabel.attributedText = subtitle
        signupView.subtitleLabel.textAlignment = .Center
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    func setupPages() {
        pageCount = pageImages.count
        signupView.pageControl.numberOfPages = pageCount
        
        signupView.scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    func didTapcreateAccountButton(sender: UIButton) {
        let createAccount = CreateAccountViewController(viewModel:self.viewModel)
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    func didTapSigninButton(sender: UIButton) {
        let createAccount = SigninViewController(viewModel:self.viewModel)
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentPage: Int {
        return Int(floor((signupView.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            signupView.al_bottom == view.al_bottom,
            signupView.al_top == view.al_top,
            signupView.al_left == view.al_left,
            signupView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

}