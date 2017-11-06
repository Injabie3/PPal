//
//  ViewController.swift
//  PPal
//
//  Created by RuiHongGong on 10/24/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import UserNotifications
import MessageUI


class Emergency: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    var sliderVar = 0.0
    var coordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }  //request the background notification from user
        
        
        locationManager.delegate = self //setting the delegate CCLocationManager to this UIViewcontroller class
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters //Zoom in on the user location to the nearest to Ten Meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Accuracy of the user location - there are many desired Accuracies to choose from ie. kCLLocationAccuracyNearestTenMeters
        
        
        
        mapView.delegate = self  //setting the map delegate to this UIViewController class
        mapView.showsUserLocation = true //shows the location of the user with a blue dot
        mapView.userTrackingMode = .follow //tracks the user - blue dot is always in the center of the mapview
        
        
        locationManager.requestAlwaysAuthorization() //Requests location access from user when in use of the application and in the background
        locationManager.startUpdatingLocation() //starts updating the location of the user
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /* override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     enableLocationServices()
     }*/
    
    
    
    @IBAction func emergencyCall(_ sender: AnyObject)  //emergency call when "Emergency Button" pressed
    {
        if buttonState == false     //global var to check if the button is off or on in "Emergency Settings" to check
        {
            if (copyPerson.getInfo().phoneNumber.isEmpty) //check to see if the user has tapped on one of the emergency contacts if tapped that contact is guaranteed to have a phonenumber
            {
                print("please set emergency contact")
            }
            else  //this will call the set contact number
            {
                let url: NSURL = URL(string: "TEL://\(copyPerson.getInfo().phoneNumber)")! as NSURL
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                print(copyPerson.getInfo().phoneNumber)
            }
            
        }
        else
        {
            print("please set emergency contact")
            
        }
    }
    
    func escalateLocationServiceAuthorization() {   //can be used to upgrade the location access to "always location access" only if the user chose "When in use" in the beginning
        // Escalate only when the authorization is set to when-in-use
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    
    func setRegion()  //sets the circular region (but not draw the circular region) and then begin to monitor the user with respect to the region
    {
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(sliderVar), identifier: "Safe Zone")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: CLLocationDistance(sliderVar))
        mapView.add(circle)
        
    }
    
    
    @IBAction func addRegion(_ sender: Any) {  //this function turns the position of the long press by the user into a coordinate on the mapview
        
        guard let longPress = sender as? UILongPressGestureRecognizer else{return}
        
        
        let touchLocation = longPress.location(in: mapView)
        
        coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        setRegion()
        
    }
    
    
    @IBAction func sliderAction(_ sender: Any) { //this function gets the value of the slider into a temporary variable where is then passed into setregion function
        
        guard let Slider = sender as? UISlider else{return}
        
        sliderVar = Double(Slider.value)
        setRegion()
        
    }
    
    func inAppAlert (tle: String, msg: String){  //in app alert function
        let Alert = UIAlertController(title: tle, message: msg, preferredStyle: .alert)
        let Action = UIAlertAction(title: "Dismiss Alert", style: .default, handler: nil)
        Alert.addAction(Action)
        present(Alert, animated: true, completion: nil)
    }
    
    func backGroundNotification(tle: String, msg: String) { // background notification
        let content = UNMutableNotificationContent()
        content.title = tle
        content.body = msg
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "BackGroundNotif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
}


extension Emergency: CLLocationManagerDelegate{  //extension to the Emergency class including the CLLocationManager's delegate
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {  //this delegate function is called every time the user location is updated
        //locationManager.stopUpdatingLocation()
        
        
        
        print(manager.location!.coordinate.latitude)
        print(manager.location!.coordinate.longitude)
        
        /* let location = locations[0]
         let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
         let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
         let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
         mapView.setRegion(region, animated: true)*/
        
        
        print("location shown")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {  // this delegate function is called every time the user exits the the monitored circular region
        let title = "EMERGENCY ALERT"
        let message = "The AD patient has left the designated region"
        inAppAlert(tle: title, msg: message)
        backGroundNotification(tle: title, msg: message)
        //sendMessage()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {  //this delegate function is called every time the user enters the the monitored circular region
        let title = "REGION NOTIFICATION"
        let message = "The AD patient has come back to the designated region"
        inAppAlert(tle: title, msg: message)  //calling the in app alert function with the title and message set above
        backGroundNotification(tle: title, msg: message) //notify the user in background with the same title and message
        
    }
    
}

extension Emergency: MKMapViewDelegate { //this mapview delegate is use to draw a green circular region
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .green
        circleRenderer.fillColor = .green
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}
