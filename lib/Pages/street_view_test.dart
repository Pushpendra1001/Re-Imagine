// A simple page to test Google Street View Static API using an API key
import 'package:flutter/material.dart';

class StreetViewTestPage extends StatefulWidget {
  const StreetViewTestPage({super.key});

  @override
  State<StreetViewTestPage> createState() => _StreetViewTestPageState();
}

class _StreetViewTestPageState extends State<StreetViewTestPage> {
  final TextEditingController _keyController = TextEditingController();
  String? _imageUrl;
  String? _error;

  // Example coordinates: Eiffel Tower
  static const double _lat = 48.8584;
  static const double _lng = 2.2945;

  void _loadStreetView() {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _error = 'Please enter an API key';
        _imageUrl = null;
      });
      return;
    }

    // Construct Street View Static API URL
    final url = Uri.https('maps.googleapis.com', '/maps/api/streetview', {
      'size': '640x640',
      'location': '$_lat,$_lng',
      'fov': '90',
      'heading': '0',
      'pitch': '0',
      'key': key,
    }).toString();

    setState(() {
      _imageUrl = url;
      _error = null;
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Street View API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your Google Maps API key below and tap "Load Street View".\nThis uses the Street View Static API to fetch an image for a sample location (Eiffel Tower).',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loadStreetView,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Load Street View'),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_imageUrl != null)
              Expanded(
                child: Center(
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Failed to load image. The API key may be invalid or the request blocked.',
                            ),
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
                      );
                    },
                    // show a simple loading indicator while fetching
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
