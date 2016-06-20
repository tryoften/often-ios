//
//  ImageManagerExtension.swift
//  Often
//
//  Created by Kervins Valcourt on 6/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Nuke
import NukeAnimatedImagePlugin
import DFCache

extension ImageManager {

    func setupImageManager() {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()
        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))

        var managerConf = ImageManager.shared.configuration
        var loaderConf = (managerConf.loader as? ImageLoader)!.configuration
        loaderConf.cache = DFDiskCache(name: "often-cache")
        managerConf.loader = ImageLoader(configuration: loaderConf, delegate: AnimatedImageLoaderDelegate())
        ImageManager.shared = (ImageManager(configuration: managerConf))
    }
}