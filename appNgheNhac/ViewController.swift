//
//  ViewController.swift
//  appNgheNhac
//
//  Created by Dr on 1/16/17.
//  Copyright © 2017 Dr. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var lblNameBH: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblLoiBH: UITextView!
    
    @IBOutlet weak var sldVolume: UISlider!
    
    @IBAction func asldVolume(_ sender: Any) {
        
        player.volume = sldVolume.value
        btnVolumeImage()
        
    }
    
    
    func btnVolumeImage() {
        if player.volume == 0 {
            btnVolume.setBackgroundImage(#imageLiteral(resourceName: "Mute-100"), for: .normal)
        } else if player.volume > 0 && player.volume <= 0.4 {
            btnVolume.setBackgroundImage(#imageLiteral(resourceName: "Low Volume-100"), for: .normal)
        } else if player.volume > 0.4 && player.volume <= 0.8 {
            btnVolume.setBackgroundImage(#imageLiteral(resourceName: "Medium Volume-100"), for: .normal)
        } else {
            btnVolume.setBackgroundImage(#imageLiteral(resourceName: "High Volume-100"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnVolume: UIButton!
    
    @IBAction func abtnVolume(_ sender: Any) {
        
        sldVolume.isHidden = !sldVolume.isHidden
        
    }
    
    
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblDurationTIme: UILabel!
    
    @IBOutlet weak var sldTime: UISlider!
    
    @IBAction func asldTime(_ sender: Any) {
        player.currentTime = TimeInterval(sldTime.value)
    }
    
    var arrRD:Array<Int> = []
    
    func randomArray() -> Int {
        let rd = Int(arc4random_uniform(UInt32(arrNameMusic.count)))
        
        if arrRD.count == arrNameMusic.count
        {
            arrRD.removeAll()
        }
        
        if arrRD.contains(rd) == true
        {
            return randomArray()
        } else {
            arrRD.append(rd)
            return rd
            
        }
        
    }
    var FlagRandom:Bool = false
    @IBOutlet weak var btnRandom: UIButton!
    @IBAction func abtnRandom(_ sender: Any) {
        print(arrRD)
        print(randomArray())
        FlagRandom = !FlagRandom
        if FlagRandom == true {
            btnRandom.setImage(#imageLiteral(resourceName: "shuffle-on"), for: .normal)
        } else {
            btnRandom.setImage(#imageLiteral(resourceName: "shuffle-off"), for: .normal)
        }
        
    }
    
    @IBAction func abtnBack(_ sender: Any) {
        index -= 1
        
        if index == -1  {
            index = arrNameMusic.count - 1
        }
        
        
        PlayMusic(name: arrNameMusic[index])
        player.play()
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Pause-96"), for: .normal)
        flagPlay = false
        
    }
    
    @IBOutlet weak var btnPlay: UIButton!
    var flagPlay:Bool = false
    
    @IBAction func abtnPlay(_ sender: Any) {
        flagPlay = !flagPlay
        if flagPlay == true {
            player.play()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Pause-96"), for: .normal)
            
        } else {
            player.pause()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Play-96"), for: .normal)
        }
    }
    
    @IBAction func abtnNext(_ sender: Any) {
        index += 1
        
        if index == arrNameMusic.count {
            index = 0
        }
        
        PlayMusic(name: arrNameMusic[index])
        setupTime()
        player.play()
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Pause-96"), for: .normal)
        flagPlay = false
    }
    
    @IBOutlet weak var btnRepeat: UIButton!
    
    var FlagRepeat:Bool = false
    @IBAction func abtnRepeat(_ sender: Any) {
        FlagRepeat = !FlagRepeat
        if FlagRepeat == true {
            btnRepeat.setImage(#imageLiteral(resourceName: "Repeat-96"), for: .normal)
            
        } else {
            btnRepeat.setImage(#imageLiteral(resourceName: "Repeat-104"), for: .normal)
        }
        
    }
    
    
    let arrNameMusic:Array<String> = ["Chợt Như Giấc Mơ.mp3" , "Ngày Mai.mp3", "Sugar.mp3", "Trở Về Đi.m4a"]
    var index:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayMusic(name: arrNameMusic[index])
        setupTime()
        
        sldTime.minimumValue = 0
        sldTime.maximumValue = Float(player.duration)
        sldTime.value = 0
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        boTronImgView_Va_RotateSliderVolume()
        
    }
    
    func setupTime(){
        
        lblCurrentTime.text = "0:00"
        
        lblDurationTIme.text = player.duration.convertTimeToString()
        
        if timer.isValid == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.UpdateTime), userInfo: nil, repeats: true)
            print("2--------------123123asdasd")
        }
        
    }
    
    
    var  player:AVAudioPlayer = AVAudioPlayer()
    var timer:Timer = Timer()
    
    func UpdateTime() {
        if player.currentTime.convertTimeToString() != lblCurrentTime.text! {
            sldTime.value = Float(player.currentTime)
            
            lblCurrentTime.text = player.currentTime.convertTimeToString()
            
            lblDurationTIme.text = (player.duration - player.currentTime).convertTimeToString()
            
            let transformRotate = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0, 0, 1)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.imgView.layer.transform = transformRotate
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.imgView.layer.transform = CATransform3DIdentity
                })
            })
        }
        if player.currentTime == 0 && FlagRepeat == true && flagPlay == true && FlagRandom == false
        {
            player.play()
            
        }
        if player.currentTime == 0 && FlagRepeat == true && flagPlay == true && FlagRandom == true
        {
            PlayMusic(name: arrNameMusic[randomArray()])
            player.play()
        }
        
        if player.currentTime == 0 && FlagRepeat == false && flagPlay == true
        {
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Play-96"), for: .normal)
            flagPlay = false
            
        }
        
        if player.currentTime == 0 && FlagRandom == false && flagPlay == true
        {
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "Play-96"), for: .normal)
            flagPlay = false
            
        }
        
    }
    
    func PlayMusic(name:String) {
        
        
        /// Tạo Array ... cắt lấy Phần Tử NgayMai.mp3 > ["NgayMai","mp3"]
        let arrName:Array<String> = name.components(separatedBy: ".")
        
        lblNameBH.text = arrName[0]
        /// ["NgayMai","mp3"] = ArrName[0] & ArrName[1]
        let path:String = Bundle.main.path(forResource: arrName[0], ofType: arrName[1])!
        
        let url:URL = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            sldTime.minimumValue = 0
            sldTime.maximumValue = Float(player.duration)
            sldTime.value = 0
            
            
        } catch {}
        
    }
    
    
    func boTronImgView_Va_RotateSliderVolume() {
        
        /// Bo Tròn ImageView
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.clipsToBounds = true
        
        /// **Rotate** Dựng Đứng Slider Volume
        let transformRotate = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI+M_PI/2), 0, 0, 1)
        /// **Translate** Vị Trí Mới Của Slider
        let transformDich = CATransform3DTranslate(CATransform3DIdentity, 0, -sldVolume.frame.size.width/2 + 20, 0)
        /// **Concact** Kết Hợp Biến Đổi 2 = 1
        let transformConcact = CATransform3DConcat(transformRotate, transformDich)
        sldVolume.layer.transform = transformConcact
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TimeInterval {
    func convertTimeToString() -> String {
        
        let m:Int = Int(self) / 60
        let s:Int = Int(self) - m*60
        
        if m < 10 && s < 10 {
            return "0\(m):0\(s)"
        } else if m >= 10 && s < 10 {
            return "\(m):0\(s)"
        } else if m < 10 && s >= 10 {
            return "0\(m):\(s)"
        }
        return "\(m):\(s)"
    }
}

