import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  List _output;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.3);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    return Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.002, 1],
              colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)]),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                'Detect flowers',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
              Text(
                'By CNN with tensorflow',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7),
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Image.asset('assets/flower.png'),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 250,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _output != null
                                        ? Text(
                                            'Prediction is ${_output[0]['label']}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Take a photo',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: pickGalleryImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Pick a photo',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
