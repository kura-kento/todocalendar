import 'package:intl/intl.dart';

class Todo {

  int _id;
  String _title;
  bool _clear;
  DateTime _timeLimit;
  int _longTerm;
  int _repetition;

  Todo(this._title, this._clear, this._timeLimit, this._longTerm, this._repetition);

  Todo.withId(this._id, this._title, this._clear, this._timeLimit, this._longTerm, this._repetition);

  int get id => _id;

  String get title => _title;

  bool get clear => _clear;

  DateTime get timeLimit => _timeLimit;

  int get longTerm => _longTerm;

  int get repetition => _repetition;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set clear(bool newClear) {
    this._clear = newClear;
  }

  set timeLimit(DateTime newTimeLimit) {
    this._timeLimit = newTimeLimit;
  }

  set longTerm(int newLongTerm) {
    this._longTerm = newLongTerm;
  }

  set repetition(int newRepetition) {
    this._repetition = newRepetition;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {};

    map['id'] = _id;
    map['title'] = _title;
    map['clear'] = _clear.toString();
    map['timeLimit'] = _timeLimit == null ? "0" : DateFormat('yyyy-MM-dd HH:mm').format(_timeLimit);
    map['longTerm'] = _longTerm;
    map['repetition'] = _repetition;
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Todo.fromMapObject(Map<String, dynamic> map) {
    //print(map);
    this._id = map['id'];
    this._title = map['title'];
    this._clear = map['clear'] == "true" ? true:false;
    this._timeLimit = map['timeLimit'] == "0" ? null : DateTime.parse(map['timeLimit']);
    this._longTerm = map['longTerm'];
    this._repetition = map['repetition'];

  }
}
