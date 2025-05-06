import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheather_app/addtitional_info_item.dart';
import 'package:wheather_app/hourly_forcatsing_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Bamako';
      String? apiKey = dotenv.env['APIKey'];

      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric'),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wheather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currenTemp = currentWeatherData['main']['temp'];
          final currenSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHuidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currenTemp °C',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currenSky == "Clouds" || currenSky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "$currenSky",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Hourly Forecast",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastingCard(
                          hour: DateFormat.j().format(time),
                          icon: hourlyForecast['weather'][0]['main'] ==
                                      'Clouds' ||
                                  hourlyForecast['weather'][0]['main'] == 'Rain'
                              ? Icon(Icons.cloud)
                              : Icon(Icons.sunny),
                          value: hourlyForecast['main']['temp'].toString());
                    },
                  ),
                ),

                SizedBox(height: 20),
                Text("Additionnal Informations",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                // additionnal information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHuidity',
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
