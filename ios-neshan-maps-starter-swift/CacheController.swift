//
//  CacheController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 12/15/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class CacheController: UIViewController {
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    let POI_INDEX: Int32 = 1

    @IBOutlet var map: NTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
    }
    
    private func initMap() {
        // Cache base map
        // Cache size is 10 MB
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Cache POI Layer
        // Cache size is 10 MB
        let poiLayer: NTLayer = NTNeshanServices.createPOILayer(false)
        map.getLayers()?.insert(POI_INDEX, layer: poiLayer)
        
        // Setting map focal position to a fixed position and setting camera zoom
        map.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map.setZoom(14, durationSeconds: 0.5)
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
