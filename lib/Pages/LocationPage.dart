import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reimagine/Pages/view360.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('360 View')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                data["title"] ?? 'Default Title',
                style: const TextStyle(fontSize: 32),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(data["img"] ?? 'Default Image Path'),
                ),
              ),
              data["view"] ?? false
                  ? InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              View360(imageUrl: data["img"] ?? ''),
                        ),
                      ),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Explore in 360",
                              style: GoogleFonts.juliusSansOne(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Center(
                              child: Icon(
                                FontAwesomeIcons.vrCardboard,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
