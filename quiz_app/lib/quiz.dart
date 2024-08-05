import 'dart:async';
import 'dart:io';
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
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isQuizStarted = false;
  List<QuizQuestion> questions = [];
  String _mode = '';
  String _category = '';

  String? _message;

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1126514114907751/1969879520',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _bannerAd = ad as BannerAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _bannerAd!.load();
  }

  void onRestart() {
    //makes sure all needed verables are cleared and reset game
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
      // Generate a random number between 10 and 25.
      int randomNumber = random.nextInt(25 - 10) + 10;
      try {
        String url =
            'https://opentdb.com/api.php?amount=$randomNumber$_category$_mode';
        final uri = Uri.parse(url);
        final response =
            await http.get(uri).timeout(const Duration(seconds: 3));
        final body = response.body;
        questions = questionsFromJson(body).getQuestions();
        switchScreen();
      } on TimeoutException catch (_) {
        _message = 'Sever Timed aout try again';
        _showToast(context);
      } on SocketException catch (_) {}
      _message = 'No interet connection';
      _showToast(context);
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        dismissDirection: DismissDirection.endToStart,
        content: Text('Alert:$_message'),
      ),
    );
  }

  @override
  void initState() {
    activeScreen = StartScreen(quizStart);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF572ACD), Color(0xFF280C7E)],
              begin: Alignment.topLeft,
            ),
          ),
          child: Stack(
            children: <Widget>[
              activeScreen!,
              if (_bannerAd != null && _isAdLoaded)
                Container(
                  color: Colors.green,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
            ],
          ),
        ),
      ),
    );
  }
}
