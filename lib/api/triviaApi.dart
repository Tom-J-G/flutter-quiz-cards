import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

Future<List<Category>> fetchCategories() async {
  final response = await http.get('https://opentdb.com/api_category.php');

  if (response.statusCode == 200 ) {
    Map<String, dynamic> map= jsonDecode(response.body);
    List<dynamic> body = map['trivia_categories'];
    List<Category> categories = body.map(
      (dynamic item) => Category.fromJson(item),
    ).toList();
    return categories;
  } else {
    throw Exception('Failed to fetch categories');
  }

}

class Category {
  final int id;
  final String name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

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