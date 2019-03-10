//
//  ChangeStyleController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class ChangeStyleController: UIViewController {

    @IBOutlet var map: NTMapView!
    
    @IBOutlet weak var themePreveiw: UIButton!
    
    var mapStyle = NTNeshanMapStyle.STANDARD_DAY
    
    let BASE_MAP_INDEX: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
        validateThemePreview()
    }
    
    func initMap() {
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: NTNeshanServices.createBaseMap(mapStyle))
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    func validateThemePreview() {
        switch mapStyle {
        case .STANDARD_DAY:
            themePreveiw.setImage(UIImage(named: "map_style_standard_night"), for: .normal)
        case .STANDARD_NIGHT:
            themePreveiw.setImage(UIImage(named: "map_style_neshan"), for: .normal)
        case .NESHAN:
            themePreveiw.setImage(UIImage(named: "map_style_standard_day"), for: .normal)
        }
        NeshanHelper.toast(self, message: mapStyle == .STANDARD_DAY ? "روز استاندارد" : mapStyle == .STANDARD_NIGHT ? "شب استاندارد" : "نشان")
    }
    
    @IBAction func changeStyle(_ sender: UIButton) {
        let previousMapStyle = mapStyle
        switch previousMapStyle {
        case .STANDARD_DAY:
            mapStyle = NTNeshanMapStyle.STANDARD_NIGHT
            break
        case .STANDARD_NIGHT:
            mapStyle = NTNeshanMapStyle.NESHAN
            break
        case .NESHAN:
            mapStyle = NTNeshanMapStyle.STANDARD_DAY
            break
        }
        DispatchQueue.main.async {
            self.validateThemePreview()
        }
        map.getLayers()?.remove(map.getLayers()?.get(BASE_MAP_INDEX))
        map.getLayers()?.insert(BASE_MAP_INDEX, layer: NTNeshanServices.createBaseMap(mapStyle))
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
