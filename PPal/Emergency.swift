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
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /* override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     enableLocationServices()
     }*/
    
    
    
    @IBAction func emergencyCall(_ sender: AnyObject)
    {
        if copyPerson.getInfo().phoneNumber.isEmpty
        {
            
        }
        else
        {
            let url: NSURL = URL(string: "TEL://\(copyPerson.getInfo().phoneNumber)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
            print(copyPerson.getInfo().phoneNumber)
        }
    }
    
    
    /* func enableLocationServices()
     {
     if CLLocationManager.authorizationStatus() == .notDetermined{
     
     print("not determined")
     locationManager.requestAlwaysAuthorization()
     
     }
     if CLLocationManager.authorizationStatus() == .denied{
     // Disable location features
     inAppAlert(tle: "Location Service is Denied", msg: "Please enable Location Service in Settings")
     }
     
     else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
     // Enable basic location features
     print("authorize when in use")
     
     }
     
     else if CLLocationManager.authorizationStatus() == .authorizedAlways{
     // Enable any of your app's location features
     print("always authorized")
     locationManager.startUpdatingLocation()
     
     }
     
     
     
     }*/
    
    /*  func sendMessage()
     {
     PeopleBank.shared.getPeople()
     let messageVC = MFMessageComposeViewController()
     messageVC.body = "The AD patient has left the designated region"
     messageVC.recipients = ["7789293728"]
     messageVC.messageComposeDelegate = self
     
     present(messageVC, animated: true, completion: nil)
     
     
     }*/
    
    
    func escalateLocationServiceAuthorization() {
        // Escalate only when the authorization is set to when-in-use
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    
    func setRegion()
    {
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(sliderVar), identifier: "Safe Zone")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: CLLocationDistance(sliderVar))
        mapView.add(circle)
        
    }
    
    
    @IBAction func addRegion(_ sender: Any) {
        
        guard let longPress = sender as? UILongPressGestureRecognizer else{return}
        
        
        let touchLocation = longPress.location(in: mapView)
        
        coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        setRegion()
        
    }
    
    
    @IBAction func sliderAction(_ sender: Any) {
        
        guard let Slider = sender as? UISlider else{return}
        
        sliderVar = Double(Slider.value)
        setRegion()
        
    }
    
    func inAppAlert (tle: String, msg: String){
        let Alert = UIAlertController(title: tle, message: msg, preferredStyle: .alert)
        let Action = UIAlertAction(title: "Dismiss Alert", style: .default, handler: nil)
        Alert.addAction(Action)
        present(Alert, animated: true, completion: nil)
    }
    
    func backGroundNotification(tle: String, msg: String) {
        let content = UNMutableNotificationContent()
        content.title = tle
        content.body = msg
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "BackGroundNotif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
}



/*extension ViewController:MFMessageComposeViewControllerDelegate
 {
 
 
 
 func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
 switch result.rawValue {
 case MessageComposeResult.cancelled.rawValue :
 print("message canceled")
 
 case MessageComposeResult.failed.rawValue :
 print("message failed")
 
 case MessageComposeResult.sent.rawValue :
 print("message sent")
 
 default:
 break
 }
 controller.dismiss(animated: true, completion: nil)
 }
 
 
 }*/

extension Emergency: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "EMERGENCY ALERT"
        let message = "The AD patient has left the designated region"
        inAppAlert(tle: title, msg: message)
        backGroundNotification(tle: title, msg: message)
        //sendMessage()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "REGION NOTIFICATION"
        let message = "The AD patient has come back to the designated region"
        inAppAlert(tle: title, msg: message)
        backGroundNotification(tle: title, msg: message)
        
    }
    
}

extension Emergency: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .green
        circleRenderer.fillColor = .green
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}
