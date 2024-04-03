import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/repositories/weather_repo.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetch);
    on<ResetFetchWeatherEvent>(_onReset);
  }
  void _onFetch(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    final city = await weatherRepository.getLocation();
    final weatherList = await weatherRepository.getWeatherData();
    emit(WeatherLoaded(weathers: weatherList, city: city));
  }

  void _onReset(
      ResetFetchWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherInitial());
  }
}