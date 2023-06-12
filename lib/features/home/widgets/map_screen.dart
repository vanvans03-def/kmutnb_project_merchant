// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  var marker = <Marker>[];
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    void updateMarkerInfo(double lat, double lng) async {
      String address = await reverseGeocoding(lat, lng);
      print('Address: $address');
      // ทำอะไรกับ address ต่อไป
    }

    void updateMarker(double lat, double long) {
      setState(() {
        marker = [
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(lat, long),
            builder: (ctx) => const Icon(
              Icons.location_pin,
              color: Colors.red,
            ),
          ),
        ];
        updateMarkerInfo(lat, long);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPosition, point) => {
                    setState(() {
                      isTapped = !isTapped;
                      String pointString = point.toString();
                      String latString = pointString.substring(
                          pointString.indexOf('latitude:') + 9,
                          pointString.indexOf(','));
                      String longString = pointString.substring(
                          pointString.indexOf('longitude:') + 10,
                          pointString.indexOf(')'));

                      double latitude = double.parse(latString);
                      double longitude = double.parse(longString);

                      updateMarker(latitude, longitude);
                      setState(() {});
                    })
                  },
                  center: LatLng(13.7563, 100.5018),
                  zoom: 12.0,
                  maxZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  // เพิ่ม MarkerLayerOptions หากต้องการใส่ตัวชี้แผนที่บนแผนที่

                  MarkerLayer(
                    markers: marker,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          LatLng center = mapController.center;
          Navigator.pop(context, center);
        },
      ),
    );
  }
}

Future<String> reverseGeocoding(double latitude, double longitude) async {
  String url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    String road = jsonData['address']['road'] ?? '';
    String village = jsonData['address']['village'] ?? '';
    String town = jsonData['address']['town'] ?? '';
    String city = jsonData['address']['city'] ?? '';
    String state = jsonData['address']['state'] ?? '';

    // ignore: unused_local_variable
    String address = '$road, $village, $town, $city, $state';

    return state;
  } else {
    return '';
  }
}
