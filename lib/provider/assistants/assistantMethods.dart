//import 'dart:js';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sante_plus/dataHandler/appData.dart';
import 'package:sante_plus/provider/assistants/requestAssistant.dart';
import 'package:sante_plus/provider/configMap.dart';
import 'package:sante_plus/provider/models/address.dart';

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    Uri url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");

    var response = await RequestAssistant.getRequest(url);

    if(response != "Echec"){
      placeAddress = response["results"][0]["formatted_address"];

      Address userAddress = Address("",placeAddress,"",position.latitude,position.longitude);
      userAddress.longitude = position.longitude;
      userAddress.latitude = position.latitude;
      userAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updateUserLocation(userAddress);
    }

    return placeAddress;
  }
}