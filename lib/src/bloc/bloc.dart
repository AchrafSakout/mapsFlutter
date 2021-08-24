import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderMaps with ChangeNotifier {
  LatLng _gpsactual;
  LatLng initialposition = LatLng(31.792305849269, -7.080168000000015);
  bool activegps = true;
  TextEditingController locationController = TextEditingController();
  GoogleMapController _mapController;
  LatLng get gpsPosition => _gpsactual;
  LatLng get initialPos => initialposition;
  final Set<Marker> _markers = Set();
  final Set<Marker> _posAccident = Set();
  Set<Marker> get posAccident => _posAccident;
  Set<Marker> get markers => _markers;
  GoogleMapController get mapController => _mapController;
  Position position;
  double rot;
  //iconForMarkers
  BitmapDescriptor customIcon;
  //forcontext
  BuildContext myCon;

  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        initialposition.latitude, initialposition.longitude);
    locationController.text = placemark[0].name;
  }

  void getUserLocation() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      activegps = false;
    } else {
      activegps = true;
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      initialposition = LatLng(position.latitude, position.longitude);
      print(
          "the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
      locationController.text = placemark[0].name;
      _addMarker(initialposition, placemark[0].name);
      _mapController.moveCamera(CameraUpdate.newLatLng(initialposition));
      print("initial position is : ${placemark[0].name}");
      notifyListeners();
    }
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    creatMarker(myCon);
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(title: address, snippet: "go here"),
    ));
    notifyListeners();
  }

  void addPosAccident(Position pos) {
    Marker marker = Marker(
      markerId: MarkerId(_posAccident.toString()),
      position: LatLng(pos.latitude, pos.longitude),
      rotation: pos.heading,
      icon: customIcon,
    );
    _posAccident.add(marker);
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) async {
    initialposition = position.target;
    //rot = position.tilt;
    notifyListeners();
  }

  creatMarker(context) async {
    // ignore: unnecessary_null_comparison
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/images/car_icon.png')
          .then((icon) {
        customIcon = icon;
      });
    }
    notifyListeners();
  }
}
