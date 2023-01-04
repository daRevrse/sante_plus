import 'package:flutter/cupertino.dart';
import 'package:sante_plus/provider/models/address.dart';

class AppData extends ChangeNotifier{

  Address? userLocation;

  void updateUserLocation(Address? userAddress){
    userLocation = userAddress!;
    notifyListeners();
  }

}