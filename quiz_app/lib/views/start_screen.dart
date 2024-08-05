import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const Map<String, String> cList = {
  'General knowledge': '&category=9',
  'Entertainment: Books': '&category=10',
  'Entertainment: TV': '&category=12',
  'Entertainment: Music': '&category=14',
  'Entertainment: Video Games': '&category=15',
  'Science & Nature': '&category=17',
  'Mythology': '&category=20',
  'Sports': '&category=21',
  'History': '&category=23',
  'Politics': '&category=24'
};

const Map<String, String> dList = {
  'Easy': '&difficulty=easy',
  'Medium': '&difficulty=medium',
  'Hard': '&difficulty=hard'
};
String? selectedItem;
String? selected2;
String? catergory;
String? mode;
bool isQuisStart = false;

class StartScreen extends StatefulWidget {
  const StartScreen(
    this.startQuiz, {
    super.key,
  });

  final Function() startQuiz;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  void dropdownCallBack(String value) {}

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/icon.png',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 50),
          const Text(
            " So you know some things?!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const Text(
            " We'll see!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          DropdownButton(
            isExpanded: true,
            value: selectedItem,
            padding: const EdgeInsets.all(20),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 43,
            iconEnabledColor: const Color.fromARGB(255, 232, 89, 137),
            elevation: 20,
            dropdownColor: const Color(0xFF3d61e5),
            borderRadius: BorderRadius.circular(40),
            style: const TextStyle(color: Color.fromARGB(255, 66, 237, 77)),
            hint: const Text("Select Catagory"),
            alignment: Alignment.center,
            items: cList.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                selectedItem = value!;
                catergory = cList[value];
                print(catergory);
              });
            },
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: selected2,
            padding: const EdgeInsets.all(20),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 43,
            iconEnabledColor: const Color.fromARGB(255, 232, 89, 137),
            elevation: 20,
            dropdownColor: const Color(0xFF3d61e5),
            borderRadius: BorderRadius.circular(40),
            style: const TextStyle(color: Color.fromARGB(255, 66, 237, 77)),
            items: dList.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                selected2 = value!;
                mode = dList[value];
                print(mode);
              });
            },
            hint: const Text("Select Difficulty"),
            alignment: Alignment.center,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () async {
              bool result = await InternetConnectionChecker().hasConnection;
              if (result == true) {
                if (mode != null && catergory != null) {
                  isQuisStart = true;
                  widget.startQuiz();
                } else {
                  _showToast(context,
                      " Need to pick a category/Difficulty to start game");
                }
              } else {
                _showToast(context, "Need internet to load questions");
              }
            },
            icon: const Icon(Icons.arrow_right),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            label: const Text('Start, Quiz'),
          )
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        dismissDirection: DismissDirection.endToStart,
        content: Text(message),
      ),
    );
  }
}
