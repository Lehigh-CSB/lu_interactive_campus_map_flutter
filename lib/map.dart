import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  @override
  Widget build(BuildContext context) {
    return _buildMap();
  }

  Widget _buildMap() {
    return StreamBuilder(
        stream: FirebaseDatabase().reference().child('events').onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading Maps.. Please wait');
          List<Marker> markers = [];

          for (int i = 0; i < 65; i++) {
            if (snapshot.data.snapshot.value['event_' + i.toString()] != null) {
              var currentEvent =
                  snapshot.data.snapshot.value['event_' + i.toString()];
              double latitude, longitude;
              if (currentEvent['latitude'] is double)
                latitude = currentEvent['latitude'];
              else
                latitude = double.parse(currentEvent['latitude']);
              if (currentEvent['longitude'] is double)
                longitude = currentEvent['longitude'];
              else
                longitude = double.parse(currentEvent['longitude']);
              markers.add(new Marker(
                  markerId: MarkerId(currentEvent['title']),
                  position: LatLng(
                  latitude, longitude),
                  consumeTapEvents: true,
                  infoWindow: InfoWindow(
                    title: currentEvent['title'],
                    snippet: currentEvent['description'],
                  ),
                  onTap: () {
                    print('Marker tapped');
                  }));
            }
          }

          return Scaffold(
            body: PlatformMap(
              initialCameraPosition: CameraPosition(
                target: const LatLng(40.6058825381345, -75.37786957033981),
                zoom: 16.0,
              ),
              markers: Set<Marker>.of(markers),
              mapType: MapType.hybrid,
              onTap: (location) => print('onTap: $location'),
              onCameraMove: (cameraUpdate) =>
                  print('onCameraMove: $cameraUpdate'),
              compassEnabled: true,
              onMapCreated: (controller) {
                Future.delayed(Duration(seconds: 2)).then((_) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        bearing: 0.0,
                        target: LatLng(40.6058825381345, -75.37786957033981),
                        tilt: 0.0,
                        zoom: 18,
                      ),
                    ),
                  );
                  // TODO: add map bounds
                  // controller.animateCamera(
                  //   CameraUpdate.newLatLngBounds(
                  //     LatLngBounds(
                  //       southwest: LatLng(40.57213086648479, -75.41696873071834),
                  //       northeast: LatLng(40.61721342747275, -75.35184091722228)),
                  //   1));
                  controller
                      .getVisibleRegion()
                      .then((bounds) => print('bounds: ${bounds.toString()}'));
                });
              },
            ),
          );
        });
  }
}
