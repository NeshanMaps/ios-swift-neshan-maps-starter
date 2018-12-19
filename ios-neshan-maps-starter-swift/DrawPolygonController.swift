//
//  DrawPolygonController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class DrawPolygonController: UIViewController {

    // map UI element
    @IBOutlet var map: NTMapView!
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    // You can add some elements to a VectorElementLayer. We add lines to this layer
    var polygonLayer = NTVectorElementLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing mapView element
        initMaps()

    }
    
    // MARK: - Initializing Map
    func initMaps() {
        // Creating a VectorElementLayer (called markerLayer) to add all markers ti it and adding it to map's layers
        polygonLayer = NTNeshanServices.createVectorElementLayer()
        map?.getLayers()?.add(polygonLayer)
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    @IBAction func drawPolygonGeom(_ sender: UIButton) {
        polygonLayer.clear()
        
        let lngLatVector = NTLngLatVector()
        lngLatVector?.add(NTLngLat(x: 51.325525, y: 35.762294))
        lngLatVector?.add(NTLngLat(x: 51.323768, y: 35.756548))
        lngLatVector?.add(NTLngLat(x: 51.328617, y: 35.755394))
        lngLatVector?.add(NTLngLat(x: 51.330666, y: 35.760905))
        
        let polygonGeom = NTPolygonGeom(poses: lngLatVector)
        
        let polygon = NTPolygon(geometry: polygonGeom, style: getPolygonStyle())
        
        polygonLayer.add(polygon)
        
        map.setFocalPointPosition(NTLngLat(x: 51.325525, y: 35.762294), durationSeconds: 0.5)
        map.setZoom(14, durationSeconds: 0.5)
    }
    
    private func getPolygonStyle() -> NTPolygonStyle {
        let polygonStCr = NTPolygonStyleCreator()
        polygonStCr?.setLineStyle(getLineStyle())
        return (polygonStCr?.buildStyle())!
    }
    
    private func getLineStyle() -> NTLineStyle {
        let lineStCr = NTLineStyleCreator()
        lineStCr?.setColor(NTARGB(r: 2, g: 119, b: 189, a: 190))
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
