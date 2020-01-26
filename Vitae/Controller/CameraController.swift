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
import CoreLocation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, CLLocationManagerDelegate {
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var currentPhoto: Data?
    let locationManager = CLLocationManager()
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        // add transparent info text overlay
        
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
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor(hexString: "#fa8231")
        btn.setImage(UIImage(named: "camera_filled"), for: UIControl.State.normal)
        btn.imageView?.contentMode = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return btn
    }()
    
    let dropButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hexString: "#fa8231")
        btn.setImage(UIImage(named: "cross"), for: UIControl.State.normal)
        btn.imageView?.contentMode = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dropPhoto), for: .touchUpInside)
        return btn
    }()
    
    let uploadButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hexString: "#fa8231")
        btn.setImage(UIImage(named: "check"), for: UIControl.State.normal)
        btn.imageView?.contentMode = .center
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
        let imageName = UUID().uuidString
        let childRef = "\(imageName).png"
        let storageRef = Storage.storage().reference().child(childRef)
        
        if let uploadData = currentPhoto {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                } else {
                    let lon = self.locationManager.location?.coordinate.longitude ?? 0
                    let lat = self.locationManager.location?.coordinate.latitude ?? 0
                    
                    let requestUrl = URL(string: "http://192.168.2.46:8080/classify?fn=\(childRef)&uid=\(self.user.userId)&lat=\(lat)&lon=\(lon)")!
                    // Create URL Request
                    var request = URLRequest(url: requestUrl)
                    // Specify HTTP Method to use
                    request.httpMethod = "GET"
                    // Send HTTP Request
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        // Check if Error took place
                        if let error = error {
                            print("Error took place \(error)")
                            return
                        }
                
                        // Convert HTTP Response Data to a simple String
                        do {
                            if let speciesDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                                if speciesDict["error"] == nil {
                                    DispatchQueue.main.async {
                                        let vc = EntityInfoController()
                                        let species = Species(userDict: speciesDict)
                                        vc.species = species
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                        self.imageView.isHidden = true
                                        self.captureButton.isHidden = false
                                        self.dropButton.isHidden = true
                                        self.uploadButton.isHidden = true
                                    }
                                }
                                print(speciesDict)
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                    task.resume()
                }
            }
        }
        self.imageView.isHidden = true
        self.captureButton.isHidden = false
        self.dropButton.isHidden = true
        self.uploadButton.isHidden = true
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
        
        currentPhoto = imageData
        
        let image = UIImage(data: imageData)
        imageView.image = image
        
        imageView.isHidden = false
        captureButton.isHidden = true
        dropButton.isHidden = false
        uploadButton.isHidden = false
    }
}

