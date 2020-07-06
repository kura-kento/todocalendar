import 'package:intl/intl.dart';

class Expired {

  int _id;
  String _title;
  bool _clear;
  DateTime _timeLimit;
  int _todoId;

  Expired(this._title, this._clear, this._timeLimit, this._todoId);

  Expired.withId(this._id, this._title, this._clear, this._timeLimit, this._todoId);

  int get id => _id;

  String get title => _title;

  bool get clear => _clear;

  DateTime get timeLimit => _timeLimit;

  int get todoId => _todoId;


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

  set todoId(int newTodoId) {
    this._todoId = newTodoId;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {};

    map['id'] = _id;
    map['title'] = _title;
    map['clear'] = _clear.toString();
    map['timeLimit'] = _timeLimit == null ? "0" : DateFormat('yyyy-MM-dd HH:mm').format(_timeLimit);
    map['todoId'] = _todoId;
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Expired.fromMapObject(Map<String, dynamic> map) {
    //print(map);
    this._id = map['id'];
    this._title = map['title'];
    this._clear = map['clear'] == "true" ? true:false;
    this._timeLimit = map['timeLimit'] == "0" ? null : DateTime.parse(map['timeLimit']);
    this._todoId = map['todoId'];
  }
}
