//
//  AddMarkerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 11/21/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class AddMarkerController: UIViewController {
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    // map UI element
    var map = NTMapView()
    // You can add some elements to a VectorElementLayer
    var markerLayer = NTVectorElementLayer()
    // Marker that will be added on map
    var marker = NTMarker()
    // an id for each marker
    var markerId: Double = 0
    // marker animation style
    var animSt = NTAnimationStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing mapView element
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
                self.addMarker(loc: clickedLocation!, id: self.markerId)
                // increment id
                self.markerId += 1
            }
        }
        map?.setMapEventListener(mapEventListener)
        
    }
    
    // MARK: - Initializing Map
    func initMap() {
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
        view = map
    }
    
    // MARK: - AddMarker
    // This method gets a LngLat as input and adds a marker on that position
    func addMarker(loc: NTLngLat, id: Double) {
        // If you want to have only one marker on map at a time, uncomment next line to delete all markers before adding a new marker
        // markerLayer.clear()
        
        // Creating animation for marker. We should use an object of type AnimationStyleBuilder, set
        // all animation features on it and then call buildStyle() method that returns an object of type
        // AnimationStyle
        let animStB1 = NTAnimationStyleBuilder()
        animStB1?.setFade(NTAnimationType.ANIMATION_TYPE_SMOOTHSTEP)
        animStB1?.setSizeAnimationType(NTAnimationType.ANIMATION_TYPE_SPRING)
        animStB1?.setPhaseInDuration(0.5)
        animStB1?.setPhaseOutDuration(0.5)
        animSt = animStB1!.buildStyle()
        
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
        marker = NTMarker(pos: loc, style: markSt)
        // Setting a metadata on marker, here we have an id for each marker
        marker.setMetaData("id", element: NTVariant(doubleVal: id))
        // Adding marker to markerLayer, or showing marker on map!
        markerLayer.add(marker)
        
        let vectorElementEventListener = VectorElementClickedListener()
        vectorElementEventListener?.onVectorElementClickedBlock = {clickInfo in
            // If a double click happens on a marker...
            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_DOUBLE {
                let removeId = (clickInfo.getVectorElement().getMetaDataElement("id").getDouble())
                // updating own ui element must run on ui thread not in map ui thread
                DispatchQueue.main.async {
                    NeshanHelper.toast(self, message: "Pin number \(Int(removeId)) removed")
                }
                //getting marker reference from clickInfo and remove that marker from markerLayer
                self.markerLayer.remove(clickInfo.getVectorElement())
                
            // If a single click happens...
            } else if clickInfo.getClickType() == NTClickType.CLICK_TYPE_SINGLE {
                // changing marker to blue
                self.changeMarkerToBlue(redMarker: NTMarker(pos: clickInfo.getClickPos(), style: markSt))
            }
            return true
        }
        markerLayer.setVectorElementEventListener(vectorElementEventListener)
    }
    
    // MARK: - ChangeMarkerToBlue
    func changeMarkerToBlue(redMarker: NTMarker) {
        // create new marker style
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(20)
        // Setting a new bitmap as marker
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker_blue")))
        // AnimationStyle object - that was created before - is used here
        markStCr?.setAnimationStyle(animSt)
        let blueMarkSt = markStCr?.buildStyle()
        // changing marker style using setStyle
        redMarker.setStyle(blueMarkSt)
    }
    
}
