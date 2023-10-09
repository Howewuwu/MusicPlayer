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
    
    
    
    // 定義一個按鈕動作，當按下播放或暫停按鈕時會被觸發
    @IBAction func playOrPauseSong(_ sender: UIButton) {
        // 判斷音樂播放器的播放狀態
        switch myMusicPlayer.timeControlStatus {
            
        case .paused:  // 當音樂暫停時
            myMusicPlayer.play()  // 播放音樂
            
            songProgressSliderOutlet.isEnabled = true  // 啟用進度滑塊
            
            let pauseImage = UIImage(systemName: "pause.fill")!  // 定義暫停圖標
            playOrPauseImageView.setSymbolImage(pauseImage, contentTransition: .replace.downUp, options: .speed(2))  // 更新播放按鈕的圖標
            
            // 進行動畫效果，使封面圖像放大
            UIView.animate(withDuration: 0.3) {
                self.coverImageView.transform = CGAffineTransform(scaleX: 2.3, y: 2.3)
            }
            
        case .waitingToPlayAtSpecifiedRate:  // 當音樂等待播放時（例如，緩衝）
            print("waitingToPlayAtSpecifiedRate")  // 輸出狀態到控制台
            
        case .playing:  // 當音樂正在播放時
            myMusicPlayer.pause()  // 暫停音樂
            
            let playImage = UIImage(systemName: "play.fill")!  // 定義播放圖標
            playOrPauseImageView.setSymbolImage(playImage, contentTransition: .replace.downUp, options: .speed(2))  // 更新播放按鈕的圖標
            
            // 進行動畫效果，使封面圖像恢復原始大小
            UIView.animate(withDuration: 0.3) {
                self.coverImageView.transform = CGAffineTransform.identity
            }
            
        default:
            break  // 其他未知狀態，不做任何操作
        }
    }
    
    
    
    // 定義一個滑塊動作，當進度滑塊值改變時會被觸發
    @IBAction func songProgressSliderChange(_ sender: UISlider) {
        // 獲得滑塊的位置（值範圍是0到1）
        let sliderValue = sender.value
        
        // 獲得音樂的總時間（單位秒）
        let duration = CMTimeGetSeconds(myMusicPlayer.currentItem!.duration)
        
        // 計算新的播放時間（單位秒）
        let newTime = Double(sliderValue) * duration
        
        // 將新的播放時間設定到播放器
        let seekTime = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
        myMusicPlayer.seek(to: seekTime)
        
        // 格式化新的播放時間和總時間，顯示到界面上
        songDurationStartLabel.text = String(format: "%02d:%02d", Int(newTime) / 60, Int(newTime) % 60)
        songDurationEndLabel.text = String(format: "%02d:%02d", Int(duration) / 60, Int(duration) % 60)
    }
    
    
    
    // 定義一個按鈕動作，當按下下一首歌按鈕時會被觸發
    @IBAction func nextSong(_ sender: UIButton) {
        // 添加符號效果，使圖標有彈跳效果
        forwardImageView.addSymbolEffect(.bounce.up)
        forwardImageView.addSymbolEffect(.bounce.down)
        
        // 判斷播放模式是否為隨機播放
        if playMode == .shuffle {
            // 如果是隨機播放，隨機選擇一首歌的索引
            currentIndex = Int.random(in: 0...3)
            playNewSong(from: currentIndex)  // 播放新的歌曲
            
        } else {
            // 如果不是隨機播放，則播放下一首歌
            currentIndex += 1  // 索引加1
            if currentIndex == songs.count {  // 如果索引等於歌曲列表的數量，表示已經到最後一首，從頭開始
                currentIndex = 0
            }
            playNewSong(from: currentIndex)  // 播放新的歌曲
        }
    }
    
    
    
    // 定義一個按鈕動作，當按下上一首歌按鈕時會被觸發
    @IBAction func previousSong(_ sender: UIButton) {
        // 添加符號效果，使圖標有彈跳效果
        backwardImageView.addSymbolEffect(.bounce.up)
        backwardImageView.addSymbolEffect(.bounce.down)
        
        // 判斷播放模式是否為隨機播放
        if playMode == .shuffle {
            // 如果是隨機播放，隨機選擇一首歌的索引
            currentIndex = Int.random(in: 0...3)
            playNewSong(from: currentIndex)  // 播放新的歌曲
            
        } else {
            // 如果不是隨機播放，則播放上一首歌
            currentIndex -= 1  // 索引減1
            if currentIndex < 0  {  // 如果索引小於0，表示已經到第一首，從最後一首開始
                currentIndex = songs.count - 1
            }
            playNewSong(from: currentIndex)  // 播放新的歌曲
        }
    }
    
    
    
    // 定義一個按鈕動作，當按下播放模式按鈕時會被觸發
    @IBAction func playModeChange(_ sender: UIButton) {
        // 根據當前的播放模式來切換到不同的播放模式
        switch playMode {
            /// case 的狀態是為了讓 playMode 能夠在點擊時能夠一直轉換，所以跟它執行的模式不同，主要還是以裡面的內容為主。
        case .repeatAll :  // 如果當前是全部重複
            playMode = .repeatOne  // 切換到單曲重複
            // 更新播放模式圖標
            playModeImageView?.setSymbolImage(UIImage(systemName: "repeat.1")!, contentTransition: .replace.downUp)
            print("repeat.1")  // 輸出模式到控制台
            
        case .repeatOne :  // 如果當前是單曲重複
            playMode = .shuffle  // 切換到隨機播放
            // 更新播放模式圖標
            playModeImageView?.setSymbolImage(UIImage(systemName: "shuffle")!, contentTransition: .replace.downUp)
            print("shuffle")  // 輸出模式到控制台
            
        case .shuffle :  // 如果當前是隨機播放
            playMode = .repeatAll  // 切換到全部重複
            // 更新播放模式圖標
            playModeImageView?.setSymbolImage(UIImage(systemName: "repeat")!, contentTransition: .replace.downUp)
            print("repeat")  // 輸出模式到控制台
            
        default :
            print("default")  // 其他未知狀態，輸出到控制台
        }
    }
    
    
    
    @IBAction func volumeSliderChange(_ sender: UISlider) {
        myMusicPlayer.volume = sender.value
    }
    
    
    
    // MARK: Function Section -
    
    
    
    // 定義一個名為 playNewSong 的函數，接收一個名為 index 的參數，這個參數是用來指定要播放哪首歌曲
    func playNewSong(from index: Int) {
        // 使用傳入的索引來從歌曲數組中獲取相應的歌曲信息，並將其設置到界面的標籤和圖片視圖中
        artistLabel.text = songs[index].artist
        songNameLabel.text = songs[index].songName
        coverImageView.image = songs[index].coverImage
        
        // 使用歌曲的文件URL創建一個新的AVPlayerItem對象
        let playerItem = AVPlayerItem(url: songs[index].fileUrl)
        // 將當前播放項目替換為新創建的AVPlayerItem對象，以便開始播放新歌曲
        myMusicPlayer.replaceCurrentItem(with: playerItem)
        
        // 使用封面圖片的顏色信息來創建一個漸變背景
        // 首先，使用封面圖片視圖的 image 屬性來獲取封面圖片的顏色信息
        let colors = coverImageView.image?.getColors()
        // 然後，使用 createGradientBackground 函數來創建一個漸變背景
        createGradientBackground(primaryColor: colors?.primary, secondaryColor: colors?.secondary)
        
        // 創建一個名為 SCview 的新UIView對象，用於為封面圖片視圖添加圓角和陰影效果
        let SCview = UIView()
        // 將 SCview 對象添加到視圖層次結構中
        self.view.addSubview(SCview)
        // 將封面圖片視圖添加到 SCview 對象中
        SCview.addSubview(coverImageView)
        // 設置 SCview 對象的大小與封面圖片視圖的大小相同
        SCview.frame.size = coverImageView.frame.size
        // 設置 SCview 對象的陰影透明度、陰影偏移量和圓角半徑
        SCview.layer.shadowOpacity = 0.5
        SCview.layer.shadowOffset = CGSize(width: 5, height: 5)
        SCview.layer.cornerRadius = 10
        // 啟用封面圖片視圖的剪裁，並設置其圓角半徑
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        
        // 使用 addPeriodicTimeObserverForInterval 函數為音樂播放器添加一個周期性時間觀察者
        // 該觀察者每秒觸發一次，用於更新音樂進度條的值
        myMusicPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main) { time in
            // 檢查音樂進度滑塊是否正在被使用者拖動
            if !self.songProgressSliderOutlet.isTracking {
                // 若音樂進度滑塊沒有被拖動，則調用 updateMusicProgress 函數來更新音樂進度條的值
                self.updateMusicProgress()
            }
        }
    }
    
    
    
    // 定義一個函數來配置音樂播放器的基本信息
    func configurationInformation(form index: Int) {
        // 根據索引來設定藝術家標籤、歌名標籤和封面圖片
        artistLabel.text = songs[index].artist
        songNameLabel.text = songs[index].songName
        coverImageView.image = songs[index].coverImage
        
        // 通過索引從歌曲列表中獲取歌曲的文件URL，然後創建一個AVPlayerItem
        let playItem = AVPlayerItem(url: songs[index].fileUrl)
        // 將當前播放項目替換為新創建的AVPlayerItem
        myMusicPlayer.replaceCurrentItem(with: playItem)
        
        // 添加一個通知觀察者，用於監聽音樂播放結束的通知
        NotificationCenter.default.addObserver(self, selector: #selector(songDidEnd), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
        
        // 將歌曲進度滑塊設定為不可用（初始化時）
        songProgressSliderOutlet.isEnabled = false
        
        // 設定音量滑塊的最小值、最大值和初始值
        volumeSliderOutlet.minimumValue = 0
        volumeSliderOutlet.maximumValue = 1
        volumeSliderOutlet.value = 1
        
        // 創建一個UIView，將封面圖片視圖添加到此視圖中，並設定圓角和陰影
        let SCview = UIView()
        self.view.addSubview(SCview)
        SCview.addSubview(coverImageView)
        SCview.frame.size = coverImageView.frame.size
        SCview.layer.shadowOpacity = 0.5
        SCview.layer.shadowOffset = CGSize(width: 5, height: 5)
        SCview.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        
        // 創建一個CAGradientLayer來顯示漸變背景
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // 從封面圖片中提取顏色並設定漸變背景的顏色
        let colors = coverImageView.image?.getColors()
        createGradientBackground(primaryColor: colors?.primary, secondaryColor: colors?.secondary)
        
        // 創建播放模式的圖片視圖並設定初始圖片
        playModeImageView = UIImageView(image: UIImage(systemName: "repeat"))
        playModeImageView!.frame = CGRect(x: playModeButtonOutlet.bounds.width - 10, y: 0, width: 15, height: 15)
        playModeButtonOutlet.addSubview(playModeImageView!)
        
        // 使用addPeriodicTimeObserver方法定期更新音樂進度
        // 每秒觸發一次時間觀察者，如果音樂進度滑塊沒有被拖動，則更新音樂進度
        myMusicPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: .main) { time in
            // 檢查音樂進度滑塊是否正在被使用者拖動
            if !self.songProgressSliderOutlet.isTracking {
                // 若音樂進度滑塊沒有被拖動，執行以下程式碼以更新音樂進度
                self.updateMusicProgress()
            }
        }
    }
    
    
    
    // 定義一個名為 songDidEnd 的方法，這個方法會在歌曲播放結束時被呼叫
    @objc func songDidEnd() {
        // 透過 switch 陳述式檢查當前的播放模式
        switch playMode {
            // 如果是重複播放所有歌曲
        case .repeatAll :
            // 將當前的歌曲索引加 1 以移動到下一首歌曲
            currentIndex += 1
            // 檢查是否已經播放到最後一首歌曲，如果是，則將索引重置為 0 以從頭開始
            if currentIndex == songs.count {
                currentIndex = 0
            }
            // 調用 playNewSong 函數播放新歌曲
            playNewSong(from: currentIndex)
            // 調用 myMusicPlayer 的 play 方法以開始播放
            myMusicPlayer.play()
            
            // 如果是單曲循環
        case .repeatOne :
            // 重播當前歌曲
            playNewSong(from: currentIndex)
            // 開始播放
            myMusicPlayer.play()
            
            // 如果是隨機播放模式
        case .shuffle :
            // 生成一個隨機索引以播放隨機歌曲
            // 這裡假設歌曲列表中至少有 4 首歌曲，索引範圍是 0 到 3
            currentIndex = Int.random(in: 0...3)
            // 播放隨機選擇的新歌曲
            playNewSong(from: currentIndex)
            // 開始播放
            myMusicPlayer.play()
            
            // 默認情況下不做任何事情
        default :
            return
        }
    }
    
    
    
    // 定義一個名為 createGradientBackground 的方法，用於根據專輯的主要顏色和次要顏色創建漸變背景
    func createGradientBackground(primaryColor: UIColor?, secondaryColor: UIColor?) {
        // 使用 guard 陳述式檢查 primaryColor 和 secondaryColor 是否為 nil，如果是，則提前返回並結束方法
        guard let primaryColor = primaryColor, let secondaryColor = secondaryColor else {
            return
        }
        
        // 將 primaryColor 和 secondaryColor 的 CGColor 陣列設定為 gradientLayer 的 colors 屬性，以創建漸變效果
        gradientLayer.colors = [primaryColor.cgColor, secondaryColor.cgColor]
    }
    
    
    
    // 定義一個名為 updateMusicProgress 的方法，用於更新音樂播放進度
    func updateMusicProgress() {
        // 檢查當前播放項目的 currentTime 和 duration 是否存在，如果存在則繼續，否則提前返回
        if let currentTime = myMusicPlayer.currentItem?.currentTime(), let duration = myMusicPlayer.currentItem?.duration {
            // 轉換 currentTime 和 duration 為秒
            let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
            let durationInSeconds = CMTimeGetSeconds(duration)
            
            // 計算播放進度，並更新 songProgressSliderOutlet 的值
            let progress = Float(currentTimeInSeconds / durationInSeconds)
            songProgressSliderOutlet.value = progress
            
            // 使用自定義的 formatSecondsToString 函數將秒數格式化為字符串，並更新 songDurationStartLabel 和 songDurationEndLabel 的文本
            songDurationStartLabel.text = formatSecondsToString(seconds: currentTimeInSeconds)
            songDurationEndLabel.text = formatSecondsToString(seconds: durationInSeconds)
            
            // 下面的兩行是另一種將秒數格式化為 MM:SS 格式的方法，但已被註釋掉
            // songDurationStartLabel.text = String(format: "%02d:%02d", Int(currentTimeInSeconds) / 60, Int(currentTimeInSeconds) % 60)
            // songDurationEndLabel.text = String(format: "%02d:%02d", Int(durationInSeconds) / 60, Int(durationInSeconds) % 60)
        } else {
            // 如果無法獲取當前時間或持續時間，則提前返回
            return
        }
    }
    
    
    
    /// 將秒數格式化為 "分鐘：秒鐘" 格式的時間字串的函數。
    /// - Parameter seconds: 需要被格式化的秒數，數值為 Double。
    /// - Returns: 回傳格式化後的時間字串，格式為 "分鐘：秒鐘"。
    func formatSecondsToString(seconds: Double) -> String {
        
        // 檢查傳入的秒數是否是 NaN（Not a Number），如果是則直接回傳 "00:00"
        if seconds.isNaN {
            return "00:00"
        }
        
        // 將傳入的秒數除以 60 得到分鐘數，並將結果轉換為整數
        let mins = Int(seconds / 60)
        
        // 使用 truncatingRemainder(dividingBy:) 函式獲得傳入的秒數除以 60 的餘數，這就是剩餘的秒數，然後轉換為整數
        let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        // 使用 String(format:) 函數來生成格式化的時間字串。"%02d:%02d" 表示兩個兩位數的整數，如果不足兩位則前面補零
        let str = String(format: "%02d:%02d", mins, secs)
        
        // 回傳格式化後的時間字串
        return str
    }
    
    
    
}

