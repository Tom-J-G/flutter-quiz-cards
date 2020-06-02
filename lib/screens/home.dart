import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:quizCards/widgets/helpers.dart';
import 'package:quizCards/screens/quizCards.dart';

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

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var categories = [];

  int catId;
  int amount;
  String difficulty;

  @override
  void initState() {
    super.initState();
    catId = 9;
    amount = 10;
    difficulty = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Set your quiz cards', textAlign: TextAlign.center),
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(30.0),
                children: <Widget>[
                  
                  fieldLabel(Text("Catgories", style: TextStyle(fontSize: 16.0,))),
                  SizedBox(height: 8.0),
                  FutureBuilder(
                    future: fetchCategories(),
                    builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                      if (snapshot.hasData) {
                        List<Category> categories = snapshot.data;
                        
                        return Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: Theme.of(context).scaffoldBackgroundColor
                            ), child: DropdownButton(
                          isExpanded: true,
                          value: catId,
                        items: categories.map(
                          (Category cat) => DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                            ),
                        ).toList(), 
                        onChanged: (value) =>
                          setState(() => {
                            catId = value
                          })
                        )
                        );
                      } else if(snapshot.hasError) {
                        throw snapshot.error;
                      }
                      else {
                        return DropdownMenuItem(
                          child: Text('Categories'),
                        );
                      }

                    }
                    ),
                    SizedBox(height: 30.0),
                    fieldLabel(Text("Amount", style: TextStyle(fontSize: 16.0,))),
                    SizedBox(height: 8.0),
                    Theme(
                      data: Theme.of(context).copyWith(accentColor: Colors.grey),
                      child: TextField(
                      decoration: InputDecoration(
                        counterText: '',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white60, width: 0.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white60, width: 0.0),
                    ),
                  ),
                      maxLength: 3,
                      onChanged: (value) => {
                        setState(() => {
                          amount = int.parse(value)
                        })
                        },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    ),
                    ),
                    SizedBox(height: 40.0),
                    fieldLabel(Text("Difficulty", style: TextStyle(fontSize: 16.0,))),
                    SizedBox(height: 8.0),
                    Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: Theme.of(context).scaffoldBackgroundColor
                            ), child: DropdownButton(
                      value: difficulty,
                      items: [
                        DropdownMenuItem(child: Text('All'), value: '',),
                        DropdownMenuItem(child: Text('Easy'), value: 'easy',),
                        DropdownMenuItem(child: Text('Medium'), value: 'medium',),
                        DropdownMenuItem(child: Text('Hard'), value: 'hard',)
                      ], 
                      onChanged: (value) => setState(() => {
                        difficulty = value
                      })),
                      )
                ],

              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context, 
        MaterialPageRoute(
          builder: (context) => QuizCards(
            catId: catId,
            amount: amount,
            difficulty: difficulty,
          )
        )
          )

        }
      ),

    );
  }
}