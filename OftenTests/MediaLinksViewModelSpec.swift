//
//  MediaLinksViewModelSpec.swift
//  Often
//
//  Created by Luc Succes on 12/3/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Nimble
import Quick
import Firebase

class MediaLinksViewModelSpec: QuickSpec {
    override func spec() {
        describe("MediaLinksViewModel") {
            var viewModel: MediaLinksViewModel!

            beforeEach {
//                viewModel = MediaLinksViewModel(baseRef: Firebase(url: BaseURL))
            }

            it("fetches data") {
                do {
                try viewModel.fetchFavorites()
                } catch _ {

                }
            }
        }
    }
}
