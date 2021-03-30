import 'package:flutter/material.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformMap(
        initialCameraPosition: CameraPosition(
          target: const LatLng(40.6058825381345, -75.37786957033981),
          zoom: 16.0,
        ),
        markers: Set<Marker>.of(
          [
            Marker(
                markerId: MarkerId('lehigh'),
                position: LatLng(40.6058825381345, -75.37786957033981),
                consumeTapEvents: true,
                infoWindow: InfoWindow(
                  title: 'Lehigh University',
                  snippet: 'This is Lehigh',
                ),
                onTap: () {
                  print('Marker tapped');
                }),
          ],
        ),
        mapType: MapType.hybrid,
        onTap: (location) => print('onTap: $location'),
        onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
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
  }
}
