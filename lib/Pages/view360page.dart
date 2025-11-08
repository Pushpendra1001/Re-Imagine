import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:reimagine/Common/data.dart';

class View360Page extends StatefulWidget {
  const View360Page({
    super.key,
  });

  @override
  _View360State createState() => _View360State();
}

class _View360State extends State<View360Page> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('360° View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: paths.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PanoramaViewer(
                    animReverse: false,
                    zoom: -10,
                    child: Image.asset(
                      paths[index],
                      fit: BoxFit.cover,
                    ),
                    interactive: true,
                    sensorControl: SensorControl.orientation,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0
                    ? () {
                        setState(() {
                          currentIndex--;
                          pageController.animateToPage(currentIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        });
                      }
                    : null,
                child: Text('Previous'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: currentIndex < paths.length - 1
                    ? () {
                        setState(() {
                          currentIndex++;
                          pageController.animateToPage(currentIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        });
                      }
                    : null,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
