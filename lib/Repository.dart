import 'Quiz.dart';

abstract class Repository {
  Future<Quiz> getQuestion(int id);
  List<Quiz> getAll();
  Future<Quiz> getRandomType(String type);
}
