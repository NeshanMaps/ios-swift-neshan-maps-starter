//
//  POILayerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class POILayerController: UIViewController {
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    let POI_INDEX: Int32 = 1

    @IBOutlet var map: NTMapView!
    
    @IBOutlet weak var themePreview: UIButton!
    
    var mapStyle = NTNeshanMapStyle.STANDARD_DAY
    
    var isPOIEnabled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        validateThemePreview()
    }
    
    private func validateThemePreview() {
        switch mapStyle {
            case .STANDARD_DAY:
                themePreview.setImage(UIImage(named: "map_style_standard_night"), for: UIControl.State.normal)
                break
            case .STANDARD_NIGHT:
                themePreview.setImage(UIImage(named: "map_style_neshan"), for: UIControl.State.normal)
                break
            case .NESHAN:
                themePreview.setImage(UIImage(named: "map_style_standard_day"), for: UIControl.State.normal)
                break
        }
    }
    
    private func initMap() {
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: NTNeshanServices.createBaseMap(mapStyle))
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
        
        // adding traffic layer to TRAFFIC_INDEX
        map.getLayers()?.insert(POI_INDEX, layer: NTNeshanServices.createPOILayer(mapStyle == .STANDARD_NIGHT))
    }
    
    @IBAction func changeStyle(_ sender: UIButton) {
        let previousMapStyle = mapStyle
        switch previousMapStyle {
            case .STANDARD_DAY:
                mapStyle = .STANDARD_NIGHT
                break
            case .STANDARD_NIGHT:
                mapStyle = .NESHAN
                break
            case .NESHAN:
                mapStyle = .STANDARD_DAY
                break
        }
        DispatchQueue.main.async {
            self.validateThemePreview()
        }
        map.getLayers()?.remove(map.getLayers()?.get(BASE_MAP_INDEX))
        map.getLayers()?.insert(BASE_MAP_INDEX, layer: NTNeshanServices.createBaseMap(mapStyle))
        if isPOIEnabled {
            map.getLayers()?.remove(map.getLayers()?.get(POI_INDEX))
            map.getLayers()?.insert(POI_INDEX, layer: NTNeshanServices.createPOILayer(mapStyle == .STANDARD_NIGHT))
        }
    }
    

    @IBAction func togglePOILayer(_ sender: UISwitch) {
        isPOIEnabled = !isPOIEnabled
        if sender.isOn {
            map.getLayers()?.insert(POI_INDEX, layer: NTNeshanServices.createPOILayer(mapStyle == .STANDARD_NIGHT))
        } else {
            map.getLayers()?.remove(map.getLayers()?.get(POI_INDEX))
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
