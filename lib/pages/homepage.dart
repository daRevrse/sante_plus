import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sante_plus/dataHandler/appData.dart';
import 'package:sante_plus/pages/loginpage.dart';
import 'package:sante_plus/pages/mapPage.dart';
import 'package:sante_plus/pages/profilepage.dart';
import 'package:sante_plus/provider/assistants/assistantMethods.dart';
import 'package:sante_plus/provider/models/userModel.dart';

class Home extends StatefulWidget {

  final UserModel userModel;
  Home(this.userModel);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("Voici mon adresse : " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MediaQuery.of(context).platformBrightness == Brightness.dark ? Image.asset('assets/SOSDoc (2).png') : Image.asset('assets/SOSDocW (2).png'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white10,
              height: 200,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blue,
                      child: ClipOval(
                        child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: widget.userModel.profileUrl == '' ?
                            Image.network(
                              "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              fit: BoxFit.fill,
                            ) : Image.network(widget.userModel.profileUrl,fit: BoxFit.fill,)
                        ),
                      ),
                    ),
                    height: 100,
                    width: 100,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${widget.userModel.nom}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,)),
                        Text("${widget.userModel.prenom}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(widget.userModel)),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text("Portefeuille"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Historique"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Paramètres"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Déconnexion"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("A propos"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                boxShadow: [BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7)
                ),]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add_location),
                          ),
                          Text(Provider.of<AppData>(context).userLocation != null ? Provider.of<AppData>(context).userLocation!.placeName : "Ma position")
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add_location),
                          ),
                          Text("Ma position")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }
}

