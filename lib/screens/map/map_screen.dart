import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/utils/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapcontroller;
  static late LatLng _initialPosition;
  bool isLoading = true;
  String address = "";
  double? lat;
  double? long;
  Services services = Services();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapcontroller = controller;
  }

  void _getUserLocation() async {
    Position? position = await getCurrentLocation();
    setState(() {
      _initialPosition = LatLng(position!.latitude, position.longitude);
      isLoading = false;
    });
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = _mapcontroller;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
    return centerLatLng;
  }

  Future<void> _onMapMoved() async {
    LatLng _currentCenter = await getCenter();
    print("Coords ${_currentCenter.latitude}, ${_currentCenter.longitude}");
    getCurrentAddress(_currentCenter.latitude, _currentCenter.longitude);
  }

  void getCurrentAddress(double lati, double longi) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lati, longi);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[0];
        String? street = placeMark.street;
        //String name = placeMark.name;
        String? subLocality = placeMark.locality;
        String? postalCode = placeMark.postalCode;
        String addressPostion = "$street, $postalCode, $subLocality";
        print(address);
        setState(() {
          address = addressPostion;
          lat = lati;
          long = longi;
        });
      } else {
        print("No address");
      }
    } catch (err) {
      print(err);
    }
  }

  void addAddress() async {
    final dynamic data = {
      "newAdress": {"address": address, "lat": lat, "long": long}
    };
    print(data);
    var response = await services.updateMe(data);
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Text(
                'Cargando Mapa..',
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onCameraIdle: () {
                    _onMapMoved();
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 18,
                  ),
                  //initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Text(
                            address,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Icon(
                        Boxicons.bx_map,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 75, vertical: 8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: DefaultButton(
                        press: addAddress,
                        text: "Elegir",
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
