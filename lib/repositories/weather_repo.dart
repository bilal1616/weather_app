import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/constants/api_key.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  Future<String> getLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Konum servisiniz kapalı");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Konum izni vermelisiniz");
      }
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final String? city = placemark[0].administrativeArea;

    if (city == null) throw Exception("Bir sorun oluştu");

    return city;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await getLocation();

    final String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city";
    Map<String, dynamic> headers = {
      "authorization": apikey,
      "content-type": "application/json"
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      throw Exception("Bir sorun oluştu");
    }

    final List list = response.data['result'];

    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();
    return weatherList;
  }
}
