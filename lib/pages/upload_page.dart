import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/cat_upload_res.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';


class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  _apiUploadCat() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });

    var imageFile = File(_image!.path);
    var response = await Network.MUL(Network.API_CAT_UPLOAD, imageFile, Network.paramsEmpty());
    CatUploadRes catUploadRes = Network.parseCatUpload(response!);
    LogService.i(response!);

    setState(() {
      isLoading = false;
    });

    backToFinish();
  }

  backToFinish(){
    Navigator.of(context).pop(true);
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Cat"),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.blue,
                    width: 300,
                    height: 200,
                    child: _image == null
                        ? const Center(child: Text('No image selected.'))
                        : Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {
                          getImageFromGallery();
                        },
                        child: Text("Get Image"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {
                          _apiUploadCat();
                        },
                        child: Text("Upload Cat"),
                      ),
                    ],
                  )
                ],
              ),
            ),

            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SizedBox.shrink(),
          ],
        ));
  }
}