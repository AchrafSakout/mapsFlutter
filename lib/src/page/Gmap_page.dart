import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_center/src/bloc/bloc.dart';
import 'package:google_maps_marker_center/test.dart';
import 'package:provider/provider.dart';

class Gmap extends StatefulWidget {
  Gmap({Key key}) : super(key: key);
  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  @override
  Widget build(BuildContext context) {
    final provmaps = Provider.of<ProviderMaps>(context);
    LatLng pos;
    provmaps.myCon = context;
    //provmaps.creatMarker(context);
    return provmaps.activegps == false
        ? Scaffold(
            body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/images/nogps.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You must activate GPS to get your location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provmaps.getUserLocation();
                    },
                    child: Text('try again'),
                  ),
                ],
              ),
            ),
          ))
        : Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        mapType: MapType.hybrid,
                        //markers:provmaps.markers,
                        onCameraMove: provmaps.onCameraMove,
                        initialCameraPosition: CameraPosition(
                            target: provmaps.initialPos, zoom: 18.0),
                        onMapCreated: provmaps.onCreated,
                        onCameraIdle: () async {
                          provmaps.getMoveCamera();
                        },
                        markers: provmaps.posAccident.map((e) => e).toSet(),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 50,
                            width: 58,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.blueAccent,
                                ),
                                color: Colors.white),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                  "assets/images/indicateur-fixe-gps.svg"),
                              onPressed: provmaps.getUserLocation,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              color: Colors.white,
                              onPressed: () {
                                pos = provmaps.initialposition;
                                Position nouvelle = Position(
                                  latitude: pos.latitude,
                                  longitude: pos.longitude,
                                  heading: provmaps.rot,
                                );
                                provmaps.addPosAccident(nouvelle);
                                print(
                                    "the latitude is: ${nouvelle.latitude} and the longitude is: ${nouvelle.longitude} and the rotation from cameraPosition.bearing is ${provmaps.rot}");
                              },
                              child: Text(
                                "take position",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CounterPage()));
                              },
                              child: Text(
                                "test",
                                style: TextStyle(fontSize: 30),
                              )),
                        ],
                      )),
                  Positioned(
                      top: 0,
                      child: Container(
                          color: Colors.white,
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Google Maps",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ))),
                  Align(
                    alignment: Alignment.center,
                    child: ImageIcon(
                      AssetImage("assets/images/car_icon.png"),
                      size: 60,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
