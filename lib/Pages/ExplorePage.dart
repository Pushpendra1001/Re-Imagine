import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reimagine/Common/data.dart';
import 'package:reimagine/Pages/LocationPage.dart';
import 'package:reimagine/Pages/view360.dart';
import 'package:http/http.dart' as http;

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _apiKey;
  String? _thumbnailUrl;
  String? _searchPlace;
  bool _loading = false;

  static String _streetViewUrl(
    double lat,
    double lng,
    String key, {
    int size = 640,
  }) {
    final params = {
      'size': '${size}x$size',
      'location': '$lat,$lng',
      'fov': '100',
      'heading': '0',
      'pitch': '0',
      'key': key,
    };
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/streetview',
      params,
    );
    return uri.toString();
  }

  Future<void> _searchPlaceAndFetch(String query) async {
    if ((_apiKey ?? '').isEmpty) {
      _showApiKeyDialog();
      return;
    }

    setState(() {
      _loading = true;
      _thumbnailUrl = null;
      _searchPlace = query;
    });

    try {
      final geocodeUri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': query, 'key': _apiKey!},
      );

      final resp = await http
          .get(geocodeUri)
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) {
        throw Exception('Geocoding request failed: ${resp.statusCode}');
      }
      final body = json.decode(resp.body) as Map<String, dynamic>;
      if ((body['results'] as List).isEmpty) {
        throw Exception('No results found');
      }
      final location = body['results'][0]['geometry']['location'];
      final lat = (location['lat'] as num).toDouble();
      final lng = (location['lng'] as num).toDouble();

      final thumb = _streetViewUrl(lat, lng, _apiKey!);

      setState(() {
        _thumbnailUrl = thumb;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showApiKeyDialog() {
    final TextEditingController c = TextEditingController(text: _apiKey ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Google API Key'),
          content: TextField(
            controller: c,
            decoration: const InputDecoration(hintText: 'Enter Maps API key'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _apiKey = c.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Explore'),
          actions: [
            IconButton(
              onPressed: _showApiKeyDialog,
              icon: const Icon(Icons.vpn_key),
              tooltip: 'Set Google API Key',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search a place (e.g. Taj Mahal)',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (v) => _searchPlaceAndFetch(v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () => _searchPlaceAndFetch(
                            _searchController.text.trim(),
                          ),
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // If thumbnail available, show preview and Imagine button
              if (_thumbnailUrl != null)
                Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          _thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Center(
                            child: Text('Failed to load thumbnail: $e'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(_searchPlace ?? 'Selected location'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Open full screen 360 view
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        View360(imageUrl: _thumbnailUrl!),
                                  ),
                                );
                              },
                              child: const Text('Imagine'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              const SizedBox(height: 20),

              // Existing gallery below
              Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: wtpImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LocationPage(data: wtpImages[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                wtpImages[index]["img"].toString(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  wtpImages[index]["title"].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
