// A simple full-screen 360° viewer that accepts a network image URL.
// Replaces the previous asset-only implementation and fixes layout issues.
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class View360 extends StatelessWidget {
  const View360({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('360° View')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: PanoramaViewer(
          animReverse: false,
          zoom: -10,
          interactive: true,
          sensorControl: SensorControl.orientation,
          child: imageUrl.toLowerCase().startsWith('http')
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 56,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            const Text('Failed to load panorama image.'),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              : Image.asset(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
