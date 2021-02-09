import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/screens/map_screen.dart';
import "package:location/location.dart";

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreviewLocation(double lat, double lng) {
    final previeImage = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitud: lng);
    setState(() {
      _previewImageUrl = previeImage;
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final response = await Location().getLocation();
      _showPreviewLocation(response.latitude, response.longitude);
      widget.onSelectPlace(response.latitude, response.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _getLocationOnMap() async {
    final locationData = await Location().getLocation();
    final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                appBarTitle: "Pick a location from this map.",
                isSelecting: true,
                latitude: locationData.latitude,
                longitude: locationData.longitude)));
    if (selectedLocation == null) {
      return;
    }
    _showPreviewLocation(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: _previewImageUrl == null
              ? Text(
                  "No location chosen",
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: () {
                _getUserLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text("Use current location"),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _getLocationOnMap,
              icon: Icon(Icons.map),
              label: Text("Select on Map"),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
