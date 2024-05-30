import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reimagine/Pages/videoGallery.dart';
import 'package:reimagine/Pages/view360page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Re-Imagine',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 28,
            // fontWeight: FontWeight.bold,

            letterSpacing: 3.0,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
            color: Colors.teal,
            decoration: TextDecoration.none,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.asset(
                fit: BoxFit.cover,
                "assets/main2.webp",
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Re-Imagine is a cutting-edge VR experience tour app designed to transport users to popular destinations, renowned colleges, and iconic landmarks around the world. With Re-Imagine, users can explore these locations in stunning 360-degree views, enhanced by intuitive gyroscope interactions for a fully immersive experience. Whether you're planning your next vacation or researching potential universities, Re-Imagine offers a unique and engaging way to see the world from the comfort of your home. Discover the future of virtual tourism with Re-Imagine.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const View360Page(),
                      ));
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.teal[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Explore in 360",
                    style: GoogleFonts.juliusSansOne(
                        textStyle:
                            const TextStyle(fontSize: 24, color: Colors.white)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
