//
//  DrawLineController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class DrawLineController: UIViewController {

    // map UI element
    @IBOutlet var map: NTMapView!
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    // You can add some elements to a VectorElementLayer. We add lines to this layer
    var lineLayer = NTVectorElementLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initializing mapView element
        initMap()
    }
    
    // MARK: - Initializing Map
    func initMap() {
        // Creating a VectorElementLayer (called markerLayer) to add all markers ti it and adding it to map's layers
        lineLayer = NTNeshanServices.createVectorElementLayer()
        map?.getLayers()?.add(lineLayer)
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
        view = map
    }
    
    // MARK: - DrawLine on Button Tap
    @IBAction func drawLineGeom(_ sender: UIButton) {
        lineLayer.clear()
        
        let lngLatVector = NTLngLatVector()
        lngLatVector?.add(NTLngLat(x: 51.327650, y: 35.769368))
        lngLatVector?.add(NTLngLat(x: 51.323889, y: 35.756670))
        lngLatVector?.add(NTLngLat(x: 51.383889, y: 35.746670))
        
        let lineGeom = NTLineGeom(poses: lngLatVector)
        
        let line = NTLine(geometry: lineGeom, style: getLineStyle())
        
        lineLayer.add(line)
        
        map?.setFocalPointPosition(NTLngLat(x: 51.327650, y: 35.769368), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    private func getLineStyle() -> NTLineStyle {
        let lineStCr = NTLineStyleCreator()
        lineStCr?.setColor(NTARGB(r: UInt8(2), g: UInt8(119), b: UInt8(189), a: UInt8(190)))
        lineStCr?.setWidth(12)
        lineStCr?.setStretchFactor(0)
        return (lineStCr?.buildStyle())!
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
