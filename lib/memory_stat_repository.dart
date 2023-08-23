import 'package:quiz/MemoryRepository.dart';
import 'package:quiz/Quiz.dart';
import 'package:quiz/stat_repository.dart';

class MemoryStatRepository extends StatRepository {
  Map<String, int> correct = Map<String, int>();
  Map<String, int> read = Map<String, int>();
  Map<String, int> wrong = Map<String, int>();
  Map<String, int> total = Map<String, int>();
  MemoryRepository repos = MemoryRepository();

  static final MemoryStatRepository _instance =
      MemoryStatRepository._privateConstructor();

  factory MemoryStatRepository() {
    return _instance;
  }

  MemoryStatRepository._privateConstructor() {
    var argomenti = Set<String>();
    List<Quiz> uniquelist =
        repos.getAll().where((q) => argomenti.add(q.type)).toList();
    argomenti.toList().forEach((element) {
      correct[element] = 0;
      read[element] = 0;
      wrong[element] = 0;
      total[element] = repos.countType(element);
    });
  }

  @override
  void addCorrect(String type) {
    int? count = correct[type];
    count = count! + 1;
    correct[type] = count;
  }

  @override
  void addRead(String type) {
    int? count = read[type];
    count = count! + 1;
    read[type] = count;
  }

  @override
  void addWrong(String type) {
    int? count = wrong[type];
    count = count! + 1;
    wrong[type] = count;
  }

  @override
  int getCorrectTotal() {
    int counter = 0;
    correct.forEach((key, value) {
      counter += correct[key]!;
    });
    return counter;
  }

  @override
  int getCorrectType(String type) {
    return correct[type]!;
  }

  @override
  int getTotal() {
    int counter = 0;
    total.forEach((key, value) {
      counter += correct[key]!;
    });
    return counter;
  }

  @override
  int getTotalType(String type) {
    return total[type]!;
  }
}
