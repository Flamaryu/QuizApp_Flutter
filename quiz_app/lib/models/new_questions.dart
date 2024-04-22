// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:quiz_app/models/quiz_question.dart';

NewQuestions questionsFromJson(String str) =>
    NewQuestions.fromJson(json.decode(str));

String questionsToJson(NewQuestions data) => json.encode(data.toJson());

class NewQuestions {
  int responseCode;
  List<Result> results;

  NewQuestions({
    required this.responseCode,
    required this.results,
  });
  List<QuizQuestion> getQuestions() {
    List<QuizQuestion> questions = [];
    for (var v = 0; v < results.length; v++) {
      var question = results[v].question;
      var unescape = HtmlUnescape();
      var formattedQuestion = unescape.convert(question);
      var correctAnswer = results[v].correctAnswer;
      var wrongAnswers = results[v].incorrectAnswers;
      for (int i = 0; i < wrongAnswers.length; i++) {
        wrongAnswers[i] = unescape.convert(wrongAnswers[i]);
      }
      List<String> answers = [];
      answers.add(correctAnswer);
      answers.addAll(wrongAnswers);
      questions.add(QuizQuestion(formattedQuestion, answers));
    }
    return questions;
  }

  factory NewQuestions.fromJson(Map<String, dynamic> json) => NewQuestions(
        responseCode: json["response_code"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Result({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        question: json["question"],
        correctAnswer: json["correct_answer"],
        incorrectAnswers:
            List<String>.from(json["incorrect_answers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "correct_answer": correctAnswer,
        "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
      };
}
