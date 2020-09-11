import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final List<CameraDescription> cameras;

  MyHomePage({
    Key key,
    this.title,
    this.cameras,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _controller;
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _loadDeviceCamera() {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }

  Future<String> _startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    // setState(() {
    //   _isRecording = true;
    // });
    // _timerKey.currentState.startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media/bipolar';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (error) {
      print(error);
      return null;
    }
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pixabay'),
              Tab(text: 'Local'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.photo),
            Icon(Icons.videocam),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () => _startVideoRecording(),
        ),
      ),
    );
  }
}
