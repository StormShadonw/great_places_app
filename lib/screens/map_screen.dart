import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:great_places_app/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  final double latitude;
  final double longitude;
  final String appBarTitle;

  MapScreen({
    this.initialLocation = const PlaceLocation(
      langitud: -73.22,
      latitude: 37.22,
    ),
    this.isSelecting = false,
    this.latitude,
    this.longitude,
    this.appBarTitle,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          actions: [
            if (widget.isSelecting && _pickedLocation != null)
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop(_pickedLocation);
                },
              ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.latitude,
                widget.longitude,
              ),
              zoom: 15,
            ),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: (_pickedLocation == null && widget.isSelecting)
                ? null
                : {
                    Marker(
                      markerId: MarkerId("m1"),
                      position: _pickedLocation ??
                          LatLng(widget.initialLocation.latitude,
                              widget.initialLocation.langitud),
                    ),
                  },
          ),
        ));
  }
}
