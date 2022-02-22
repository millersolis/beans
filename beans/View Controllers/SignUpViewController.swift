//
//  SignUpViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth
import Firebase
import MapboxMaps

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    @IBOutlet weak var mapContainerView: UIView!
    
    internal var mapView: MapView!
    var backButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        view.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        setUpElements()
        setUpMap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Back button
        backButton = UIButton(frame: CGRect(x: 25, y: 45, width: 30, height: 30))
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        backButton.tintColor = Constants.Colors.green
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        self.view.addSubview(backButton)
    }
    
    func setUpMap() {
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiYmVhbnNzIiwiYSI6ImNremYwODFvNzNjeWIyb3IxMW9pZ3dmcW0ifQ.lX8cXzONIzodv0PVJxT3jg")
        
        // Center the map camera over Davie and Granville.
        let centerCoordinate = CLLocationCoordinate2D(latitude: 49.277156,
                                                              longitude: -123.126218)
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: CameraOptions(center: centerCoordinate, zoom: 13.0, bearing: -17.6, pitch: 45))
        
        mapView = MapView(frame: self.mapContainerView.frame, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.gestures.options.pinchRotateEnabled = false
        
        mapContainerView.addSubview(mapView)
        
        // Allow the view controller to receive information about map events.
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.setUpCoverageZone()
            self.makeBuildings3D()
        }

    }
    
    func makeBuildings3D() {
        addBuildingExtrusions()

        let cameraOptions = CameraOptions(zoom: 13.0,
                                          bearing: -17.6,
                                          pitch: 45)
        
        mapView.mapboxMap.setCamera(to: cameraOptions)

        // The below lines are used for internal testing purposes only.
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            // self.finish()
        }
    }

    // See https://docs.mapbox.com/mapbox-gl-js/example/3d-buildings/ for equivalent gl-js example
    internal func addBuildingExtrusions() {
        var layer = FillExtrusionLayer(id: "3d-buildings")

        layer.source                      = "composite"
        layer.minZoom                     = 4
        layer.sourceLayer                 = "building"
        layer.fillExtrusionColor   = .constant(StyleColor(.lightGray))
        layer.fillExtrusionOpacity = .constant(0.68)

        layer.filter = Exp(.eq) {
            Exp(.get) {
                "extrude"
            }
            "true"
        }

        layer.fillExtrusionHeight = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                4
                0
                20.05
                Exp(.get) {
                    "height"
                }
            }
        )

        layer.fillExtrusionBase = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                4
                0
                20.05
                Exp(.get) { "min_height"}
            }
        )

        try! mapView.mapboxMap.style.addLayer(layer)
    }
    
    func setUpCoverageZone() {
        
        // Attempt to decode GeoJSON from file bundled with application.
        guard let featureCollection = try? decodeGeoJSON(from: "coverageZone1") else { return }
        let geoJSONDataSourceIdentifier = "geoJSON-data-source"
         
        // Create a GeoJSON data source.
        var geoJSONSource = GeoJSONSource()
        geoJSONSource.data = .featureCollection(featureCollection)
        
        var polygonLayer = FillLayer(id: "fill-layer")
        polygonLayer.filter = Exp(.eq) {
            "$type"
            "Polygon"
        }
        
        polygonLayer.source = geoJSONDataSourceIdentifier
        polygonLayer.fillColor = .constant(StyleColor(.green))
        polygonLayer.fillOpacity = .constant(0.38)
        polygonLayer.fillOutlineColor = .constant(StyleColor(.purple))
        
        // Add the source and style layers to the map style.
        try! mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)

        try! mapView.mapboxMap.style.addLayer(polygonLayer)
        
        
    }
    
    // Load GeoJSON file from local bundle and decode into a `FeatureCollection`.
    internal func decodeGeoJSON(from fileName: String) throws -> FeatureCollection? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
            preconditionFailure("File '\(fileName)' not found.")
        }
        let filePath = URL(fileURLWithPath: path)
        var featureCollection: FeatureCollection?
        do {
            let data = try Data(contentsOf: filePath)
            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
        } catch {
            print("Error parsing data: \(error)")
        }
        return featureCollection
    }
    
    func setUpElements() {
        //Hide error label
        errorLabel.alpha = 0
        
        //Style text fields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(addressTextField)
        
        //Style button
        Utilities.styleFilledButton(signUpButton)
    }
    
    //Check fields and validate if data is correct.
    //Iff everything is correct, return nil.
    //Else return an error message.
    func ValidateFields() -> String? {
        //Text fields contents
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Check all fields are not empty
        if  firstName == "" || lastName == "" || email == "" || password == "" {
            return "Please fil in all fields"
        }
        
        //Check if password is secure
        if !Utilities.isPasswordValid(password!) {
            return "Please make sure your password is at least 8 characters long, contains a number and a special character"
        }

        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate fields
        let error = ValidateFields()
        
        if error != nil {
            //Show error message
            showError(error!)
        }
        else {
            //Create string user info
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //Check for errors
                if err != nil {
                    //err?.localizedDescription //More detailed error description
                    self.showError("Error creating user")
                }
                else {
                    //User was created successfully, now store user data
                    let db = Firestore.firestore()
                    
                    let userData: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "uid": String(result!.user.uid)
                    ]
                    
                    db.collection("users").document(result!.user.uid).setData(userData) { (error) in
                        if error != nil {
                            //Show error message
                            self.showError("Error saving user data")
                        }
                    }
                }
            }
             
            //Transition to home screen
            self.transitionToHome()
        }
    }
    
    //Go back to main when back button tapped
    @objc func backTapped(sender: UIButton!) {
        transitionToMain()
    }
    
    //Show error message label with passed text
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //Transition to home after user creation
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    //Transition to main screen
    func transitionToMain() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }

}
