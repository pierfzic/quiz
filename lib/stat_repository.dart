abstract class StatRepository {
  int counter = 0;

  int getCorrectTotal();
  int getTotal();
  int getCorrectType(String type);
  int getTotalType(String type);
  void addCorrect(String type);
  void addWrong(String type);
  void addRead(String type);

  void _metodo() {
    print("Ciao!");
  }
}
