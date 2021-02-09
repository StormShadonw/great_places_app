import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = "/placeDetailScreen";

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    Place selectedPlace = Provider.of<GreatPlaces>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => MapScreen(
                  appBarTitle: "${selectedPlace.location.address}",
                  latitude: selectedPlace.location.latitude,
                  longitude: selectedPlace.location.langitud,
                  initialLocation: selectedPlace.location,
                  isSelecting: false,
                ),
                fullscreenDialog: true,
              ));
            },
            child: Text("View on MaP"),
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
