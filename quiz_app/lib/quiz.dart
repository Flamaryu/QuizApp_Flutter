import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/models/quiz_question.dart';
import 'package:quiz_app/views/questions_screen.dart';
import 'package:quiz_app/views/start_screen.dart';
import 'views/results_screen.dart';
import 'package:quiz_app/models/new_questions.dart';

import 'package:http/http.dart' as http;

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Widget? activeScreen;
  List<String> selectedanswers = [];
  bool callSuccess = false;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  bool _isQuizStarted = false;
  List<QuizQuestion> questions = [];
  String _mode = '';
  String _category = '';

  void createAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  void onRestart() {
    selectedanswers = [];
    callSuccess = false;
    _isQuizStarted = false;
    questions = [];
    _mode = '';
    _category = '';
    setState(() {
      activeScreen = StartScreen(quizStart);
    });
  }

  quizStart() async {
    _isQuizStarted = isQuisStart;
    if (_isQuizStarted) {
      final random = Random();
      _mode = mode!;
      _category = catergory!;
      // Generate a random number between 10 and 50.
      int randomNumber = random.nextInt(20 - 10) + 10;
      String url =
          'https://opentdb.com/api.php?amount=$randomNumber$_category$_mode';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      questions = questionsFromJson(body).getQuestions();
      switchScreen();
    }
  }

  @override
  void initState() {
    activeScreen = StartScreen(quizStart);
    super.initState();
    createAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  switchScreen() {
    setState(() {
      activeScreen = QuestionScreen(
        onSelectAnswer: chooseAnswer,
        questionsC: questions,
      );
    });
  }

  void chooseAnswer(String answer) {
    selectedanswers.add(answer);

    if (selectedanswers.length == questions.length) {
      setState(() {
        activeScreen = ResultsScreen(
          chosenAnswers: selectedanswers,
          questions: questions,
          onRestart: onRestart,
        );
      });
    }
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: _isAdLoaded
            ? SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(
                  ad: _bannerAd,
                ),
              )
            : null,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF572ACD), Color(0xFF280C7E)],
              begin: Alignment.topLeft,
            ),
          ),
          child: activeScreen,
        ),
      ),
    );
  }
}
