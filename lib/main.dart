import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:sante_plus/dataHandler/appData.dart';
import 'package:sante_plus/pages/homepage.dart';
import 'package:sante_plus/provider/models/userModel.dart';
import 'package:sante_plus/provider/theme_provider.dart';
import 'package:sante_plus/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'SOS Doc',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Chemin extends StatefulWidget {
  const Chemin({Key? key}) : super(key: key);

  @override
  _CheminState createState() => _CheminState();
}

class _CheminState extends State<Chemin> {

  var user;
  var userModel;

  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }

  Future onRefreshAgain() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docUser.get();

    if(snapshot.exists){

      var userMod = UserModel.fromJson(snapshot.data()!);

      setState(() {
        userModel = userMod;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
    onRefreshAgain().whenComplete(() async{
      Timer(Duration(seconds: 3), () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => (user == null || userModel == null ? LoginScreen() : Home(userModel))));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",width: 120,height: 120,),
            CircularProgressIndicator(
              valueColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? AlwaysStoppedAnimation<Color>(Colors.white) : AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool hasInternet = false;

  checkConnection()async{
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      hasInternet = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (hasInternet == false) {
      return Scaffold(
        body: Center(
            child: MediaQuery.of(context).platformBrightness == Brightness.dark ? Image.asset("assets/NO INTERNET (1).png") : Image.asset("assets/NO INTERNET.png")
        ),
      );
    }else {
      return Chemin();
    }

  }
}


