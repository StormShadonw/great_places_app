import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/widgets/image_input_widget.dart';
import 'package:great_places_app/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static final String routeName = "/addPlaceScreen";

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  PlaceLocation _pickedLocation;
  File _pickedImage;
  final _form = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  void _selectIamge(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, langitud: lng);
  }

  void _savePlace() {
    final isValid = _form.currentState.validate();
    if (!isValid || _pickedImage == null || _pickedLocation == null) {
      return;
    }
    _form.currentState.save();
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Place"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _form,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                // onSaved: (value) {

                                // },
                                decoration: InputDecoration(labelText: "Title"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Provide a title.";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageInput(_selectIamge),
                              SizedBox(
                                height: 10,
                              ),
                              LocationInput(_selectPlace),
                            ],
                          ))))),
          Container(
            height: 50,
            child: RaisedButton.icon(
              onPressed: _savePlace,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text("Add place", style: TextStyle(color: Colors.white)),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
