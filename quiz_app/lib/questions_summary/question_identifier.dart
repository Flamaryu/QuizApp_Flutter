import 'package:flutter/material.dart';

class QuestionIdentifier extends StatelessWidget {
  const QuestionIdentifier(
      {required this.questionIndex, required this.isCorrectAnswer, super.key});

  final int questionIndex;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    final questionNum = questionIndex + 1;

    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCorrectAnswer
            ? const Color.fromARGB(255, 6, 181, 6)
            : const Color.fromARGB(255, 192, 7, 7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        questionNum.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
