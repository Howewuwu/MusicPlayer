//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Howe on 2023/10/4.
//

import UIKit
import AVFoundation
import UIImageColors


class MusicPlayerViewController: UIViewController {
    
    let myMusicPlayer = AVPlayer()
    
    var currentIndex = 3
    
    var gradientLayer: CAGradientLayer!
    
    var playModeImageView : UIImageView?
    
    var playMode : PlayMode? = .repeatAll
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    @IBOutlet weak var songProgressSliderOutlet: UISlider!
    @IBOutlet weak var volumeSliderOutlet: UISlider!
    
    
    @IBOutlet weak var songDurationStartLabel: UILabel!
    @IBOutlet weak var songDurationEndLabel: UILabel!
    
    
    
    @IBOutlet weak var playOrPauseButtonOutlet: UIButton!
    @IBOutlet weak var playOrPauseImageView: UIImageView!
    
    @IBOutlet weak var forwardButtonOutlet: UIButton!
    @IBOutlet weak var forwardImageView: UIImageView!
    
    @IBOutlet weak var backwardButtonOutlet: UIButton!
    @IBOutlet weak var backwardImageView: UIImageView!
    
    @IBOutlet weak var playModeButtonOutlet: UIButton!
    @IBOutlet weak var lyrisButtonOutlet: UIButton!
    @IBOutlet weak var moreActionButtonOutlet: UIButton!
    
    
    @IBOutlet weak var airPlayButtonOutlet: UIButton!
    
    
    
    
    
    // MARK: viewDidLoad Begin -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationInformation(form: currentIndex)
        
        
        
    }
    // MARK: viewDidLoad Done -
    
    
    
    
    
    @IBAction func playOrPauseSong(_ sender: UIButton) {
        switch myMusicPlayer.timeControlStatus {
            
        case .paused:
            myMusicPlayer.play()
            songProgressSliderOutlet.isEnabled = true
            let pauseImage = UIImage(systemName: "pause.fill")!
            playOrPauseImageView.setSymbolImage(pauseImage, contentTransition: .replace.downUp, options: .speed(2))
            
            UIView.animate(withDuration: 0.3) {
                self.coverImageView.transform = CGAffineTransform(scaleX: 2.3, y: 2.3)
            }
            
            
        case .waitingToPlayAtSpecifiedRate:
            print("waitingToPlayAtSpecifiedRate")
            
            
        case .playing:
            myMusicPlayer.pause()
            let playImage = UIImage(systemName: "play.fill")!
            playOrPauseImageView.setSymbolImage(playImage, contentTransition: .replace.downUp, options: .speed(2))
            
            UIView.animate(withDuration: 0.3) {
                self.coverImageView.transform = CGAffineTransform.identity
            }
            
        default:
            break
        }
    }
    
    
    
    
    
    
    
    @IBAction func songProgressSliderChange(_ sender: UISlider) {
        // 獲得滑塊的位置
        let sliderValue = sender.value
        
        // 獲得音樂的總時間（單位秒）
        let duration = CMTimeGetSeconds(myMusicPlayer.currentItem!.duration)
        
        // 計算新的播放時間
        let newTime = Double(sliderValue) * duration
        
        // 將新的播放時間設定到播放器
        let seekTime = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
        myMusicPlayer.seek(to: seekTime)
        
        // 計算了新的時間（以秒為單位），並將其轉換為格式化的字符串，用於顯示當前時間和總時間。（當拉動thumb時會即時更新Label）
        songDurationStartLabel.text = String(format: "%02d:%02d", Int(newTime) / 60, Int(newTime) % 60)
        songDurationEndLabel.text = String(format: "%02d:%02d", Int(duration) / 60, Int(duration) % 60)
        
    }
    
    
    
    
    @IBAction func nextSong(_ sender: UIButton) {
        forwardImageView.addSymbolEffect(.bounce.up)
        forwardImageView.addSymbolEffect(.bounce.down)
        
        if playMode == .shuffle {
            currentIndex = Int.random(in: 0...3)
            playNewSong(from: currentIndex)
            
        } else{
            
            currentIndex += 1
            if currentIndex == songs.count {
                currentIndex = 0
            }
            playNewSong(from: currentIndex)
        }
        
    }
    
    
    
    
    
    @IBAction func previousSong(_ sender: UIButton) {
        backwardImageView.addSymbolEffect(.bounce.up)
        backwardImageView.addSymbolEffect(.bounce.down)
        
        if playMode == .shuffle {
            currentIndex = Int.random(in: 0...3)
            playNewSong(from: currentIndex)
            
        } else{
            
            currentIndex -= 1
            if currentIndex < 0  {
                currentIndex = songs.count - 1
            }
            playNewSong(from: currentIndex)
        }
    }
    
    
    
    
    
    
    
    
    
    @IBAction func playModeChange(_ sender: UIButton) {
        switch playMode {
            
        case .repeatAll :
            playMode = .repeatOne
            
            playModeImageView?.setSymbolImage(UIImage(systemName: "repeat.1")!, contentTransition: .replace.downUp)
            
            print("repeat.1")
            
        case .repeatOne :
            playMode = .shuffle
            
            playModeImageView?.setSymbolImage(UIImage(systemName: "shuffle")!, contentTransition: .replace.downUp)
            
            print("shuffle")
        case .shuffle :
            playMode = .repeatAll
            
            playModeImageView?.setSymbolImage(UIImage(systemName: "repeat")!, contentTransition: .replace.downUp)
            
            print("repeat")
        default :
            print("default")
        }
    }
    
    
    
    
    
    
    
    @IBAction func volumeSliderChange(_ sender: UISlider) {
        myMusicPlayer.volume = sender.value
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Function Section -
    
    func playNewSong( from index : Int ) {
        artistLabel.text = songs[index].artist
        songNameLabel.text = songs[index].songName
        coverImageView.image = songs[index].coverImage
        
        let playerItem = AVPlayerItem(url: songs[index].fileUrl)
        myMusicPlayer.replaceCurrentItem(with: playerItem)
        
        // 抓取專輯圖片主要顏色
        let colors = coverImageView.image?.getColors()
        createGradientBackground(primaryColor: colors?.primary, secondaryColor: colors?.secondary)
        
        
        // 圓角 & 陰影
        let SCview = UIView()
        self.view.addSubview(SCview)
        SCview.addSubview(coverImageView)
        SCview.frame.size = coverImageView.frame.size
        SCview.layer.shadowOpacity = 0.5
        SCview.layer.shadowOffset = CGSize(width: 5, height: 5)
        SCview.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        
        
        // 使用 addPeriodicTimeObserver 方法追蹤音樂播放進度，每秒觸發一次時間觀察者。
        // 當 musicProgressSlider 沒有被滑動時執行 updateMusicProgress，避免更新滑塊導致抖動。
        myMusicPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main) { time in
            // 檢查音樂進度條是否正在被使用者拖動
            if !self.songProgressSliderOutlet.isTracking {
                // 若音樂進度條沒有被拖動，執行以下程式碼
                // print("音樂進度條沒有被拖動，進入 updateMusicProgress 方法")
                self.updateMusicProgress()
            }
            
        }
        
    }
    
    
    
    
    
    
    func configurationInformation( form index : Int) {
        artistLabel.text = songs[index].artist
        songNameLabel.text = songs[index].songName
        coverImageView.image = songs[index].coverImage
        
        let playItem = AVPlayerItem(url: songs[index].fileUrl)
        myMusicPlayer.replaceCurrentItem(with: playItem)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(songDidEnd), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
        
        songProgressSliderOutlet.isEnabled = false
        
        volumeSliderOutlet.minimumValue = 0
        volumeSliderOutlet.maximumValue = 1
        volumeSliderOutlet.value = 1
        
        
        // 圓角 & 陰影
        let SCview = UIView()
        self.view.addSubview(SCview)
        SCview.addSubview(coverImageView)
        SCview.frame.size = coverImageView.frame.size
        SCview.layer.shadowOpacity = 0.5
        SCview.layer.shadowOffset = CGSize(width: 5, height: 5)
        SCview.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        
        
        // 抓取專輯圖片主要顏色
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        let colors = coverImageView.image?.getColors()
        createGradientBackground(primaryColor: colors?.primary, secondaryColor: colors?.secondary)
        
        // 播放模式小圖示
        playModeImageView = UIImageView(image: UIImage(systemName: "repeat"))
        playModeImageView!.frame = CGRect(x: playModeButtonOutlet.bounds.width - 10, y: 0, width: 15, height: 15)
        playModeButtonOutlet.addSubview(playModeImageView!)
        
        
        // 使用 addPeriodicTimeObserver 方法追蹤音樂播放進度，每秒觸發一次時間觀察者。
        // 當 musicProgressSlider 沒有被滑動時執行 updateMusicProgress，避免更新滑塊導致抖動。
        myMusicPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main) { time in
            // 檢查音樂進度條是否正在被使用者拖動
            if !self.songProgressSliderOutlet.isTracking {
                // 若音樂進度條沒有被拖動，執行以下程式碼
                // print("音樂進度條沒有被拖動，進入 updateMusicProgress 方法")
                self.updateMusicProgress()
            }
        }
    }
    
    
    
    @objc func songDidEnd() {
        switch playMode {
            
        case .repeatAll :
            currentIndex += 1
            if currentIndex == songs.count {
                currentIndex = 0
            }
            playNewSong(from: currentIndex)
            myMusicPlayer.play()
            
        case .repeatOne :
            
            playNewSong(from: currentIndex)
            myMusicPlayer.play()
            
        case .shuffle :
            currentIndex = Int.random(in: 0...3)
            playNewSong(from: currentIndex)
            myMusicPlayer.play()
            
        default :
            return
        }
        
    }
    
    
    
    
    // 抓取專輯圖片主要顏色
    func createGradientBackground(primaryColor: UIColor?, secondaryColor: UIColor?) {
        guard let primaryColor = primaryColor, let secondaryColor = secondaryColor else {
            return
        }
        
        gradientLayer.colors = [primaryColor.cgColor, secondaryColor.cgColor]
    }
    
    
    
    
    func updateMusicProgress() {
        
        if let currentTime = myMusicPlayer.currentItem?.currentTime(), let duration = myMusicPlayer.currentItem?.duration {
            
            
            let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
            let durationInSeconds = CMTimeGetSeconds(duration)
            
            
            let progress = Float(currentTimeInSeconds / durationInSeconds)
            songProgressSliderOutlet.value = progress
            
            
            songDurationStartLabel.text = formatSecondsToString(seconds: currentTimeInSeconds)
            songDurationEndLabel.text = formatSecondsToString(seconds: durationInSeconds)
            
            //            songDurationStartLabel.text = String(format: "%02d:%02d", Int(currentTimeInSeconds) / 60, Int(currentTimeInSeconds) % 60)
            //            songDurationEndLabel.text = String(format: "%02d:%02d", Int(durationInSeconds) / 60, Int(durationInSeconds) % 60)
            
            
        } else {
            return
        }
    }
    
    
    
    /// 格式化秒數為時間字串（學習）
    /// - Parameter seconds: 需要被格式化的秒數，數值為Double
    /// - Returns: 回傳格式化後的時間字串，格式為 "分鐘：秒鐘"
    func formatSecondsToString(seconds: Double) -> String {
        
        // 如果傳入的秒數是 NaN（Not a Number） 則直接回傳 "00:00"
        if seconds.isNaN {
            return "00:00"
        }
        
        // 將傳入的秒數除以 60 得到分鐘數，並轉為整數
        let mins = Int(seconds / 60)
        
        // 使用 truncatingRemainder(dividingBy:) 函式獲得傳入的秒數除以 60 的餘數，這就是剩餘的秒數，然後轉為整數
        let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        // String(format:) 來生成格式化的時間字串。"%02d:%02d" 表示兩個兩位數的整數，如果不足兩位則前面補零
        let str = String(format: "%02d:%02d", mins, secs)
        
        // 回傳格式化後的時間字串
        return str
    }
    
    
    
    
    
    
    
}

