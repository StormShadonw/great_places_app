import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places_app/helpers/db_helpers.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation pickedLocation) async {
    final addresLocation = await LocationHelper.getPlacesAddress(
        pickedLocation.latitude, pickedLocation.langitud);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        langitud: pickedLocation.langitud,
        address: addresLocation);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedLocation,
    );

    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": newPlace.location.latitude,
      "loc_lng": newPlace.location.langitud,
      "address": newPlace.location.address,
    });
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("user_places");
    _items = dataList
        .map((item) => Place(
              id: item["id"],
              title: item["title"],
              image: File(item["image"]),
              location: PlaceLocation(
                  latitude: item["loc_lat"],
                  langitud: item["loc_lng"],
                  address: item["address"]),
            ))
        .toList();
    notifyListeners();
  }
}
