import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quizCards/screens/home.dart';

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
  final List possibleAnswers;

  QuizData({this.difficulty, this.question, this.correctAnswer, this.possibleAnswers});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    List possibleAnswers = json['incorrect_answers'];
    possibleAnswers.add(json['answer']);
    possibleAnswers.shuffle();
    return QuizData(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      difficulty: json['difficulty'],
      possibleAnswers: possibleAnswers
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
                List<QuizData> cards = snapshot.data;
                for( var item in cards) {
                  var front;
                  var back;
                  quizcards.add(Container(
                    width: 200,
                      child: Column(
                        
                        children: <Widget>[
                          Text(item.question),
                          Container(
                            child: Column(
                              children: <Widget>[])
                          )
                        ]
                      )
                  ));
                }
                return Column(
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