//
//  TrafficLayerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class TrafficLayerController: UIViewController {

    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    let TRAFFIC_INDEX: Int32 = 1
    
    @IBOutlet var map: NTMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
    }

    private func initMap() {
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
        
        // adding traffic layer to TRAFFIC_INDEX
        map.getLayers()?.insert(TRAFFIC_INDEX, layer: NTNeshanServices.createTrafficLayer())
    }
    

    @IBAction func toggleTrafficLayer(_ sender: UISwitch) {
        if sender.isOn {
            map.getLayers()?.insert(TRAFFIC_INDEX, layer: NTNeshanServices.createTrafficLayer())
        } else {
            map.getLayers()?.remove(map.getLayers()?.get(TRAFFIC_INDEX))
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
