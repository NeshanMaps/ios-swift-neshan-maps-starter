//
//  ChangeCameraBearingController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class ChangeCameraBearingController: UIViewController {

    @IBOutlet var map: NTMapView!
    
    @IBOutlet weak var bearingSlider: UISlider!
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    var isCameraRotationEnable = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCameraRotationEnable = true
        
        initMaps()
        
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapMovedBlock = {
            DispatchQueue.main.async {
                if self.bearingSlider.value != self.map.getBearing() {
                    self.bearingSlider.setValue(Float(self.map.getBearing()), animated: true)
                }
            }
        }
        map.setMapEventListener(mapEventListener)
    }

    func initMaps() {
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        if map.getBearing() != bearingSlider.value {
            map.setBearing(bearingSlider.value, durationSeconds: 0)
        }
    }
    
    
    @IBAction func toggleCameraBearing(_ sender: UISwitch) {
        isCameraRotationEnable = !isCameraRotationEnable
        if sender.isOn {
            self.bearingSlider.isEnabled = true
            map.getOptions()?.setUserInput(true)
        } else {
            bearingSlider.isEnabled = false
            map.getOptions()?.setUserInput(false)
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
