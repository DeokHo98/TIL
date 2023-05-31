//
//  qrCameraViewController.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/13.
//

import UIKit
import SnapKit
import AVFoundation

final class qrCameraViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - UI Properties
    
    private let cameraView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var guideView: UIView = {
        let view = UIView(frame: view.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)

        let path = CGMutablePath()
        path.addRect(CGRect(x: view.center.x-150, y: view.center.y-300, width: 300, height: 400))
        path.closeSubpath()
        path.addRect(CGRect(origin: self.view.frame.origin, size: self.view.frame.size))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        view.layer.mask = maskLayer
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테이블 선택"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private let description1Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = """
                          매장 내 테이블에 부착된 QR코드를 인식해주세요.
                          매장 메뉴판으로 이동합니다.
                          """
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    private let descriptions2Label: UILabel = {
        let label = UILabel()
        label.text = "해당 테이블 번호로 주문됩니다."
        label.textColor = .systemGray5
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, description1Label, descriptions2Label])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScan()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
    }
    
    // MARK: - setLayout
    
    private func setLayout() {
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(guideView)
        view.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(130)
        }
    }
    
    // MARK: - Instance Methods
    
    private func startScan() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("접근권한 없음")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setLivePreview()
            }
        } catch let error {
            print(error)
        }
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
    }
    private func setLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        cameraView.layer.addSublayer(videoPreviewLayer)
    }
    private func stopScan() {
        captureSession.stopRunning()
        captureSession = nil
        stillImageOutput = nil
        videoPreviewLayer = nil
    }
}
