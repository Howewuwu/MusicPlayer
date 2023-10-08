//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Howe on 2023/10/5."
//

import Foundation
import UIKit

struct Song {
    var artist : String
    var albumName : String
    var songName: String
    var coverImage : UIImage?
    var fileUrl : URL
}



let songs : [Song] = [
    Song(
        artist: "林宥嘉",
        albumName: "THE GREAT YOGA 演唱會",
        songName: "感同身受 live",
        coverImage: UIImage(named: "林宥嘉"),
        fileUrl: Bundle.main.url(forResource: "感同身受 live", withExtension: "mp3")!),
    
    Song(
        artist: "Sasha Sloan",
        albumName: "Dancing With Your Ghost - Single",
        songName: "Dancing With Your Ghost",
        coverImage: UIImage(named: "Sasha Sloan"),
        fileUrl: Bundle.main.url(forResource: "Dancing With Your Ghost", withExtension: "mp3")!),
    
    Song(
        artist: "滅火器 Fire EX",
        albumName: "進擊下半場",
        songName: "長途夜車",
        coverImage: UIImage(named: "滅火器 Fire EX"),
        fileUrl: Bundle.main.url(forResource: "長途夜車", withExtension: "mp3")!),
    
    Song(artist: "milet",
         albumName: "Anytime Anywhere - Single",
         songName: "Anytime Anywhere",
         coverImage: UIImage(named: "milet"),
         fileUrl: Bundle.main.url(forResource: "Anytime Anywhere", withExtension: "mp3")!)
]
