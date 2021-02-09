import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(
          context,
          listen: false,
        ).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                builder: (ctx, greatPlacesData, child) => greatPlacesData
                            .items.length <=
                        0
                    ? child
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          // padding: EdgeInsets.all(25),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 2 / 1.3,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemBuilder: (ctx, i) => InkWell(
                            borderRadius: BorderRadius.circular(10.00),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailsScreen.routeName,
                                  arguments: greatPlacesData.items[i].id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.00)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GridTile(
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.00)),
                                    child: Image.file(
                                      greatPlacesData.items[i].image,
                                      fit: BoxFit.cover,
                                    )),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black54,
                                  title: Container(
                                    // color: Colors.black54,
                                    margin: EdgeInsets.only(top: 2),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.0,
                                      vertical: 5.0,
                                    ),
                                    child: Text(
                                      greatPlacesData.items[i].location.address,
                                      // style: TextStyle(fontSize: 28),
                                    ),
                                  ),
                                ),
                                header: GridTileBar(
                                    backgroundColor: Colors.black54,
                                    // title: Text(greatPlacesData.items[i].title),
                                    title: Container(
                                      // color: Colors.black54,
                                      margin: EdgeInsets.only(top: 2),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.0,
                                        vertical: 5.0,
                                      ),
                                      child: Text(
                                        greatPlacesData.items[i].title,
                                        style: TextStyle(fontSize: 28),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          itemCount: greatPlacesData.items.length,
                        ),
                      ),
                child: Center(
                  child: const Text("Got no places yet, start adding some!"),
                ),
              ),
      ),
    );
  }
}
