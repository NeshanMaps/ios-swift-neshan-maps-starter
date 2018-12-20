//
//  OnlineLayerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class OnlineLayerController: UIViewController {

    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    @IBOutlet var map: NTMapView!
    
    var markerLayer = NTVectorElementLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        
        if checkInternet() {
            download("https://api.neshan.org/points.geojson")
        }
    }
    
    private func initMap() {
        // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
        markerLayer = NTNeshanServices.createVectorElementLayer()
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    private func checkInternet() -> Bool {
        let networkReachability: Reachability = Reachability.forInternetConnection()
        let networStatus: NetworkStatus = networkReachability.currentReachabilityStatus()
        return networStatus != .NotReachable
    }
    
    private func addMarker(_ loc: NTLngLat) {
        // Creating animation for marker. We should use an object of type AnimationStyleBuilder, set
        // all animation features on it and then call buildStyle() method that returns an object of type
        // AnimationStyle
        let animStB1 = NTAnimationStyleBuilder()
        animStB1?.setFade(NTAnimationType.ANIMATION_TYPE_SMOOTHSTEP)
        animStB1?.setSizeAnimationType(NTAnimationType.ANIMATION_TYPE_SPRING)
        animStB1?.setPhaseInDuration(0.5)
        animStB1?.setPhaseOutDuration(0.5)
        let animSt: NTAnimationStyle = animStB1!.buildStyle()
        
        // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
        // and then call buildStyle method on it. This method returns an object of type MarkerStyle
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker")))
        // AnimationStyle object - that was created before - is used here
        markStCr?.setAnimationStyle(animSt)
        var markSt = NTMarkerStyle()
        markSt = markStCr!.buildStyle()
        
        // Creating marker
        let marker = NTMarker(pos: loc, style: markSt)
        
        // Adding marker to markerLayer, or showing marker on map!
        markerLayer.add(marker)
    }
    
    private func onJsonDownload(_ jsonData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let points = json as? [String:Any] {
                if let featuresArray = points["features"] as? [Any] {
                    
                    map.getLayers()?.add(markerLayer)
                    var minLat = Double.greatestFiniteMagnitude
                    var minLng = Double.greatestFiniteMagnitude
                    var maxLat = Double.leastNormalMagnitude
                    var maxLng = Double.leastNormalMagnitude
                    
                    for i in 0...(featuresArray.count)-1 {
                        
                        if let features = featuresArray[i] as? [String:Any] {
                            if let geometry = features["geometry"] as? [String:Any] {
                                if let coordinates = geometry["coordinates"] as? [Any] {
                                    
                                    let lngLat = NTLngLat(x: coordinates[0] as! Double, y: coordinates[1] as! Double)
                                    
                                    minLat = min((lngLat?.getY())!, minLat)
                                    minLng = min((lngLat?.getX())!, minLng)
                                    maxLat = max((lngLat?.getY())!, maxLat)
                                    maxLng = max((lngLat?.getX())!, maxLng)
                                    addMarker(lngLat!)
                                    
                                }
                            }
                        }
                    }
                    
                    let scale: CGFloat = UIScreen.main.scale
                    
                    let viewportBounds = NTViewportBounds(min: NTViewportPosition(x: 0, y: 0), max: NTViewportPosition(x: Float(self.map.frame.size.width * scale), y: Float(self.map.frame.size.height * scale)))
                    
                    let bounds = NTBounds(min: NTLngLat(x: minLng, y: minLat), max: NTLngLat(x: maxLng, y: maxLat))
                    
                    map.move(toCameraBounds: bounds, viewportBounds: viewportBounds, integerZoom: true, durationSeconds: 0.5)
                    
                }
            }
        }
        catch let error {
            print("ERROR IS: \(error)")
        }
    }
    
    private func download(_ urlDownload: String) {
        do {
            let url = URL(string: urlDownload)!
            let urlData = try Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.onJsonDownload(urlData)
            }

        }
        catch let error {
            print(error)
        }
    }
    

    @IBAction func toggleOnlineLayer(_ sender: UISwitch) {
        if sender.isOn {
            if checkInternet() {
                download("https://api.neshan.org/points.geojson")
            }
        } else {
            map.getLayers()?.remove(markerLayer)
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
