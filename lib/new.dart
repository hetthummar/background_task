import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initServices() async {
  var service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration:
          IosConfiguration(onBackground: iosBackground, onForeground: onStart),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          // notificationChannelId: "coding is life", //comment this line if show white screen and app crash
          initialNotificationTitle: "Coding is life",
          initialNotificationContent: "Awsome Content",
          foregroundServiceNotificationId: 90));
  service.startService();
}

@pragma("vm:entry-point")
Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

@pragma('vm:entry-point')
void onStart(
  ServiceInstance service,
) async {
  double longitude = 0;
  double latitude = 0;

  service.on('start_service').listen((event) async {});

  service.on('setAsForeground').listen((event) async {});

  service.on('setAsBackground').listen((event) async {});

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    final location = await _determinePosition();
    if (longitude != location.longitude || latitude != location.latitude) {
      longitude = location.longitude;
      latitude = location.latitude;
      print("+++++++++BACKGROUND LOCATION++++++++");
      print(location.latitude);
      print(location.longitude);
      await savaUserModelData("DATE TIME: ${DateTime.now()} Location: $location");
    }
  });
}

@pragma('vm:entry-point')
Future<bool> savaUserModelData(String value) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cntKey", value);
    return true;
  } catch (e) {
    return false;
  }
}