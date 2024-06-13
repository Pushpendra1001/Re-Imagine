import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';

const apiKey = "AIzaSyC3kYsHcBQPJxQEg7NlnDOdfOoVJUcLtVA";

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Shakti Assistence"),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Ask Your Doubt"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                TextOnly(),
              ],
            )));
  }
}

class TextOnly extends StatefulWidget {
  const TextOnly({
    super.key,
  });

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = false;
  List textChat = [];

  List textWithImageChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final prompt1 = """
  SS Jain Subodh PG College, located in Jaipur, Rajasthan, India, is an esteemed institution that has achieved remarkable milestones in its journey. Accredited with an ‘A++’ Grade (3.82 CGPA) by NAAC-UGC, it stands as a beacon of excellence in education. Here are some key highlights:

Autonomous Status: SS Jain Subodh PG College operates autonomously, allowing it to design and offer innovative courses tailored to the needs of students.
NIRF Ranking: The college secured a rank between 101 and 150 in the “India Rankings 2023: College” by the National Institutional Ranking Framework (NIRF), under the Ministry of Education, Government of India.
College of Excellence: Recognized by the University Grants Commission (UGC), the college has been awarded the prestigious status of a “College of Excellence.”
DBT Star College: The Department of Biotechnology (DBT), Government of India, has bestowed the college with the “STAR STATUS”, acknowledging its commitment to quality education and research.
Mentor for NAAC Accreditation: SS Jain Subodh PG College serves as a mentor to other colleges aspiring for NAAC accreditation, contributing to the enhancement of higher education standards.
Vision and Values: The college aims to produce conscientious and confident citizens who contribute positively to society. It fosters empathy, kindness, and ethical awareness among students.
Balanced Environment: With competent faculty, state-of-the-art infrastructure, and a supportive management, the college provides a safe and nurturing environment. It encourages a harmonious blend of academics, sports, arts, and social engagement.
At SS Jain Subodh PG College, the pursuit of knowledge is not just a duty; it is a passion that shapes the future of its students. 🎓🌟
  
  """;
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Shakti",
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Shakti",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: textChat.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(""),
                ),
                title: Text(textChat[index]["role"]),
                subtitle: Text(textChat[index]["text"]),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    fillColor: Colors.transparent,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              IconButton(
                icon: loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () {
                  fromText(query: _textController.text);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
