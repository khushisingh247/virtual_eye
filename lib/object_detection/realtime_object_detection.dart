import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RealTimeObjectDetection extends StatefulWidget {
  final List<CameraDescription> cameras;

  RealTimeObjectDetection({required this.cameras});

  @override
  _RealTimeObjectDetectionState createState() => _RealTimeObjectDetectionState();
}

class _RealTimeObjectDetectionState extends State<RealTimeObjectDetection> {
  late CameraController _controller;
  bool isModelLoaded = false;
  List<dynamic>? recognitions;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera(null);
    initializeTts();
  }

  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(1);
    print("TTS Initialized with faster speech rate");
  }

  Future<void> speak(String text) async {
    print("Speaking: $text");
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/detect.tflite',
      labels: 'assets/labelmap.txt',
    );
    setState(() {
      isModelLoaded = res != null;
      print("Model Loaded: $isModelLoaded");
    });
  }

  void toggleCamera() {
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = widget.cameras.firstWhere(
              (description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = widget.cameras.firstWhere(
              (description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      initializeCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  void initializeCamera(CameraDescription? description) async {
    _controller = CameraController(
      description ?? widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller.initialize();

    if (!mounted) {
      return;
    }
    _controller.startImageStream((CameraImage image) {
      if (isModelLoaded) {
        runModel(image);
      }
    });
    setState(() {});
  }

  void runModel(CameraImage image) async {
    if (image.planes.isEmpty) return;

    var recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      model: 'SSDMobileNet',
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      var detectedObject = recognitions.first["detectedClass"];
      var confidence = (recognitions.first["confidenceInClass"] * 100).toStringAsFixed(0);

      print("Detected: $detectedObject with confidence: $confidence%");

      await speak(" $detectedObject ");
    }

    setState(() {
      this.recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Object Detection'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                CameraPreview(_controller),
                if (recognitions != null)
                  BoundingBoxes(
                    recognitions: recognitions!,
                    previewH: _controller.value.previewSize?.height ?? 0,
                    previewW: _controller.value.previewSize?.width ?? 0,
                    screenH: MediaQuery.of(context).size.height * 0.8,
                    screenW: MediaQuery.of(context).size.width,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: toggleCamera,
                icon: const Icon(
                  Icons.camera_front,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BoundingBoxes extends StatelessWidget {
  final List<dynamic> recognitions;
  final double previewH;
  final double previewW;
  final double screenH;
  final double screenW;

  BoundingBoxes({
    required this.recognitions,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: recognitions.map((rec) {
        var x = rec["rect"]["x"] * screenW;
        var y = rec["rect"]["y"] * screenH;
        double w = rec["rect"]["w"] * screenW;
        double h = rec["rect"]["h"] * screenH;

        return Positioned(
          left: x,
          top: y,
          width: w,
          height: h,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3,
              ),
            ),
            child: Text(
              "${rec["detectedClass"]} ${(rec["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 15,
                backgroundColor: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
