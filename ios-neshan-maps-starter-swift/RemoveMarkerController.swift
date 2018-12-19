//
//  RemoveMarkerController.swift
//  ios-neshan-maps-starter-swift
//
//  Created by M.Madadi on 12/15/18.
//  Copyright © 2018 Rajman. All rights reserved.
//

import UIKit

class RemoveMarkerController: UIViewController {
    
    // layer number in which map is added
    let BASE_MAP_INDEX: Int32 = 0
    
    // map UI element
    @IBOutlet var map: NTMapView!
    // You can add some elements to a VectorElementLayer
    var markerLayer = NTVectorElementLayer()
    // Marker that will be added on map
    var marker = NTMarker()
    // an id for each marker
    var markerId: Double = 0
    // marker animation style
    var animSt = NTAnimationStyle()
    // save selected marker for select and deselect function
    var selectedMarker: NTMarker? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()

        showFirstStepAction()
        
        let mapEventListener = MapEventListener()
        mapEventListener?.onMapClickedBlock =  {clickInfo in
            if clickInfo.getClickType() == NTClickType.CLICK_TYPE_LONG {
                if self.markerId == 0 {
                    if self.selectedMarker == nil {
                        self.showSecondStepAction()
                    } else {
                        self.deselectMarker(self.selectedMarker!)
                    }
                }
                // by calling getClickPos(), we can get position of clicking (or tapping)
                let clickedLocation = clickInfo.getClickPos()
                // addMarker adds a marker (pretty self explanatory :D) to the clicked location
                self.addMarker(loc: clickedLocation!, id: self.markerId)
                // increment id
                self.markerId += 1
            } else if clickInfo.getClickType() == .CLICK_TYPE_SINGLE && self.selectedMarker != nil {
                self.deselectMarker(self.selectedMarker!)
            }
        }
        map?.setMapEventListener(mapEventListener)
        
        
        let vectorElementEventListener = VectorElementClickedListener()
        vectorElementEventListener?.onVectorElementClickedBlock = {clickInfo in
            // If a double click happens on a marker...
            if clickInfo.getClickType() == .CLICK_TYPE_SINGLE {
                let removeId = (clickInfo.getVectorElement().getMetaDataElement("id").getDouble())
                if self.selectedMarker != nil {
                    self.deselectMarker(self.selectedMarker!)
                } else {
                    self.selectMarker(clickInfo.getVectorElement() as! NTMarker)
                    DispatchQueue.main.async {
                        self.showThirdStepAction(removeId)
                    }
                }
            }
            return true
        }
        markerLayer.setVectorElementEventListener(vectorElementEventListener)
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
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker_blue")))
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
    }
    
    // MARK: - ChangeMarkerToBlue
    func changeMarkerToBlue(redMarker: NTMarker) {
        // create new marker style
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        // Setting a new bitmap as marker
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker_blue")))
        // AnimationStyle object - that was created before - is used here
        markStCr?.setAnimationStyle(animSt)
        let blueMarkSt = markStCr?.buildStyle()
        // changing marker style using setStyle
        redMarker.setStyle(blueMarkSt)
    }
    
    func changeMarkerToRed(blueMarker: NTMarker) {
        // create new marker style
        let markStCr = NTMarkerStyleCreator()
        markStCr?.setSize(30)
        // Setting a new bitmap as marker
        markStCr?.setBitmap(NTBitmapUtils.createBitmap(from: UIImage(named: "ic_marker")))
        // AnimationStyle object - that was created before - is used here
        markStCr?.setAnimationStyle(animSt)
        let blueMarkSt = markStCr?.buildStyle()
        // changing marker style using setStyle
        blueMarker.setStyle(blueMarkSt)
    }
    
    func selectMarker(_ selectMarker: NTMarker) {
        changeMarkerToRed(blueMarker: selectMarker)
        selectedMarker = selectMarker
    }
    
    func deselectMarker(_ selectMarker: NTMarker) {
        changeMarkerToBlue(redMarker: selectMarker)
        selectedMarker = nil
    }
    
    func showFirstStepAction() {
        let optionMenu = UIAlertController(title: "قدم اول", message: "برای ایجاد پین جدید نگهدارید", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        optionMenu.addAction(okButton)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func showSecondStepAction() {
        let optionMenu = UIAlertController(title: "قدم دوم", message: "برای حذف روی پین تپ کنید", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        optionMenu.addAction(okButton)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func showThirdStepAction(_ removeId: Double) {
        let optionMenu = UIAlertController(title: "آیا از حذف \(Int(removeId)) پین اطمینان دارید؟", message: nil, preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "YES", style: .destructive) { (UIAlertAction) in
            if self.selectedMarker != nil {
                self.markerLayer.remove(self.selectedMarker)
                self.deselectMarker(self.selectedMarker!)
            }
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel) { (UIAlertAction) in
            if self.selectedMarker != nil {
                self.deselectMarker(self.selectedMarker!)
            }
        }
        optionMenu.addAction(okButton)
        optionMenu.addAction(cancelButton)
        present(optionMenu, animated: true, completion: nil)
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
