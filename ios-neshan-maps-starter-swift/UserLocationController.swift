//
//  UserLocationController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit
import CoreLocation

class UserLocationController: UIViewController, CLLocationManagerDelegate {
    
    let BASE_MAP_INDEX: Int32 = 0
    
    @IBOutlet var map: NTMapView!
    
    private let UPDATE_INTERVAL_IN_MILISECONDS = 1000
    
    private let FASTEST_UPDATE_INTERVAL_IN_MILISECONDS = 1000
    
    var userMarkerLayer = NTVectorElementLayer()
    
    // User's current Location
    var userLocation: CLLocation!
    var locationManager: CLLocationManager!
    
    let lastUpdateTime = NSString()
    // boolean flag to toggle the ui
    let mRequestingLocationUpdates = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        initMaps()
        initLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLocationUpdates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stopLocationUpdates()
    }
    
    func initMaps() {
        // Creating a VectorElementLayer(called userMarkerLayer) to add user marker to it and adding it to map's layers
        userMarkerLayer = NTNeshanServices.createVectorElementLayer()
        map.getLayers()?.add(userMarkerLayer)
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    func initLocation() {
        // Create a location manager
        locationManager = CLLocationManager()
        // Set a delegate to receive location callbacks
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NeshanHelper.toast(self, message: "عدم موفقیت در گرفتن مکان")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        onLocationChanged()
    }
    
    // Starting location updates
    // Check whether location settings are satisfied and then
    // location updates will be requested
    func startLocationUpdates() {
        // Start the location manager
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        // stop the location manager
        locationManager.stopUpdatingLocation()
    }
    
    func onLocationChanged() {
        if userLocation != nil {
            addUserMarker(NTLngLat(x: userLocation.coordinate.longitude, y: userLocation.coordinate.latitude))
        }
    }
    
    func addUserMarker(_ loc: NTLngLat) {
        // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
        // and then call buildStyle method on it. This method returns an object of type MarkerStyle
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker")))
        let markSt: NTMarkerStyle = markStCr!.buildStyle()
        
        // Creating user marker
        let marker = NTMarker(pos: loc, style: markSt)
        
        // Clearing userMarkerLayer
        userMarkerLayer.clear()
        
        // Adding user marker to userMarkerLayer, or showing marker on map!
        userMarkerLayer.add(marker)
    }

    @IBAction func focusOnUserLocation(_ sender: Any) {
        if userLocation != nil {
            map.setFocalPointPosition(NTLngLat(x: userLocation.coordinate.longitude, y: userLocation.coordinate.latitude), durationSeconds: 0.5)
            map.setZoom(15, durationSeconds: 0.5)
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
