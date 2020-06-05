import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';

import 'package:quizCards/screens/quizCard.dart';
import 'package:quizCards/api/triviaApi.dart';

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