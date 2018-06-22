//
//  ViewController.swift
//  HSCMAudioRecorder
//
//  Created by CM on 2018/6/22.
//  Copyright © 2018年 CM. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var path = ""
    var pathMP3 = ""
    
    var filePath: URL!
    var filePathMP3: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { (granted) in
            if granted {
                // 用户同意获取麦克风，一定要在主线程中执行UI操作！！！
                print("用户同意获取麦克风")
                
                self.initAudioSession()
                
            } else {
                print("用户不同意获取麦克风")
                
            }
        }
    }
    
    
    
    func initAudioSession() {
        
//        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
//            AVFormatIDKey : NSNumber(value: kAudioFormatMPEG4AAC),//编码格式
//            AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
//            AVEncoderAudioQualityKey : NSNumber(value: AVAudioQuality.medium.rawValue)]
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
//            /// 初始化实例
//            try audioRecorder = AVAudioRecorder(url: self.directoryURL(), settings: recordSettings)
//            ///     准备录音
//            audioRecorder.prepareToRecord()
//
//        } catch {
//
//        }
        
        
        
        
    }
    
    func directoryURL() -> URL {
        //  根据时间设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docDir = urls[0]
        
        //  将音频文件名称追加在可用路径上形成音频文件的保存路径
        let soundURL = docDir.appendingPathComponent(recordingName)
        print("soundURL =========== \(soundURL)")
    
    
        return soundURL
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// 开始录音
    @IBAction func buttonBeginRecord(_ sender: UIButton) {
        print("开始录音")
        
//        if !audioRecorder.isRecording {
//            let audioSession = AVAudioSession.sharedInstance()
//            do {
//                try audioSession.setActive(true)
//                audioRecorder.record()
//                print("Record!!")
//            } catch {
//
//            }
//        }
        
        let session = AVAudioSession.sharedInstance()
        //  设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch let err {
            print("设置类型失败:\(err.localizedDescription)")
        }
        
        //  设置session动作
        do {
            try session.setActive(true)
            
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 44100.0),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ]
        
        //开始录音
        //  根据时间设置存储文件名
//        let currentDateTime = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"
//        let recordingName = formatter.string(from: currentDateTime)+".wav"
//
//        let fileManager = FileManager.default
//        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        let docDir = urls[0]
//
//        //  将音频文件名称追加在可用路径上形成音频文件的保存路径
//        let soundURL = docDir.appendingPathComponent(recordingName)
//
//        do {
//            let url = soundURL
//            audioRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
//            audioRecorder!.prepareToRecord()
//            audioRecorder!.record()
//        } catch let err {
//            print("录音失败:\(err.localizedDescription)")
//        }
        
        path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathArray = [path,recordingName]
        filePath = URL(string: pathArray.joined(separator: "/"))!
        
        let recordingNameMp3 = "voice.mp3"
        let pathArrayMp3 = [path,recordingNameMp3]
        filePathMP3 = URL(string: pathArrayMp3.joined(separator: "/"))!
        
        
        do {
            let url = filePath
            audioRecorder = try AVAudioRecorder(url: url!, settings: recordSetting)
            audioRecorder.isMeteringEnabled = true
            audioRecorder!.prepareToRecord()
            audioRecorder!.record()
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }

    
    }
    
    @IBAction func buttonStopRecord(_ sender: UIButton) {
        print("停止录音")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {

        }

//        let audioData = try! Data(contentsOf: audioRecorder.url)
//        print("audioData ==== \(audioData)")
//        print("audioRecorder.url ==== \(audioRecorder.url)")


//        let session = AVAudioSession.sharedInstance()
//        //设置session类型
//        do {
//            try session.setCategory(AVAudioSessionCategoryPlayback)
//        } catch let err{
//            print("设置类型失败:\(err.localizedDescription)")
//        }
//
//
        DispatchQueue.global().async {
             
            AudioWrapper.audioPCMtoMP3(self.filePath, self.filePathMP3)
            
        }
        
    }
    
    @IBAction func buttonStartPlay(_ sender: UIButton) {
        print("播放录音")
        if !audioRecorder.isRecording {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: filePath)
                audioPlayer.play()
                print("Play!!")
            } catch {
                
            }
        }
        
    }
    
    @IBAction func buttonStopPlay(_ sender: UIButton) {
        print("暂停播放")
        if !audioRecorder.isRecording {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: filePath)
                audioPlayer.pause()
                print("Pause!!")
            }  catch {
                
            }
        }
        
    }
    
    
}





