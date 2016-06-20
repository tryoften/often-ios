/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import Material

class ViewController: UIViewController {
    
    @IBOutlet weak var toolbar: Toolbar!
	
	@IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint?
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		adjustToOrientation(toInterfaceOrientation)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		prepareView()
		prepareToolbar()
		adjustToOrientation(MaterialDevice.orientation)
    }
	
	/// Adjusts the Toolbar height to the correct height based on the orientation value.
	private func adjustToOrientation(toInterfaceOrientation: UIInterfaceOrientation) {
		// If landscape.
		if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
			/**
			The height of the Toolbar is dependant on the device being used.
			If the device is an iPad, the height should stay the same as in Portrait
			view, otherwise it should strink to the Landscape height for iPhone.
			*/
			toolbarHeightConstraint?.constant = .iPad == MaterialDevice.type ? toolbar!.heightForPortraitOrientation :  toolbar!.heightForLandscapeOrientation
		} else {
			toolbarHeightConstraint?.constant = toolbar!.heightForPortraitOrientation
		}
	}
	
	/// General preparation statements.
    private func prepareView() {
		view.backgroundColor = MaterialColor.white
    }
	
	/// Prepare the toolbar.
    func prepareToolbar() {
		// Stylize.
        toolbar.backgroundColor = MaterialColor.indigo.darken1
		
        // To lighten the status bar add the "View controller-based status bar appearance = NO"
        // to your info.plist file and set the following property.
        toolbar.statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Material"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regular
        toolbar.titleLabel = titleLabel
		
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Build Beautiful Software"
        detailLabel.textAlignment = .Left
        detailLabel.textColor = MaterialColor.white
        detailLabel.font = RobotoFont.regular
        toolbar.detailLabel = detailLabel
		
        // Menu button.
        let img1: UIImage? = MaterialIcon.cm.menu
        let btn1: FlatButton = FlatButton()
        btn1.pulseScale = false
		btn1.pulseColor = MaterialColor.white
		btn1.tintColor = MaterialColor.white
		btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        
        // Star button.
        let img2: UIImage? = MaterialIcon.cm.star
        let btn2: FlatButton = FlatButton()
        btn2.pulseScale = false
		btn2.pulseColor = MaterialColor.white
		btn2.tintColor = MaterialColor.white
        btn2.setImage(img2, forState: .Normal)
        btn2.setImage(img2, forState: .Highlighted)
        
        // Search button.
        let img3: UIImage? = MaterialIcon.cm.search
        let btn3: FlatButton = FlatButton()
        btn3.pulseScale = false
        btn3.pulseColor = MaterialColor.white
		btn3.tintColor = MaterialColor.white
		btn3.setImage(img3, forState: .Normal)
        btn3.setImage(img3, forState: .Highlighted)
        
        // Add buttons to left side.
        toolbar.leftControls = [btn1]
        
        // Add buttons to right side.
        toolbar.rightControls = [btn2, btn3]
    }
}

