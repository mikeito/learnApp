import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var finalScore = 0;
var questionNumber = 0;

class Quiz extends StatefulWidget {
  Quiz({Key key, this.token, this.subject}) : super(key: key);

  final String token;
  final String subject;

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {

  var questions = [];
  var choices = [];
  var correctAnswers = [];

  int timeTrack = 0;

  Stream<List> _fetchQuiz() async* {
    final String url = "https://wsc.bixterprise.com/api/qcm";
    final String _token = widget.token;

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    //print(response);
    var responseJson = json.decode(response.body);
    //print(responseJson);
    //print(responseJson['data']);

    for (var s in responseJson['data']) {
      print('in looop');
      print(s['questions']);
      for(var q in s['questions']) {
        questions.add(q['question']);
        choices.add(q['propositions']);
        correctAnswers.add(q['reponse']);
        print("Questionsss");
        //print(questions);
        print("choices");
        //print(choices);
        print('correct Anwser');
        //print(correctAnswers);
      }
    }
    if(timeTrack == 0){
      yield questions;
      yield choices;
      yield correctAnswers;
      timeTrack = timeTrack + 1;
      print(timeTrack);
    }else{

    }
    //return class_future;
  }

  var streamData;

  @override
  void initState() {
    super.initState();
    streamData = this._fetchQuiz();
  }

  Widget streamWidget() {
    return StreamBuilder(
        stream: streamData,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(20.0)),

                new Container(
                  alignment: Alignment.centerRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "Question ${questionNumber + 1} of ${questions.length}",
                        style: new TextStyle(fontSize: 22.0),
                      ),
                      new Text(
                        "Score: $finalScore",
                        style: new TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Text(
                  questions[questionNumber],
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 1
                    new MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (choices[questionNumber][0]['intitule'] ==
                            correctAnswers[questionNumber]['intitule']) {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        choices[questionNumber][0]['intitule'],
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                    //button 2
                    new MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (choices[questionNumber][1]['intitule'] ==
                            correctAnswers[questionNumber]['intitule']) {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        choices[questionNumber][1]['intitule'],
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 3
                    new MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (choices[questionNumber][2]['intitule'] ==
                            correctAnswers[questionNumber]['intitule']) {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        choices[questionNumber][2]['intitule'],
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 40.0,),

                new Container(
                    alignment: Alignment.bottomCenter,
                    child: new MaterialButton(
                        minWidth: 240.0,
                        height: 50.0,
                        color: Colors.red,
                        onPressed: resetQuiz,
                        child: new Text(
                          "Quit",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ))),
              ],
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(widget.subject),
          centerTitle: true,
        ),
        body: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: new Container(
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.topCenter,
                child: streamWidget(),
              ),
            )));
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == questions.length - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(
                  score: finalScore,
                  totalQuestions: questions.length,
                )));
      } else {
        questionNumber++;
      }
    });
  }
}

/**
 * YOu may want to Extract this to another file.
 * Name it summary.dart
 */
class Summary extends StatelessWidget {
  final int score;
  final int totalQuestions;

  Summary({Key key, @required this.score, @required this.totalQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Final Score: $score / $totalQuestions",
                style: new TextStyle(fontSize: 35.0),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              new MaterialButton(
                color: Colors.red,
                onPressed: () {
                  questionNumber = 0;
                  finalScore = 0;
                  Navigator.pop(context);
                },
                child: new Text(
                  "Reset Quiz",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
