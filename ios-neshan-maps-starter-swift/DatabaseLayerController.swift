//
//  DatabaseLayerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 12/17/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit
import FMDB

class DatabaseLayerController: UIViewController {

    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    @IBOutlet var map: NTMapView!
    
    // You can add some elements to a VectorElementLayer
    var markerLayer = NTVectorElementLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        getDBPoints()
    }
    
    private func initMap() {
        // Creating a VectorElementLayer (called markerLayer) to add all markers ti it and adding it to map's layers
        markerLayer = NTNeshanServices.createVectorElementLayer()
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
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
    
    private func getDBPoints() {
        let path: String = Bundle.main.path(forResource: "database", ofType: "sqlite") ?? "path is nil"
        var db: FMDatabase? = FMDatabase(path: path)
        
        if !(db!.open()) {
            db = nil
            return
        }
        let cursor: FMResultSet = (db?.executeQuery("select * from points", withArgumentsIn: []))!
        
        // variable for creating bound
        // min = south-west
        // max = north-east
        var minLat = Double.greatestFiniteMagnitude
        var minLng = Double.greatestFiniteMagnitude
        var maxLat = Double.leastNormalMagnitude
        var maxLng = Double.leastNormalMagnitude
        self.map.getLayers()?.add(markerLayer)
        
        while cursor.next() {
            let lng: Double = cursor.double(forColumn: "lng")
            let lat: Double = cursor.double(forColumn: "lat")
            let lngLat = NTLngLat(x: lng, y: lat)
            // validating min and max
            minLat = min((lngLat?.getY())!, minLat)
            minLng = min((lngLat?.getX())!, minLng)
            maxLat = max((lngLat?.getY())!, maxLat)
            maxLng = max((lngLat?.getX())!, maxLng)
            
            addMarker(lngLat!)
        }
        db?.close()
        
        let scale: CGFloat = UIScreen.main.scale
        
        let viewportBounds = NTViewportBounds(min: NTViewportPosition(x: 0, y: 0), max: NTViewportPosition(x: Float(self.map.frame.size.width * scale), y: Float(self.map.frame.size.height * scale)))
        
        let bounds = NTBounds(min: NTLngLat(x: minLng, y: minLat), max: NTLngLat(x: maxLng, y: maxLat))
        
        map.move(toCameraBounds: bounds, viewportBounds: viewportBounds, integerZoom: true, durationSeconds: 0.5)
    }
    
    @IBAction func toggleDatabaseLayer(_ sender: UISwitch) {
        if sender.isOn {
            getDBPoints()
        } else {
            map.getLayers()?.remove(markerLayer)
        }
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
