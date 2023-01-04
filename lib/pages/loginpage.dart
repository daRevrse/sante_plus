import 'package:flutter/material.dart';
import 'package:sante_plus/provider/otp.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sante_plus/provider/models/userModel.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController firstcontroller = TextEditingController();
  TextEditingController lastcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Container(
                  child: Column(
                    children: [
                      MediaQuery.of(context).platformBrightness == Brightness.dark ? Image.asset("assets/SOSDoc (2).png",width: 120,height: 100,) : Image.asset("assets/SOSDocW (2).png",width: 120,height: 100,),
                      Image.asset("assets/logo.png",width: 120,height: 120,),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'Inscription',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, right: 50, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryCodePicker(
                        initialSelection: 'TG',
                        enabled: false,
                      ),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Numéro de téléphone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, right: 50, left: 50),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Votre prénom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    controller: firstcontroller,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, right: 50, left: 50),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Votre nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    controller: lastcontroller,
                  ),
                )
              ]),
              Container(
                margin: EdgeInsets.only(left: 50,top: 50,right: 50),
                width: double.infinity,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    final user = UserModel(
                      nom: lastcontroller.text,
                      prenom: firstcontroller.text,
                      phone: _controller.text,
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterOTP(_controller.text,user)));
                  },
                  child: Text(
                    'Suivant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'Déja inscrit ?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Connectez-vous',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Container(
                  child: Column(
                    children: [
                      MediaQuery.of(context).platformBrightness == Brightness.dark ? Image.asset("assets/SOSDoc (2).png",width: 120,height: 100,) : Image.asset("assets/SOSDocW (2).png",width: 120,height: 100,),
                      Image.asset("assets/logo.png",width: 120,height: 120,),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'Connexion',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, right: 50, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryCodePicker(
                        initialSelection: 'TG',
                        enabled: false,
                      ),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Numéro de téléphone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(left: 50,top: 50,right: 50),
                width: double.infinity,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginOTP(_controller.text)));
                  },
                  child: Text(
                    'Suivant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'Nouveau ?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          'Inscrivez-vous',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
