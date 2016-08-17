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
    var giphyResults: [GifMediaItem]
    var selectedGif: GifMediaItem?

    override init() {
        giphyResults = []

    }

    func clearSearchResults() {
        giphyResults = []
        selectedGif = nil
    }

    func fetchTrendingData() {
        let params: [String: AnyObject] = [
            "api_key": GiphyAPIKey
        ]

        Manager.sharedInstance.request(.GET, GiphyTrendingEndpoint, parameters: params, encoding: .URL, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                self.parseJSONData(JSON)
            }
        }
    }

    func searchRequestFor(term: String) {
        let params: [String: AnyObject] = [
            "q": term,
            "api_key": GiphyAPIKey
        ]

        Manager.sharedInstance.request(.GET, GiphySearchEndpoint, parameters: params, encoding: .URL, headers: nil).responseJSON { response in
            if let JSON = response.result.value {
                self.parseJSONData(JSON)
            }
        }
    }

    func parseJSONData(JSON: AnyObject) {
        clearSearchResults()

        if let data = JSON as? [String: AnyObject],
            let gifs = data["data"] as? [NSDictionary] {
            for gifData in gifs {
                let gif = GifMediaItem(giphyData: gifData)
                giphyResults.append(gif)
            }
            delegate?.giphySearchViewModelDelegateDataDidLoad(self, gifs: giphyResults)
        }

    }

    func selectGifAddToPack(gif: GifMediaItem?) {
        selectedGif = gif

    }

}

protocol GiphySearchViewModelDelegate: class {
    func giphySearchViewModelDelegateDataDidLoad(viewModel: GiphySearchViewModel, gifs: [GifMediaItem]?)
}