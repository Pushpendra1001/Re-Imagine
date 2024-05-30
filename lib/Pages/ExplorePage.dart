// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:reimagine/Common/data.dart';
import 'package:reimagine/Pages/LocationPage.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Explore'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
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
                            ));
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
