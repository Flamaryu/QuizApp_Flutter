import 'package:flutter/material.dart';

const List<String> list = <String>[
  "General knowledge",
  'Entertainment: Books',
  'Entertainment: TV',
  'Entertainment: Music',
  'Entertainment: Video Games',
  'Science & Nature',
  'Mythology',
  'Sports',
  'History',
  'Politics'
];

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownList(),
      ]),
    );
  }

  void dropdownCallBack(String? value) {
    if (value is String) {}
  }
}

class DropdownList extends StatefulWidget {
  const DropdownList({super.key});

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 43,
      iconEnabledColor: const Color.fromARGB(255, 232, 89, 137),
      elevation: 20,
      dropdownColor: const Color(0xFF3d61e5),
      borderRadius: BorderRadius.circular(20),
      style: const TextStyle(color: Color.fromARGB(255, 66, 237, 77)),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
