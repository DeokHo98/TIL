//
//  ViewController.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/01/26.
//

import UIKit
import AVKit


class TimerViewcontroller: UIViewController {
    private var player: AVAudioPlayer?
    private var soundBool: Bool = true
    private var timer = Time()
    @IBOutlet weak var minPickerView: UIPickerView!
    @IBOutlet weak var secPikerView: UIPickerView!
    @IBOutlet weak var restTimeSetting: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var setCountLabel: UILabel!
    @IBOutlet weak var workOutLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    
    private var time = Time()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundBool = UserDefaults.standard.bool(forKey: "Sound")
        soundImage()
        soundButton.tintColor = .black
        viewDidLoadDelegateAndDatesource()
        viewdidloadRestButton()
        viewdidloadStartButton()
        viewdidloadFinishButton()
        finishButtonSetText()
    }
    
    
    
    
    
    //MARK: - Timer Code
    @IBAction func workOutStartButtonClick(_ sender: UIButton) {
        if time.totalRestTime == 0 {
            startError()
        } else {
            if timer.timerCounting == false {
                restart()
            }
        }
    }
    
    
    @IBAction func resetButtonClick(_ sender: UIButton) {
        resetButtontimerSet()
        resetButtonFalse()
        startButtonSetfalse()
        textColorSetBlue()
        labelTextSetInResetButton()
        setTime(time: time.totalRestTime)
    }
    
    @IBAction func finishiButtonClick(_ sender: Any) {
        resetButtonFalse()
        resetButtonSetTitle()
        startButtonSetTitle()
        startButtonSetTrue()
        finishButtonSetTimer()
        finishButtonSetText()
        finishButtonSetTitle()
        textColorSetBlack()
        soundButton.isHidden = false
        isHiddenFalseAndTrue(check: false, pickerView: minPickerView, pickerView2: secPikerView, label: restTimeSetting)
    }
    
    private func isHiddenFalseAndTrue(check: Bool, pickerView: UIPickerView, pickerView2: UIPickerView, label: UILabel) {
        if check {
            pickerView.isHidden = true
            pickerView2.isHidden = true
            label.isHidden = true
        } else {
            pickerView.isHidden = false
            pickerView2.isHidden = false
            label.isHidden = false
        }
    }
}




//MARK: - viewDidLoad 메서드
extension TimerViewcontroller {
    //viewDidLoad에 들어갈 델리게이트 and 데이터소스
    private func viewDidLoadDelegateAndDatesource() {
        minPickerView.dataSource = self
        secPikerView.dataSource = self
        minPickerView.delegate = self
        secPikerView.delegate = self
    }
    
    private func viewdidloadRestButton() {
        resetButton.isEnabled = false
        resetButton.setTitle("Set Finish".localized(), for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.alpha = 0.2
    }
    
    private func viewdidloadStartButton() {
        startButton.setTitle("Set Start".localized(), for: .normal)
        startButton.setTitleColor(.black, for: .normal)
    }
    
    private func viewdidloadFinishButton() {
        finishButton.setTitle("Reset".localized(), for: .normal)
        finishButton.setTitleColor(.black, for: .normal)
    }
    
    
    
    
    
    
    //MARK: - 타이머 @objc 셀렉터 메서드
    @objc private func startUpdateTimer() {
        timer.timeCount += 1
        setTime(time: timer.timeCount)
    }
    
    @objc private func resetUpdateTimer2() {
        if time.totalRestTime > 1 {
            time.totalRestTime -= 1
            setTime(time: time.totalRestTime)
        } else {
            setTime(time: 0)
            startButtonSetTrue()
            timer.mainTimer?.invalidate()
            workOutLabel.text = "Rest Time Finish".localized()
            time.totalRestTime = time.duplicatedTotalRestTime
            textColorSetBlack()
            isHiddenFalseAndTrue(check: false, pickerView: minPickerView, pickerView2: secPikerView, label: restTimeSetting)
            playSound()
            soundButton.isHidden = false
            restart()
        }
    }
    
    private func setTime(time: Int) {
        let time = secondsToHoursMinutesSeconds(seconds: time)
        let timeString = makeTimerString(minuters: time.0, seconds: time.1)
        timerLabel.text = timeString
    }
    
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int,Int) {
        return ((seconds % 3600) / 60,(seconds % 3600) % 60)
    }
    
    private func makeTimerString(minuters: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d",minuters)
        timeString += ":"
        timeString += String(format: "%02d",seconds)
        return timeString
    }
    
    
    
    
    //MARK: - 텍스트컬러 메서드
    
    private func textColorSetBlue() {
        workOutLabel.textColor = .systemBlue
        setCountLabel.textColor = .systemBlue
        timerLabel.textColor = .systemBlue
    }
    
    private func textColorSetBlack() {
        workOutLabel.textColor = .black
        setCountLabel.textColor = .black
        timerLabel.textColor = .black
    }
    
    
    
    
    //MARK: - startButton 메서드
    private func startTimeset() {
        timer.timerCounting = true
        timer.mainTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(startUpdateTimer), userInfo:nil, repeats: true)
    }
    
    
    private func startButtonSetfalse() {
        startButton.alpha = 0.2
        startButton.isEnabled = false
    }
    
    private func startButtonSetTrue() {
        startButton.alpha = 1
        startButton.isEnabled = true
    }
    
    private func startButtonSetTitle() {
        startButton.setTitle("Set Start".localized(), for: .normal)
        startButton.setTitleColor(.black, for: .normal)
    }
    
    private func restart() {
        startButtonSetfalse()
        resetButtonTrue()
        workoutLabelSetInStartButton()
        isHiddenFalseAndTrue(check: true, pickerView: minPickerView, pickerView2: secPikerView, label: restTimeSetting)
        startTimeset()
        soundButton.isHidden = true
    }
    
    
    private func startError() {
        let alert = UIAlertController(title: "warning".localized(), message: "Please set a rest time".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "check".localized(), style: .default, handler: nil)
        alert.addAction(yesAction)
              present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - resetButton 메서드
    
    
    
    private func resetButtontimerSet() {
        time.setCount += 1
        timer.timeCount = 0
        timer.timerCounting = false
        timer.mainTimer?.invalidate()
        timer.mainTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(resetUpdateTimer2), userInfo:nil, repeats: true)
    }
    
    private func resetButtonFalse() {
        resetButton.isEnabled = false
        resetButton.alpha = 0.2
    }
    
    private func resetButtonTrue() {
        resetButton.isEnabled = true
        resetButton.alpha = 1
    }
    
    private func resetButtonSetTitle() {
        resetButton.setTitle("Set Finish".localized(), for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
    }
    
    
    
    
    //MARK: - text관련 메서드
    
    
    private func labelTextSetInResetButton() {
        timerLabel.text = makeTimerString(minuters: 0, seconds: 0)
        setCountLabel.text = "\(time.setCount)"+" Set complete".localized()
        workOutLabel.text = "Rest Time".localized()
    }
    
    
    
    private func workoutLabelSetInStartButton() {
        workOutLabel.text = ""
        workOutLabel.text = "PlayTime".localized()
    }
    
    
    
    //MARK: - 초기화 버튼 관련 메서드
    
    private func finishButtonSetTitle() {
        finishButton.setTitle("Reset".localized(), for: .normal)
        finishButton.setTitleColor(.black, for: .normal)
    }
    
    private func finishButtonSetTimer() {
        timer.timeCount = 0
        timer.mainTimer?.invalidate()
        timer.timerCounting = false
        time.setCount = 0
        time.totalRestTime = time.duplicatedTotalRestTime
    }
    
    private func finishButtonSetText() {
        workOutLabel.text = ""
        setCountLabel.text = "0" + " Set complete".localized()
        timerLabel.text = "00:00"
    }
    
}








//MARK: - UIPicker view code
extension TimerViewcontroller: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == minPickerView {
            return time.restTimeArrayMin.count
        } else {
            return time.restTimeArraySec.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == minPickerView {
            time.restTimeMin = row * 60
            insertTime()
        } else {
            time.restTimeSec = row
            insertTime()
        }
    }
    
    private func insertTime() {
        time.totalRestTime = time.restTimeMin + time.restTimeSec
        time.duplicatedTotalRestTime = time.restTimeMin + time.restTimeSec
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == minPickerView {
            return pickerViewSetText(array: time.restTimeArrayMin[row])
        } else {
            return pickerViewSetText(array: time.restTimeArraySec[row])
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let height: CGFloat = 40
        return height
    }
    
    private func pickerViewSetText(array: String) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.font = label.font.withSize(40)
        label.text =  array
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
    
}

//MARK: - pickerView 고정 레이블


//MARK: - 소리관련 코드
extension TimerViewcontroller {
    @IBAction func playSoundButton(_ sender: Any) {
        if soundButton.currentImage == UIImage(systemName: "bell") {
            soundAlert(text: "Do you want to turn off the rest time finish sound?".localized()) { [self] in
                UserDefaults.standard.set(false, forKey: "Sound")
                soundBool = UserDefaults.standard.bool(forKey: "Sound")
                soundButton.setImage(UIImage(systemName: "bell.slash"), for: .normal) }
            } else {
                soundAlert(text: "Do you want to turn on the rest time finish sound?".localized()) { [self] in
                    UserDefaults.standard.set(true, forKey: "Sound")
                    soundBool = UserDefaults.standard.bool(forKey: "Sound")
                    soundButton.setImage(UIImage(systemName: "bell"), for: .normal)}
            }
        }
    

    
    private func playSound() {
        let url = Bundle.main.url(forResource: "sound", withExtension: "mp3")!
        if soundBool {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print(error)
            }
        } else {
            return
        }
    }
    
    
    
    private func soundAlert(text: String, closuer: @escaping () -> Void ) {
        let alert = UIAlertController(title: "notice".localized(), message: text, preferredStyle: .alert)
        let yes = UIAlertAction(title: "yes".localized(), style: .default) { _ in
            closuer()
        }
        let no = UIAlertAction(title: "no".localized(), style: .default, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func soundImage() {
        if soundBool {
            soundButton.setImage(UIImage(systemName: "bell"), for: .normal)
    } else {
        soundButton.setImage(UIImage(systemName: "bell.slash"), for: .normal)
    }
    
    }
    
}


//MARK: - 스토리보드에 UI 오브젝트 둥글게하는 기능 넣기
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}


//MARK: - 다국어지원
extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}



