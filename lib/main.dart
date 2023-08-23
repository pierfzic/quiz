import 'package:flutter/material.dart';
import 'package:quiz/memory_stat_repository.dart';
import 'Quiz.dart';
import 'Repository.dart';
import 'MemoryRepository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quiz Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MemoryRepository rep = MemoryRepository();
  MemoryStatRepository statRep = MemoryStatRepository();
  int _index = 1;
  int _counterQuestion = 0;
  int _maxQuestion = 5;
  bool _fineBatteria = false;
  int _lastQuestionId = 0;
  Strategy _successione = Strategy.LINEAR;
  List<String> argomenti = [];
  String? _args = "Generic";
  int _dimBatteria = 5;
  List<Quiz> _batteria = [];
  late Iterator<Quiz> _it;
  Quiz _currentQuiz = Quiz(answers: []);
  List<Color> answerColor = [
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
  ];

  String rispostaData = "";
  bool _listaCasuale = false;

  _MyHomePageState() {
    var setArgs = Set<String>();
    List<Quiz> uniquelist =
        rep.getAll().where((q) => setArgs.add(q.type)).toList();
    argomenti = setArgs.toList();

    _batteria = rep.getBatteria(_listaCasuale, 2, _dimBatteria, _args!);
    _it = _batteria.iterator;
    _it.moveNext();
  }

  @override
  Widget build(BuildContext context) {
    _currentQuiz = _it.current;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Demo Quiz")),
      body: generateQuizScreen(_currentQuiz),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Successione Quiz"),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Lineare"),
                Switch(
                  value: _listaCasuale,
                  onChanged: (value) {
                    setState(
                      () {
                        _listaCasuale = value;
                        _batteria =
                            rep.getBatteria(_listaCasuale, 2, 10, _args!);
                      },
                    );
                  },
                ),
                Text("Casuale"),
              ],
            ),
          ),
          Column(
            children: [
              Text('Domande per batteria: $_dimBatteria'),
              Slider(
                value: _dimBatteria.toDouble(),
                min: 1,
                max: 50,
                onChanged: (newvalue) {
                  setState(() {
                    _dimBatteria = newvalue.toInt();
                    _batteria =
                        rep.getBatteria(_listaCasuale, 2, _dimBatteria, _args!);
                  });
                },
              )
            ],
          )
        ]),
      ),
    ));
  }

  Widget generateQuizScreen(Quiz q) {
    List<Widget> header = [
      Text('Domanda n. ${q.id}'),
      Card(
          child: Column(
        children: [Text(q.question), Text(q.type)],
      )),
      const Padding(
        padding: EdgeInsets.only(top: 30.0, left: 0, right: 0),
      )
    ];
    List<Widget> pulsanti = [
      TextButton(
        child: Text("Prossimo"),
        onPressed: () {
          next();
        },
      )
    ];

    List<Widget> risposteList = [];
    int startChar = "A".codeUnitAt(0);
    int i = 0;
    q.answers.forEach(
      (element) {
        int carattere = startChar + i;

        risposteList.add(
          Card(
            child: InkWell(
              child: Row(
                children: [
                  Text(
                    String.fromCharCode(carattere),
                    style:
                        TextStyle(fontSize: 20, backgroundColor: Colors.white),
                  ),
                  Text(element,
                      style: TextStyle(
                          fontSize: 12, backgroundColor: answerColor[i])),
                ],
              ),
              onTap: () => {
                setState(() {
                  rispostaData = element;
                  checkAnswer(element, q);
                }),
              },
            ),
          ),
        );
        i++;
      },
    );
    return Column(children: [...header, ...risposteList, ...pulsanti]);
  }

  void checkAnswer(String risposta, Quiz q) {
    bool corretto = false;
    if (rispostaData.compareTo("") != 0) {
      int indexRispostaData =
          q.answers.indexWhere((element) => element == rispostaData);
      int indexRispostaCorretta =
          q.answers.indexWhere((element) => element == q.correctAnswer);
      answerColor[indexRispostaData] = Colors.red;
      answerColor[indexRispostaCorretta] = Colors.green;
      if (q.isCorrectAnswer(risposta)) {
        if (!_fineBatteria) {
          statRep.addCorrect(q.type);
          statRep.getCorrectTotal();
          statRep.addRead(q.type);
          rep.setCorrect(q.id);
        }
      }
    }
  }

  // int findFirst(List<String> list, String daTrovare) {
  //   int i = 0;
  //   list.forEach((element) {
  //     if (daTrovare.compareTo(element) == 0) {
  //       return i;
  //     } else {
  //       i++;
  //     }
  //   });
  //   return -1;
  // }

  void next() {
    setState(() {
      answerColor = [
        Colors.yellow,
        Colors.yellow,
        Colors.yellow,
        Colors.yellow,
      ];
      _lastQuestionId = _index;
      _counterQuestion++;
      if (_counterQuestion < _maxQuestion)
        _it.moveNext();
      else {
        _fineBatteria = true;
        print("Hai terminato la batteria di domande!");

        int giuste = statRep.getCorrectTotal();
        print("Risposte: $giuste");
      }
    });
  }
}

enum Strategy { LINEAR, RANDOM, TYPE }
