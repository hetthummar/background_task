import 'dart:async';
import 'dart:ui';
import 'package:background_task/firebase_options.dart';
import 'package:background_task/model/area_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tools;

Future<void> initServices() async {
  var service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration:
        IosConfiguration(onBackground: iosBackground, onForeground: onStart),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: "Coding is life",
      initialNotificationContent: "Awsome Content",
      foregroundServiceNotificationId: 90,
    ),
  );
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

Future<void> addUserCurrentLocation(
    {required double lat, required double long}) async {
  CollectionReference userLocationCollectionRefrence =
      FirebaseFirestore.instance.collection('userLocation');
  Map<String, dynamic> data = {
    "image":
        "https://imgs.search.brave.com/fhCtnw0W_kGbpvMpeuEoFoBmIoPytRsESW7AY93x9OQ/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/ZnJlZS1waG90by9v/bGQtbWFuLXN0cnVn/Z2xpbmctd2l0aC1o/aWdoLXRlbXBlcmF0/dXJlXzIzLTIxNDk0/NTY3NDQuanBnP3Np/emU9NjI2JmV4dD1q/cGc",
    "name": "Semil",
    "lat": lat,
    "long": long
  };
  await userLocationCollectionRefrence.doc("Semil").set(data);
}

Future<void> checkUserAreaInOrOut(
    {required LatLng pointLatLng, required List<Area> polyGonArea}) async {
  List<map_tools.LatLng> convertedPolygonPoints = polyGonArea
      .map(
        (e) => map_tools.LatLng(e.lat, e.long),
      )
      .toList();
  bool isSelectedArea = map_tools.PolygonUtil.containsLocation(
      map_tools.LatLng(pointLatLng.latitude, pointLatLng.longitude),
      convertedPolygonPoints,
      false);

  CollectionReference userLocationCollectionRefrence =
      FirebaseFirestore.instance.collection('locationMessage');

  await userLocationCollectionRefrence.doc("Semil").set(
    {
      "name": "Semil",
      "time": DateTime.now().toString(),
      "Message": isSelectedArea ? "Area" : "User out Of area"
    },
  );
}

Future<List<Area>> getArea() async {
  try {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('area')
        .doc("selectedArea")
        .get();
    List<Area> selectedArea = [];
    if (a.exists) {
      Map<String, dynamic>? fetchDoc = a.data() as Map<String, dynamic>?;
      selectedArea = AreaModel.fromJson(fetchDoc!).area;
    }
    return selectedArea;
  } catch (e) {
    return [];
  }
}

@pragma('vm:entry-point')
void onStart(
  ServiceInstance service,
) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  double longitude = 0;
  double latitude = 0;
  List<Area> selectedArea = [];

  service.on('start_service').listen((event) async {
    print("Start Service ======>");
  });

  service.on('setAsForeground').listen((event) async {});

  service.on('setAsBackground').listen((event) async {});

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });
  print("Hello =====>");

  // bring to foreground
  Timer.periodic(
    const Duration(seconds: 6),
    (timer) async {
      final location = await _determinePosition();

      if (longitude != location.longitude || latitude != location.latitude) {
        longitude = location.longitude;
        latitude = location.latitude;

        await addUserCurrentLocation(
            lat: location.latitude, long: location.longitude);
      }
    },
  );

  Timer.periodic(
    const Duration(seconds: 8),
    (timer) async {
      selectedArea = await getArea();
      await checkUserAreaInOrOut(
          pointLatLng: LatLng(latitude, longitude), polyGonArea: selectedArea);
    },
  );
}
