// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'VideoPlayerScreen.dart';

class VideoGalleryScreen extends StatelessWidget {
  final List<String> videoAssets = [
    'assets/vid1.mp4',
    'assets/vid2.mp4',
    'assets/vid3.mp4',
    'assets/vid4.mp4',
  ];

  VideoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: videoAssets.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                          videoAsset: videoAssets[index],
                        )),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/img2.jpeg"),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  'Video ${index + 1}',
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
