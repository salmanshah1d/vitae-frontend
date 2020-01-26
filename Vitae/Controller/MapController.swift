//
//  MapController.swift
//  Vitae
//
//  Created by Vladimir Dyagilev on 2020-01-25.
//  Copyright © 2020 AVS. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    let user: User
    var species = [Species]()
    
    // Change status bar color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "My Captures 🌍"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGestures()
        
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        
        let requestUrl = URL(string: "http://192.168.2.46:8080/get_captures?uid=\(self.user.userId)")!
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
                    if let speciesArr = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                        for val in speciesArr {
                            let point = MKPointAnnotation()
                            guard let locationArray = (val["location"] as? [NSNumber]) else { return }
                            let lat = locationArray[0]
                            let lon = locationArray[1]
                            point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(truncating: lat), CLLocationDegrees(truncating: lon))
                            mapView.addAnnotation(point)
                        }
                        DispatchQueue.main.async {}
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
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
        if sender.direction == .right {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
