import 'dart:math';

import 'Quiz.dart';
import 'Repository.dart';

class MemoryRepository extends Repository {
  final int n_quiz = 1000;
  List<Quiz> lista = [];

  MemoryRepository() {
    generateMockQuiz();
  }

  @override
  List<Quiz> getAll() {
    return lista;
  }

  List<Quiz> getBatteria(bool random, int lastindex, int max, String type) {
    Random r = Random();

    List<Quiz> batteria = [];
    int counter = 0;
    List<Quiz> l1 = lista;
    if (type != "") {
      l1 = lista.where(
        (element) {
          return (element.type.compareTo(type) == 0);
        },
      ).toList();
    }
    if (random == false) {
      List<Quiz> l2 = l1.where((element) {
        return (element.id > lastindex);
      }).toList();
      l2.sort(
        (a, b) {
          return (a.id - b.id);
        },
      );
      for (int i = 0; (i < l2.length) && (counter < max); i++) {
        batteria.add(l2[i]);
        counter++;
      }
    } else {
      for (int i = 0; counter < max; i = r.nextInt(l1.length)) {
        batteria.add(l1[i]);
        counter++;
      }
    }
    print("******Nuova Batteria Pronta: ");
    batteria.forEach((element) {
      print("${element.id} - ${element.type}");
    });
    print("Num elementi batteria: ${batteria.length}");
    return batteria;
  }

  @override
  Future<Quiz> getQuestion(int id) {
    bool trovato = false;
    int i = 0;
    for (i = 0; i < lista.length; i++) {
      if (lista[i].id == id) {
        trovato = true;
        break;
      }
    }
    if (trovato)
      return Future.value(lista[i]);
    else
      return Future.value(Quiz(answers: []));
  }

  Quiz getQuestionActual(int id) {
    bool trovato = false;
    int i = 0;
    for (i = 0; i < lista.length; i++) {
      if (lista[i].id == id) {
        trovato = true;
        break;
      }
    }
    if (trovato) {
      return lista[i];
    } else
      return Quiz(answers: []);
  }

  int getQuestionIndex(int id) {
    bool trovato = false;
    int i = 0;
    for (i = 0; i < lista.length; i++) {
      if (lista[i].id == id) {
        trovato = true;
        break;
      }
    }
    return (trovato ? i : -1);
  }

  @override
  Future<Quiz> getRandomType(String type) {
    Random r = Random();
    List<Quiz> listType =
        lista.where((element) => element.type == type).toList();
    int randIndex = r.nextInt(listType.length);
    return Future.value(listType[randIndex]);
  }

  generateMockQuiz() {
    for (int i = 0; i < n_quiz; i++) {
      String quizText = 'Testo domanda n. $i';
      List<String> ans = [
        "risposta A",
        "risposta B",
        "risposta C",
        "risposta D"
      ];
      String type = "";
      if (i < 15) {
        type = "Generic";
      } else {
        type = "Type01";
      }
      Quiz newQuiz = Quiz(
          id: i,
          question: quizText,
          answers: ans,
          type: type,
          correctAnswer: "risposta A");
      newQuiz.shuffle();
      lista.add(newQuiz);
    }
  }

  void setCorrect(int id) {
    int index = getQuestionIndex(id);
    lista[index].correct = true;
    lista[index].read = true;
  }

  void setWrong(int id) {
    int index = getQuestionIndex(id);
    lista[index].correct = false;
    lista[index].read = true;
  }

  int count() {
    return this.lista.length;
  }

  int countType(String type) {
    List<Quiz> listType =
        lista.where((element) => element.type == type).toList();
    return listType.length;
  }
}
