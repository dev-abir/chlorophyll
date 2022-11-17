import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  List _output = [];
  final picker = ImagePicker();
  String _statusText = "Take an image from camera, or pick one from gallery";

  @override
  void initState() {
    super.initState();

    Tflite.loadModel(
      model: 'assets/model/model.tflite',
      labels: 'assets/model/labels.txt',
    ).then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  void classifyImage(File image) async {
    // TODO: what does the params in runModelOnImage() do?
    // TODO: load numResults from the model?
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 39, //the amout of categories our neural network can predict
      // threshold: 0.5,
      // imageMean: 127.5,
      // imageStd: 127.5,
      threshold: 0.2,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    setState(() {
      if (output != null) {
        _output = output;
        _loading = false;
        _statusText = '${_output[0]['label']}';
      }
    });
  }

  void takeImageFromCam() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      _statusText = "Loading results...";
    });
    classifyImage(_image);
  }

  void pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      _statusText = "Loading results...";
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chlorophyll"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _loading
                        ? const Text("No image selected!")
                        : Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    _statusText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: takeImageFromCam,
                      icon: const Icon(Icons.camera),
                      iconSize: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      onPressed: pickGalleryImage,
                      icon: const Icon(Icons.image),
                      iconSize: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
