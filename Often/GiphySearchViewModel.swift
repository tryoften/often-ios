//
//  GiphySearchViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 7/19/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Alamofire

class GiphySearchViewModel: NSObject {
    weak var delegate: GiphySearchViewModelDelegate?
    var giphyResluts: [GifMediaItem]
    var selectedGif: GifMediaItem?

    override init() {
        giphyResluts = []

    }

    func clearSearchResluts() {
        giphyResluts = []
        selectedGif = nil
    }

    func fetchTrendingData() {
        let endpoint: String = "http://api.giphy.com/v1/gifs/trending"
        let params: [String : AnyObject] = [
            "api_key": GiphyAPIKey
        ]

        Manager.sharedInstance.request(.GET, endpoint, parameters: params, encoding: .URL, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                self.parseJSONData(JSON)
            }

        }
    }

    func searchRequestFor(term: String) {
        let endpoint: String = "http://api.giphy.com/v1/gifs/search"
        let params: [String : AnyObject] = [
            "q": term,
            "api_key": GiphyAPIKey
        ]

        Manager.sharedInstance.request(.GET, endpoint, parameters: params, encoding: .URL, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                self.parseJSONData(JSON)
            }
        }
    }

    func parseJSONData(JSON: AnyObject) {
        clearSearchResluts()

        if let data = JSON as? [String: AnyObject],
            let gifs = data["data"] as? [NSDictionary] {
            for gifData in gifs {
                let gif = GifMediaItem(giphyData: gifData)
                giphyResluts.append(gif)
            }
            delegate?.giphySearchViewModelDelegateDataDidLoad(self, gifs: giphyResluts)
        }

    }

    func selectGifAddToPack(gif: GifMediaItem?) {
        selectedGif = gif

    }

}

protocol GiphySearchViewModelDelegate: class {
    func giphySearchViewModelDelegateDataDidLoad(viewModel: GiphySearchViewModel, gifs: [GifMediaItem]?)
}