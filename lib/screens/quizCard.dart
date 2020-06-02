import 'package:flutter/material.dart';

import 'package:quizCards/widgets/flippable.dart';

class QuizCard extends StatefulWidget {
  final String question;
  final List<String> possibleAnswers;
  final String answer;
  final String difficulty;

  const QuizCard({Key key, this.question, this.possibleAnswers, this.answer, this.difficulty}) : super(key: key);

  @override
  _QuizCard createState() => _QuizCard();

}

class _QuizCard extends State<QuizCard> {
  bool _isFlipped;

  @override
  void initState() {
    
    super.initState();
    _isFlipped = false;
  }

  @override
  Widget build(BuildContext context) {
    Container front = Container(
      width: 250,
      height: 350,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.question, style: TextStyle(color: Colors.black45)),
          SizedBox(height:10),
          Column(
            children: widget.possibleAnswers.map(
              (x) => Text(x , style: TextStyle(color: Colors.black45))
            ).toList(),
          )
        ]
      ),
    );

    Container back = Container(
      width: 250,
      height: 350,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(widget.answer, style: TextStyle(color: Colors.black45))
      ),
    );
    return GestureDetector(
      onTap: () => setState(() => _isFlipped = !_isFlipped),
      child: FlippableBox(
        front: front,
        back: back,
        bg: BoxDecoration(color: Colors.white),
        isFlipped: _isFlipped,
    )
    );
  }
}