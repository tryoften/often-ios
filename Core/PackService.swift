//
//  PackService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class PackService {
    static let defaultInstance = PackService()
    var packs: [PackMediaItem]

    let didUpdatePacks = Event<[PackMediaItem]>()
    let ref: Firebase

    init(baseRef: Firebase = Firebase(url: BaseURL)) {
        packs = []
        ref = baseRef.childByAppendingPath("packs")
        ref.observeEventType(.Value, withBlock: self.onDataReceived)
    }

    private func onDataReceived(snapshot: FDataSnapshot!) {
        var newPacks = [PackMediaItem]()
        if let data = snapshot.value as? [String: AnyObject] {

            for (_, packData) in data {
                if let packData = packData as? [String: AnyObject] {
                    let pack = PackMediaItem(data: packData)
                    newPacks.append(pack)
                }
            }

            self.packs = newPacks.sort { $0.name < $1.name }
            self.didUpdatePacks.emit(self.packs)
        }
    }

    func assignPack(lyric: LyricMediaItem, pack: PackMediaItem) {
        guard let userId = SessionManagerFlags.defaultManagerFlags.userId else {
            return
        }

        let userQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        userQueueRef.setValue([
            "task": "assignPack",
            "user": userId,
            "result": lyric.toDictionary(),
            "pack": pack.toDictionary()
            ])
    }
}