import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';

class VirtualVideo extends StatefulWidget {
  @override
  _VirtualVideoState createState() => _VirtualVideoState();
}

class _VirtualVideoState extends State<VirtualVideo> {
  Video360Controller? controller;

  String durationText = '';
  String totalText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).padding.top;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Video360View(
      onVideo360ViewCreated: _onVideo360ViewCreated,
      url:
          "https://bitmovin-a.akamaihd.net/content/playhouse-vr/m3u8s/105560.m3u8",
      isRepeat: true, // defalut : false
      onPlayInfo: (Video360PlayInfo info) {
        // Play info Callback
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Video in 360 '),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: width,
              height: height,
              child: Video360View(
                onVideo360ViewCreated: _onVideo360ViewCreated,
                url:
                    'https://bitmovin-a.akamaihd.net/content/playhouse-vr/m3u8s/105560.m3u8',
                onPlayInfo: (Video360PlayInfo info) {
                  setState(() {
                    durationText = info.duration.toString();
                    totalText = info.total.toString();
                  });
                },
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller?.play();
                    },
                    color: Colors.grey[100],
                    child: Text('Play'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      controller?.stop();
                    },
                    color: Colors.grey[100],
                    child: Text('Stop'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      controller?.reset();
                    },
                    color: Colors.grey[100],
                    child: Text('Reset'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      controller?.jumpTo(80000);
                    },
                    color: Colors.grey[100],
                    child: Text('1:20'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller?.seekTo(-2000);
                    },
                    color: Colors.grey[100],
                    child: Text('<<'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      controller?.seekTo(2000);
                    },
                    color: Colors.grey[100],
                    child: Text('>>'),
                  ),
                  Flexible(
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.grey[100],
                      child: Text(durationText + ' / ' + totalText),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  _onVideo360ViewCreated(Video360Controller? controller) {
    this.controller = controller;
    this.controller?.play();
  }
}
