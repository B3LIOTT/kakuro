
class Carre {
  int verticalSum;
  int horizontalSum;
  int value; // 0 if white, -1 if black

  Carre(this.verticalSum, this.horizontalSum, this.value);

  @override
  String toString() {
    return '{$verticalSum,$horizontalSum,$value}';
  }
}