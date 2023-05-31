//
//  PodcastPlayViewController.swift
//  TED_Clone
//
//  Created by 정덕호 on 2022/03/03.
//

import UIKit
import AVKit

class PodcastPlayViewController: UIViewController {
//    var timer: Timer!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerItemContext = 0
    var playBool = true
    
    //이건 이미지의 서브스크립트 값을 알아 내기위한것.
    static var selectedNum = 0
    
    //이건 테이블뷰의 indexpath값을 저장한것
    static var mp3SelectedNum = 0
    
    
    //MARK: - Properties
    
    private let detailImage: UIImageView = {
        let image = UIImageView()
        image.image = PodcastViewModel.imageList[selectedNum].image
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = PodcastViewModel.mp3NameList[mp3SelectedNum]
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let sliderBar: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.minimumValue = 0
        let image = UIImage(systemName: "circlebadge.fill")
        let imageColor = image?.imageWithColor(color: UIColor.red)
        slider.setThumbImage(imageColor, for: .normal)
        guard let value = Float(PodcastViewModel.mp3RunTimeList[mp3SelectedNum]) else {return slider}
        slider.maximumValue = value
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        return slider
    }()
    
    private let TimeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "0:00")
        label.textColor = .white
        return label
    }()
    
    private let andTimeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = PodcastViewModel.timeFetch(num: PodcastViewModel.mp3RunTimeList[mp3SelectedNum], string: nil, size: 17)
        label.textColor = .white
        return label
    }()
    
    
    private let detailText: UITextView = {
       let textview = UITextView()
        textview.text = PodcastViewModel.mp3DetailText[mp3SelectedNum]
        textview.textColor = .white
        textview.backgroundColor = .clear
        textview.font = UIFont.systemFont(ofSize: 17)
        textview.isEditable = false
        textview.isSelectable = false
        return textview
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [TimeLabel,sliderBar,andTimeLabel])
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.axis = .horizontal
       return stack
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.forward.circle"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        button.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        return button
    }()
    
    private let goBackwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 32), forImageIn: .normal)
        button.addTarget(self, action: #selector(backwardButtonClick), for: .touchUpInside)
        return button
    }()
    
    private let goForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 32), forImageIn: .normal)
        button.addTarget(self, action: #selector(gowardButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goBackwardButton,timeButton,goForwardButton])
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.axis = .horizontal
        return stack
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.color = .white
        ai.startAnimating()
        ai.backgroundColor = .backgroundColor
        return ai
    }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.topItem?.title = ""
        makeLayout()
        playMP3()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &playerItemContext)
        player.pause()
    }
    
    
    

    
    //MARK: - 도움 메서드
    
   private func makeLayout() {
        view.addSubview(detailImage)
        detailImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leadingAnchor,paddingTop: 30,paddingLeft: 10,width: 150,height: 150)
        
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: detailImage.bottomAnchor,left: view.leadingAnchor,right:view.trailingAnchor,paddingTop: 20,paddingLeft: 10,paddingRight: 10)
        
        view.addSubview(detailText)
        detailText.anchor(top:nameLabel.bottomAnchor,left: view.leadingAnchor,right: view.trailingAnchor,paddingTop: 10,paddingLeft: 6,paddingRight: 10)
        
        sliderBar.anchor(width:view.frame.width - 150)
        view.addSubview(timeStack)
        timeStack.anchor(top: detailText.bottomAnchor,left: view.leadingAnchor,right: view.trailingAnchor,paddingTop: 60,paddingLeft: 10,paddingRight: 10)
    
        view.addSubview(buttonStack)
        buttonStack.anchor(top: timeStack.bottomAnchor,bottom: view.bottomAnchor,paddingTop: 100,paddingBottom: 50,height: 60)
        buttonStack.centerX(inView: view)
        
        view.addSubview(indicatorView)
        indicatorView.anchor(top: detailText.bottomAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,width: view.frame.width)
    }
    
   private func playMP3() {
        let url = URL(string: PodcastViewModel.mp3URLList[PodcastPlayViewController.mp3SelectedNum])
        playerItem = AVPlayerItem(url: url!)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        player = AVPlayer(playerItem: playerItem)
        player.play()
       let interval = CMTime(value: 1, timescale: 1)
       player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.global()) { [self] time in
           let seconds = CMTimeGetSeconds(time)
           let intTime = Int(seconds)
           let stringTime = String(intTime)
           DispatchQueue.main.async {
               TimeLabel.attributedText = PodcastViewModel.timeFetch(num: stringTime, string: nil, size: 17)
               sliderBar.value = Float(intTime)
               if sliderBar.value >= Float(Int(PodcastViewModel.mp3RunTimeList[PodcastPlayViewController.mp3SelectedNum])!) {
                   playIfEnd()
               }
           }
       }
        timeButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
       
    }
    
    func playIfEnd() {
        player.pause()
        timeButton.setImage(UIImage(systemName: "arrowtriangle.forward.circle"), for: .normal)
        playBool = false
    }
    
    //MARK: - 셀렉터 메서드
  @objc func sliderDidChange() {
      player.seek(to: CMTime(value: CMTimeValue(sliderBar.value), timescale: 1))
      sliderBar.value = Float(CMTimeGetSeconds(player.currentTime()))
      let stringValue = String(Int(sliderBar.value))
      TimeLabel.attributedText = PodcastViewModel.timeFetch(num: stringValue, string: nil, size: 17)
      //이부분의 조건문은 슬라이더바의 벨류가 0으로될때 곧 재생이 모두 끝났을때 어떤것을 변화를 줘야하는지의 시점을 알기위한 조건문이다.
      if sliderBar.value >= Float(Int(PodcastViewModel.mp3RunTimeList[PodcastPlayViewController.mp3SelectedNum])!) {
          playIfEnd()
      }
    }

    
    @objc func playSound() {
        if playBool {
            playIfEnd()

        } else {
            //이부분의 조건문은 슬라이더바의 벨류가 0으로될때 곧 재생이 모두 끝났을때 다시 재생버튼을 누르는 시점을 알기위한 조건문이다.
            if sliderBar.value >= Float(Int(PodcastViewModel.mp3RunTimeList[PodcastPlayViewController.mp3SelectedNum])!) {
                sliderBar.value = Float(0)
                playBool = true
                timeButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
                player.seek(to: CMTime(value: 0, timescale: 1))
                player.play()
                TimeLabel.attributedText = NSAttributedString(string: "0:00")
            } else {
            player.play()
            playBool = true
            timeButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            }
        }
    }
    
    @objc func backwardButtonClick() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime - CMTime(value: 15, timescale: 1))
        sliderBar.value -= 15
        let stringValue = String(Int(self.sliderBar.value))
        self.TimeLabel.attributedText = PodcastViewModel.timeFetch(num: stringValue, string: nil, size: 17)
        player.seek(to: CMTime(value: CMTimeValue(sliderBar.value), timescale: 1))
    }
    @objc func gowardButtonClick() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime + CMTime(value: 15, timescale: 1))
        sliderBar.value += 15
        let stringValue = String(Int(self.sliderBar.value))
        self.TimeLabel.attributedText = PodcastViewModel.timeFetch(num: stringValue, string: nil, size: 17)
        player.seek(to: CMTime(value: CMTimeValue(sliderBar.value), timescale: 1))
        if sliderBar.value >= Float(Int(PodcastViewModel.mp3RunTimeList[PodcastPlayViewController.mp3SelectedNum])!) {
            playIfEnd()
        }
        
    }
    
    


    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                indicatorView.stopAnimating()
                indicatorView.isHidden = true
            case .failed:
                print("재생에 실패하얐습니다.")
            case .unknown:
                print("재생할 아이템이없습니다.")
            @unknown default:
                break
            }

        }
    }
    
    
    
    
}









