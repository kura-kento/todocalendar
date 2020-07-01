import 'package:intl/intl.dart';

class Todo {

  int _id;
  String _title;
  int _check;
  DateTime _timeLimit;
  int _longTerm;

  Todo(this._title, this._check, this._timeLimit, this._longTerm);

  Todo.withId(this._id, this._title, this._check, this._timeLimit, this._longTerm);

  int get id => _id;

  String get title => _title;

  int get check => _check;

  DateTime get timeLimit => _timeLimit;

  int get longTerm => _longTerm;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set check(int newCheck) {
    this._check = newCheck;
  }

  set timeLimit(DateTime newTimeLimit) {
    this._timeLimit = newTimeLimit;
  }

  set longTerm(int newLongTerm) {
    this._longTerm = newLongTerm;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {};

    map['id'] = _id;
    map['title'] = _title;
    map['check'] = _check;
    map['timeLimit'] = DateFormat('yyyy-MM-dd HH:mm').format(_timeLimit);
    map['longTerm'] = _longTerm;
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Todo.fromMapObject(Map<String, dynamic> map) {
    // print(map);
    this._id = map['id'];
    this._title = map['title'];
    this._check = map['check'];
    this._timeLimit = DateTime.parse(map['timeLimit']);
    this._longTerm = map['longTerm'];
  }
}
