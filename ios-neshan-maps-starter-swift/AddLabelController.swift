//
//  AddLabelController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 12/15/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class AddLabelController: UIViewController {
    
    let BASE_MAP_INDEX: Int32 = 0

    @IBOutlet var map: NTMapView!
    
    var labelLayer = NTVectorElementLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
        
        // when long clicked on map, a label is added in clicked location
        // MapEventListener gets all events on map, including single tap, double tap, long press, etc
        // we should check event type by calling getClickType() on mapClickInfo (from ClickData class)
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapClickedBlock = { clickInfo in
            if clickInfo.getClickType() == .CLICK_TYPE_LONG {
                // by calling getClickPos(), we can get position of clicking (or tapping)
                let clickedLocation = clickInfo.getClickPos()
                // addMarker adds a label (pretty self explanatory :D) to the clicked location
                self.addLabel(clickedLocation!)
            }
        }
        map.setMapEventListener(mapEventListener)
    }
    
    private func initMap() {
        // Creating a VectorElementLayer(called labelLayer) to add all labels to it and adding it to map's layers
        labelLayer = NTNeshanServices.createVectorElementLayer()
        map.getLayers()?.add(labelLayer)
        
        // add STANDARD_DAY map to layer BASE_MAP_INDEX
        map?.getOptions()?.setZoom(NTRange(min: 4.5, max: 18))
        let baseMap: NTLayer = NTNeshanServices.createBaseMap(NTNeshanMapStyle.STANDARD_DAY)
        map?.getLayers()?.insert(BASE_MAP_INDEX, layer: baseMap)
        
        // Setting map focal positionto a fixed position and setting camera zoom
        map?.setFocalPointPosition(NTLngLat(x: 51.330743, y: 35.767234), durationSeconds: 0.5)
        map?.setZoom(14, durationSeconds: 0.5)
    }
    
    // This method gets a LngLat as input and adds a label on that position
    private func addLabel(_ clickedLocation: NTLngLat) {
        // First, we should clear every label that is currently located on map
        labelLayer.clear()
        
        // Creating label style. We should use an object of type LabelStyleCreator, set all features on it
        // and then call buildStyle method on it. This method returns an object of type LabelStyle
        let labelStCr = NTLabelStyleCreator()
        labelStCr?.setFontSize(15)
        labelStCr?.setBackgroundColor(NTARGB(r: 255, g: 255, b: 255, a: 255))
        let labelSt: NTLabelStyle = (labelStCr?.buildStyle())!
        
        // Creating labels
        let label = NTLabel(pos: clickedLocation, style: labelSt, text: "مکان انتخاب شده")
        
        // Adding label to labelLayer, or showing label on map!
        labelLayer.add(label)
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
