/*import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(13.7563, 100.5018), // ตำแหน่งเริ่มต้นในกรุงเทพมหานคร
          zoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          // เพิ่ม MarkerLayerOptions หากต้องการใส่ตัวชี้แผนที่บนแผนที่
          MarkerLayer(
            markers: [
              Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(13.7563, 100.5018),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
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
*/