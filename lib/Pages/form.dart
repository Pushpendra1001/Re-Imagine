import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadLocationPage extends StatefulWidget {
  @override
  _UploadLocationPageState createState() => _UploadLocationPageState();
}

class _UploadLocationPageState extends State<UploadLocationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String locationName = "Not Found";
  String locationDescription = "Not Found";
  Uint8List? _coverImage;
  List<Uint8List> _360Images = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      return await image.readAsBytes();
    }
    throw 'No image selected';
  }

  void _selectCoverImage(BuildContext context) async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery);
      setState(() {
        _coverImage = file;
      });
    } catch (e) {}
  }

  void _select360Image(BuildContext context) async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery);
      if (_360Images.length < 5) {
        setState(() {
          _360Images.add(file);
        });
      }
    } catch (e) {}
  }

  void _uploadLocation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      String coverImageUrl = await uploadImageToFirebase(_coverImage!);
      List<String> urls360 = [];
      for (var image in _360Images) {
        String url = await uploadImageToFirebase(image);
        urls360.add(url);
      }

      await FirebaseFirestore.instance.collection('locations').add({
        'name': locationName,
        'description': locationDescription,
        'coverImage': coverImageUrl,
        '360Images': urls360,
      });

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToFirebase(Uint8List imageData) async {
    print("Starting upload...");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
      'uploads/$fileName',
    );
    UploadTask uploadTask = firebaseStorageRef.putData(imageData);
    uploadTask.snapshotEvents.listen(
      (TaskSnapshot snapshot) {
        print('Task state: ${snapshot.state}');
        print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %',
        );
      },
      onError: (e) {
        print(uploadTask.snapshot);
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      },
    );

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload New Location')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name of Place'),
                    onSaved: (value) => locationName = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description of Place',
                    ),
                    onSaved: (value) => locationDescription = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectCoverImage(context),
                    child: Text('Select Cover Image'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _select360Image(context),
                    child: Text('Add 360 View Image'),
                  ),
                  ElevatedButton(
                    onPressed: _uploadLocation,
                    child: Text('Upload Location'),
                  ),
                ],
              ),
            ),
    );
  }
}
