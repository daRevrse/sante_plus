import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sante_plus/provider/models/userModel.dart';

import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  ProfilePage(this.userModel);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _image;
  String pp = "";
  bool isModif = false;

  late FocusNode firstFocusNode;
  late FocusNode lastFocusNode;

  TextEditingController firstcontroller = TextEditingController();
  TextEditingController lastcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstcontroller.text == widget.userModel.prenom;
    lastcontroller.text == widget.userModel.nom;
    firstFocusNode = FocusNode();
    lastFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _image = File(image!.path);
        isModif = true;
      });
    }

    Future<String> uploadPic() async{
      String fileName = basename(_image.path);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      var uploadTask = firebaseStorageRef.putFile(_image);
      var taskSnapshot = await uploadTask;
      String ppUrl = await taskSnapshot.ref.getDownloadURL();

      return ppUrl;
    }

    @override
    void dispose() {
      firstFocusNode.dispose();
      lastFocusNode.dispose();
      // TODO: implement dispose
      super.dispose();
    }


    return Scaffold(
      appBar: isModif == true ? AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Mon Profile'),
        actions: [
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                pp = await uploadPic();

                final docUser = FirebaseFirestore.instance.collection('users').doc(widget.userModel.id);

                docUser.update({
                  'nom' : lastcontroller.text,
                  'prenom' : firstcontroller.text,
                  'profileUrl' : pp,
                });

                print(pp);
                var userUpdated;

                final snapshot = await docUser.get();

                if(snapshot.exists){
                  setState(() {
                    userUpdated = UserModel.fromJson(snapshot.data()!);
                  });
                }

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home(userUpdated)),
                        (route) => false);
              })
        ],
      ) : AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Mon Profile'),
      ),
      body: Builder(
        builder: (context) =>  Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: widget.userModel.profileUrl == '' ?
                            _image != null ?
                            Image.file(
                              _image,
                              fit: BoxFit.fill)
                                :Image.network(
                              "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              fit: BoxFit.fill,
                            ) :
                                Image.network(widget.userModel.profileUrl,fit: BoxFit.fill,)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 200,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Nom',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent, fontSize: 18.0)),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                focusNode: lastFocusNode,
                                controller: lastcontroller,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.name,
                                onSubmitted: (val) => lastcontroller.text = val,
                                onEditingComplete: (){
                                  setState(() {
                                    isModif = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: IconButton(
                          onPressed: () => lastFocusNode.requestFocus(),
                          icon: Icon(Icons.mode),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 200,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Prénom',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent, fontSize: 18.0)),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                focusNode: firstFocusNode,
                                controller: firstcontroller,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.name,
                                onSubmitted: (val) => firstcontroller.text = val,
                                onEditingComplete: (){
                                  setState(() {
                                    isModif = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: IconButton(
                          onPressed: () => firstFocusNode.requestFocus(),
                          icon: Icon(Icons.mode),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Numéro de téléphone',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent, fontSize: 18.0)),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('${widget.userModel.phone}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Position',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent, fontSize: 18.0)),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Lomé, Togo',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),

                /*SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   *//* RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () async {
                        pp = await uploadPic();

                        final docUser = FirebaseFirestore.instance.collection('users').doc(widget.userModel.id);
                        
                        docUser.update({
                          'nom' : lastcontroller.text,
                          'prenom' : firstcontroller.text,
                          'profileUrl' : pp,
                        });

                        print(pp);
                        var userUpdated;

                        final snapshot = await docUser.get();

                        if(snapshot.exists){
                          setState(() {
                            userUpdated = UserModel.fromJson(snapshot.data()!);
                          });
                        }

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home(userUpdated)),
                                (route) => false);
                      },

                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),*//*

                  ],
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}