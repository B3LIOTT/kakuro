
class Player {
  late final String _username;
  late final int _RP;

  Player(this._username, this._RP);

  String get username => _username;
  int get RP => _RP;

  set RP(int RP) => _RP = RP;
}