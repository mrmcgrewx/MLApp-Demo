//
//  CameraController.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/14/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreLocation

class CameraController: UIViewController, CameraView, AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate, AVCapturePhotoCaptureDelegate {
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation!
    
    var userInfo: UserInfo!
    var dataService: DataService?
    
    private var classification = [String]()
    private var toggle: Bool = false
    private var cR: CGFloat = 8.0
    private let photoDir = "photos"
    private lazy var progressHUD = ProgressHUD()
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var rescanButton: FancyButton!
    @IBOutlet weak var sendButton: FancyButton!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var capturedImage: UIImageView!
    
    var onCameraComplete: (() -> Void)?
    
    //MARK: - Override Functions
    private func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        location = nil
    }
    
    private func setupUI() {
        dataView.backgroundColor = UIColor.black
        dataView.setBorder()
        capturedImage.setBorder()
        setAlpha(dataView, 0.75)
        setAlpha(dataLabel, 0.75)
        setAlpha(sendButton, 0)
        setAlpha(rescanButton, 0)
        setAlpha(capturedImage, 0)
        dataLabel.adjustsFontSizeToFitWidth = true
        self.view.bringSubview(toFront: capturedImage)
        self.view.bringSubview(toFront: dataView)
        self.view.bringSubview(toFront: dataLabel)
        self.view.bringSubview(toFront: buttonStack)
    }
    
    private func setupCameraView() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        captureSession.startRunning()
        if(captureSession.canAddOutput(photoOutput)) {
            captureSession.addOutput(photoOutput)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup GPS
        setupLocation()

        //Setup camera
        setupCameraView()
        
        //Setup UI
        setupUI()
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            onCameraComplete?()
        }
    }
    
    //MARK: - AVCaptureVideoDataOutputSampleBufferDelegate Feunctions
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if toggle {
            return
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: VGG16().model) else { return }
        let request = VNCoreMLRequest(model: model) {
            (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            if results.isEmpty {
                return
            } else {
                let topClassifications = results.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classification = descriptions
                DispatchQueue.main.async {
                    self.dataLabel.text = descriptions.joined(separator: " ")
                }
                if (topClassifications[0].confidence >= 0.5) {
                    self.toggle = true
                    DispatchQueue.main.async {
                        self.setupImage()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dataView.backgroundColor = UIColor.black
                    }
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    //MARK: - CLLocationManagerDelegate Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        location = latestLocation
    }
    
    //MARK: - AVCaptureDelegate Functions
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            self.capturedImage.image = image
            self.capturedImage.fadeIn(duration: 1, delay: 0)
        } else {
            print("some error here")
        }
    }
    
    //MARK: - Action Functions
    @IBAction func rescanAction(_ sender: FancyButton) {
        self.resetView()
    }
    
    @IBAction func sendAction(_ sender: FancyButton) {
        self.progressHUD.show()
        self.saveToHistory(photoDir, UUID().uuidString)
        guard let imageData = UIImagePNGRepresentation(self.capturedImage.image!) else {
            print("Should not see this, did not process image data")
            return
        }
        let image: String = imageData.base64EncodedString()
        
        var data = [String:Any]()
        data["username"] = userInfo.username
        data["class1"] = classification[0]
        data["class2"] = classification[1]
        data["lat"] = location.coordinate.latitude
        data["lon"] = location.coordinate.longitude
        data["alt"] = location.altitude
        data["imageData"] = image
        
        self.dataService?.submitData(data, with: userInfo, completion: { [weak self] result in
            switch result {
            case .data(_):
                self?.progressHUD.hide()
                self?.resetView()
            case .error(let error):
                self?.showError(error)
            }
        })
    }
    
    //MARK: - Private Functions
    private func saveToHistory(_ dir:String,_ name:String) {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(dir)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: false, attributes: nil)
        }
        fileURL.appendPathComponent(name)
        let image = capturedImage.image!
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
    }
    
    private func resetView() {
        self.dataView.alpha = 0.75
        self.rescanButton.fadeOut(duration: 0.5, delay: 0)
        self.sendButton.fadeOut(duration: 0.5, delay: 0.1)
        self.capturedImage.fadeOut(duration: 1, delay: 0, completion: { _ in 
            self.capturedImage.image = nil
        })
        toggle = false
    }
    
    private func setAlpha(_ view: UIView,_ alpha: CGFloat) {
        view.alpha = alpha
    }
    
    private func setupImage() {
        self.dataView.alpha = 0.5
        self.rescanButton.fadeIn(duration: 0.5, delay: 0)
        self.sendButton.fadeIn(duration: 0.5, delay: 0.1)
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}
