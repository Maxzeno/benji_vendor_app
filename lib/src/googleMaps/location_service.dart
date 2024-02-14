import 'dart:convert' as convert;

import 'package:benji_vendor/src/providers/keys.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<String> getPlaceId(String query) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$query&inputtype=textquery&key=$googleMapsApiKey";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String query) async {
    final placeId = await getPlaceId(query);

    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }
}
