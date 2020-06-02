import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

import 'package:quizCards/screens/home.dart';
import 'package:quizCards/screens/quizCard.dart';
import 'package:quizCards/widgets/helpers.dart';

Future<List<QuizData>> fetchQuizData(int id, int amount, String difficulty) async {
  final response = await http.get('https://opentdb.com/api.php?amount=$amount&category=$id&difficulty=$difficulty');
  
  if (response.statusCode == 200 ) {
    Map<String, dynamic> map= jsonDecode(response.body);
    List<dynamic> body = map['results'];
    List<QuizData> cards = body.map(
      (dynamic item) => QuizData.fromJson(item),
    ).toList();
    return cards;
  } else {
    throw Exception('Failed to fetch categories');
  }
}

class QuizData {
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List incorrectAnswers;

  QuizData({this.difficulty, this.question, this.correctAnswer, this.incorrectAnswers});
  
  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      difficulty: json['difficulty'],
      incorrectAnswers: json['incorrect_answers']
    );
  }
}

class QuizCards extends StatefulWidget {
  QuizCards({Key key, this.title, this.catId, this.amount, this.difficulty}) : super(key: key);

  final int catId;
  final int amount;
  final String difficulty;
  final String title;

  @override
  _QuizCards createState() => _QuizCards();
}

class _QuizCards extends State<QuizCards> {
  Widget front;

  final quizcards = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Cards')
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(30.0),
        children: <Widget>[
          FutureBuilder(
            future: fetchQuizData(widget.catId, widget.amount, widget.difficulty),
            builder: (BuildContext context, AsyncSnapshot<List<QuizData>> snapshot) {
              if (snapshot.hasData) {
                var htmlFix = HtmlUnescape();
                List<QuizData> cards = snapshot.data;
                List<String> possibleAnswers;
                for( var item in cards) {
                  possibleAnswers = List<String>.from(item.incorrectAnswers);
                  possibleAnswers.insert(1,item.correctAnswer);
                  possibleAnswers.map((x) => x = htmlFix.convert(x));
                  possibleAnswers.shuffle();

                  quizcards.add(QuizCard(
                      question: htmlFix.convert(item.question),
                      answer: htmlFix.convert(item.correctAnswer),
                      difficulty: item.difficulty,
                      possibleAnswers: possibleAnswers,      
                    )
                  );
                  quizcards.add(SizedBox(height:20));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: quizcards
                );
              } else if(snapshot.hasError) {
                throw snapshot.error;
              } else {
                return Container();
              }
            })
        ],
      )
    );
  }
}