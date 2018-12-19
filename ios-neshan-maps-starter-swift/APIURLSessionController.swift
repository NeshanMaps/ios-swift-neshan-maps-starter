//
//  APIURLSessionController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 12/16/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class APIURLSessionController: UIViewController {

    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    @IBOutlet var map: NTMapView!
    
    @IBOutlet weak var addressTitle: UILabel!
    
    @IBOutlet weak var addressDetails: UILabel!
    
    var markerLayer = NTVectorElementLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        
        // when long clicked on map, a marker is added in clicked location
        // MapEventListener gets all events on map, including single tap, double tap, long press, etc
        // we should check event type by calling getClickType() on mapClickInfo (from ClickData class)
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapClickedBlock =  {clickInfo in
            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_LONG {
                // by calling getClickPos(), we can get position of clicking (or tapping)
                let clickedLocation = clickInfo.getClickPos()
                // addMarker adds a marker (pretty self explanatory :D) to the clicked location
                self.addMarker(clickedLocation!)
                // increment id
                self.neshanReverseAPI(clickedLocation!)
            }
        }
        map?.setMapEventListener(mapEventListener)
    }
    
    // MARK: - Initializing Map
    private func initMap() {
        // Creating a VectorElementLayer (called markerLayer) to add all markers ti it and adding it to map's layers
        markerLayer = NTNeshanServices.createVectorElementLayer()
        map?.getLayers()?.add(markerLayer)
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    // MARK: - AddMarker
    private func addMarker(_ loc: NTLngLat) {
        // If you want to have only one marker on map at a time, uncomment next line to delete all markers before adding a new marker
        markerLayer.clear()
        
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
        let markSt: NTMarkerStyle = markStCr!.buildStyle()
        
        // Creating marker
        let marker: NTMarker = NTMarker(pos: loc, style: markSt)
        // Adding marker to markerLayer, or showing marker on map!
        markerLayer.add(marker)
    }
    
    // MARK: - NeshanReverseAPI
    private func neshanReverseAPI(_ loc: NTLngLat) {
        let requestURL: String = String(format: "https://api.neshan.org/v2/reverse?lat=%f&lng=%f", loc.getY(), loc.getX())
        let latLngAddr: String = String(format: "%.6f, %.6f", loc.getY(), loc.getX())
        
        let url: URL = URL(string: requestURL)!
        var request: URLRequest = URLRequest(url: url)
        request.setValue(API_KEY, forHTTPHeaderField: "Api-Key")
        
        let session: URLSession = URLSession.shared
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            let httpResponse: HTTPURLResponse = urlResponse as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                let parseError: Error? = nil
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    DispatchQueue.main.async {
                        if parseError == nil && responseObject["neighbourhood"] != nil {
                            self.addressTitle.text = responseObject["neighbourhood"] as? String
                        } else {
                            self.addressTitle.text = "آدرس نامشخص"
                        }
                        if parseError == nil && responseObject["formatted_address"] != nil {
                            self.addressDetails.text = responseObject["formatted_address"] as? String
                        } else {
                            self.addressDetails.text = latLngAddr
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            } else {
                DispatchQueue.main.async {
                    self.addressTitle.text = "آدرس نامشخص"
                    self.addressDetails.text = latLngAddr
                }
            }
        }
        dataTask.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
