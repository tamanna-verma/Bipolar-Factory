import 'package:bipolar_factory_assignment/home_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  List<CameraDescription> cameras;
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  MyApp({this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bipolar Factory',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(
        title: 'Bipolar Factory',
        cameras: cameras,
      ),
    );
  }
}
