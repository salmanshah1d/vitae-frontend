//
//  CameraController.swift
//  Vitae
//
//  Created by Salman Shahid on 25/1/2020.
//  Copyright © 2020 AVS. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1920x1080
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
    }
    
    func setupViews() {
        view.addSubview(cameraView)
        view.addSubview(imageView)
        view.addSubview(captureButton)
        view.addSubview(dropButton)
        view.addSubview(uploadButton)
        
        cameraView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cameraView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cameraView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.isHidden = true
        
        let buttonSize = CGFloat(80)
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonSize).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.layer.cornerRadius = buttonSize/2
        
        dropButton.isHidden = true
        dropButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonSize).isActive = true
        dropButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        dropButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        dropButton.rightAnchor.constraint(equalTo: captureButton.leftAnchor).isActive = true
        dropButton.layer.cornerRadius = buttonSize/2
        
        uploadButton.isHidden = true
        uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonSize).isActive = true
        uploadButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        uploadButton.leftAnchor.constraint(equalTo: captureButton.rightAnchor).isActive = true
        uploadButton.layer.cornerRadius = buttonSize/2
    }
    
    func setupGestures() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           rightRecognizer.direction = .right
           self.view.addGestureRecognizer(leftRecognizer)
           self.view.addGestureRecognizer(rightRecognizer)
    }
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController?.selectedIndex = 2
        }
        
        if sender.direction == .right {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    let imageView:UIImageView = {
        let uv = UIImageView()
        uv.contentMode = .scaleAspectFill
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()

    let cameraView:UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()

    let captureButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return btn
    }()
    
    let dropButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dropPhoto), for: .touchUpInside)
        return btn
    }()
    
    let uploadButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        return btn
    }()
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func dropPhoto() {
        imageView.isHidden = true
        captureButton.isHidden = false
        dropButton.isHidden = true
        uploadButton.isHidden = true
    }
    
    @objc func uploadPhoto() {
        guard let image = imageView.image else { return }
        let imageData = image.pngData()
        let imageName = UUID().uuidString
        let childRef = "\(imageName).png"
        let storageRef = Storage.storage().reference().child(childRef)
        if let uploadData = imageData {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
            }
        }
        
        imageView.isHidden = true
        captureButton.isHidden = false
        dropButton.isHidden = true
        uploadButton.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        print(image.size)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        imageView.image = image
        
        imageView.isHidden = false
        captureButton.isHidden = true
        dropButton.isHidden = false
        uploadButton.isHidden = false
    }
}
