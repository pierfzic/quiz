import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';

class Quiz {
  int id = 0;
  String question = "";
  List<String> answers = [];
  String type = "";
  String correctAnswer = "";
  bool correct = false;
  bool read = false;
  bool preferred = false;

  Quiz(
      {this.id = 0,
      this.question = "",
      required this.answers,
      this.type = "",
      this.correctAnswer = ""}) {}

  bool isCorrectAnswer(String ans) {
    return (correctAnswer.compareTo(ans) == 0) ? true : false;
  }

  void shuffle() {
    Random r = Random();
    correctAnswer = answers.first;
    answers.shuffle(r);
  }
}
