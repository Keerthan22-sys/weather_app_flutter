import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cityName = "Bengaluru"; // city name
  int _currTemp = 0; // current temperature
  int _maxTemp = 0; // today max temperature
  int _minTemp = 0; // today min temperature
  bool _isDarkMode = false;
  final _cityController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchWeatherData(_cityName);
  }

  Future<void> _fetchWeatherData(String cityName) async {
    final apiKey = ""; // your API key
    final url = "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _cityName = cityName; // update _cityName only if API call is successful
        _currTemp = jsonData["main"]["temp"].toInt();
        _maxTemp = jsonData["main"]["temp_max"].toInt();
        _minTemp = jsonData["main"]["temp_min"].toInt();
      });
    } else if (response.statusCode == 404) {
      _showErrorDialog("City not found");

    } else {
      _showErrorDialog("Failed to load weather data");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter City Name"),
          content: TextField(
            controller: _cityController,
          ),
          actions: [
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () {
                setState(() {
                  _cityName = _cityController.text;
                });
                _fetchWeatherData(_cityName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final brightness = MediaQuery.of(context).platformBrightness;
    _isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.black : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bars,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                            Align(
                              child: Text(
                                'Weather App', //TODO: change app name
                                style: GoogleFonts.questrial(
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xff1D1617),
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDialog();
                              },
                              child: FaIcon(
                                FontAwesomeIcons.plusCircle,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            )

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          child: Text(
                            _cityName,
                            style: GoogleFonts.questrial(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: size.height * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: Align(
                          child: Text(
                            'Today', //day
                            style: GoogleFonts.questrial(
                              color:
                                  _isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: size.height * 0.035,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          child: Text(
                            '$_currTemp˚C', //curent temperature
                            style: GoogleFonts.questrial(
                              color: _currTemp <= 0
                                  ? Colors.blue
                                  : _currTemp > 0 && _currTemp <= 15
                                      ? Colors.indigo
                                      : _currTemp > 15 && _currTemp < 30
                                          ? Colors.deepPurple
                                          : Colors.pink,
                              fontSize: size.height * 0.13,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.25),
                        child: Divider(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: Align(
                          child: Text(
                            'Sunny', // weather
                            style: GoogleFonts.questrial(
                              color:
                                  _isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                          bottom: size.height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$_minTemp˚C', // min temperature
                              style: GoogleFonts.questrial(
                                color: _minTemp <= 0
                                    ? Colors.blue
                                    : _minTemp > 0 && _minTemp <= 15
                                        ? Colors.indigo
                                        : _minTemp > 15 && _minTemp < 30
                                            ? Colors.deepPurple
                                            : Colors.pink,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                            Text(
                              '/',
                              style: GoogleFonts.questrial(
                                color: _isDarkMode
                                    ? Colors.white54
                                    : Colors.black54,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                            Text(
                              '$_maxTemp˚C', //max temperature
                              style: GoogleFonts.questrial(
                                color: _maxTemp <= 0
                                    ? Colors.blue
                                    : _maxTemp > 0 && _maxTemp <= 15
                                        ? Colors.indigo
                                        : _maxTemp > 15 && _maxTemp < 30
                                            ? Colors.deepPurple
                                            : Colors.pink,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: _isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),
                                  child: Text(
                                    'Forecast for today',
                                    style: GoogleFonts.questrial(
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      //TODO: change weather forecast from local to api get
                                      buildForecastToday(
                                        "Now", //hour
                                        _currTemp, //temperature
                                        20, //wind (km/h)
                                        0, //rain chance (%)
                                        FontAwesomeIcons.sun, //weather icon
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "15:00",
                                        1,
                                        10,
                                        40,
                                        FontAwesomeIcons.cloud,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "16:00",
                                        0,
                                        25,
                                        80,
                                        FontAwesomeIcons.cloudRain,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "17:00",
                                        -2,
                                        28,
                                        60,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "18:00",
                                        -5,
                                        13,
                                        40,
                                        FontAwesomeIcons.cloudMoon,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "19:00",
                                        -8,
                                        9,
                                        60,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "20:00",
                                        -13,
                                        25,
                                        50,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "21:00",
                                        -14,
                                        12,
                                        40,
                                        FontAwesomeIcons.cloudMoon,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "22:00",
                                        -15,
                                        1,
                                        30,
                                        FontAwesomeIcons.moon,
                                        size,
                                        _isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "23:00",
                                        -15,
                                        15,
                                        20,
                                        FontAwesomeIcons.moon,
                                        size,
                                        _isDarkMode,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.02,
                                    left: size.width * 0.03,
                                  ),
                                  child: Text(
                                    '7-day forecast',
                                    style: GoogleFonts.questrial(
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: Column(
                                  children: [
                                    //TODO: change weather forecast from local to api get
                                    buildSevenDayForecast(
                                      "Today", //day
                                      _minTemp, //min temperature
                                      _maxTemp, //max temperature
                                      FontAwesomeIcons.cloud, //weather icon
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Wed",
                                      -5,
                                      5,
                                      FontAwesomeIcons.sun,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Thu",
                                      -2,
                                      7,
                                      FontAwesomeIcons.cloudRain,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Fri",
                                      3,
                                      10,
                                      FontAwesomeIcons.sun,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "San",
                                      5,
                                      12,
                                      FontAwesomeIcons.sun,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Sun",
                                      4,
                                      7,
                                      FontAwesomeIcons.cloud,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Mon",
                                      -2,
                                      1,
                                      FontAwesomeIcons.snowflake,
                                      size,
                                      _isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Tues",
                                      0,
                                      3,
                                      FontAwesomeIcons.cloudRain,
                                      size,
                                      _isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData weatherIcon, size, bool _isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: _isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚C',
            style: GoogleFonts.questrial(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wind,
                  color: Colors.grey,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$wind km/h',
            style: GoogleFonts.questrial(
              color: Colors.grey,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.umbrella,
                  color: Colors.blue,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$rainChance %',
            style: GoogleFonts.questrial(
              color: Colors.blue,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSevenDayForecast(String time, int minTemp, int maxTemp,
      IconData weatherIcon, size, bool _isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: _isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: _isDarkMode ? Colors.white38 : Colors.black38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}
