import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:intl/intl.dart';
import 'package:todocarendarapp/models/clear.dart';
import 'package:todocarendarapp/models/todo.dart';
import 'package:todocarendarapp/screens/edit_form.dart';
import 'package:todocarendarapp/utils/database_help.dart';
import 'package:todocarendarapp/utils/database_helper_expired.dart';
import 'package:todocarendarapp/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  
  //表示月
  int selectMonthValue = 0;
  String selectMonth = DateFormat.yMMMd().format(DateTime.now());

  //選択している日
  DateTime selectDay = DateTime.now();
  InfinityPageController _infinityPageController;

  int _initialPage = 0;
  int _scrollIndex = 0;
  Map<String, dynamic> monthMap;
  int yearSum;

  InfinityPageController _infinityPageControllerList;
  int calendarClose = 0;
  int _realIndex= 1000000000;
  Color _color = Colors.transparent;

  bool isLoading = true;

  var _week = ["日", "月", "火", "水", "木", "金", "土"];
  var _weekColor = [Colors.red[200],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.blue[200]];

  //ここまでカレンダー

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList = List<Todo>();

  DatabaseHelperExpired databaseHelperExpired = DatabaseHelperExpired();
  List<Expired> expiredList = List<Expired>();

  @override
  void initState() {
    updateListView();
    _infinityPageController = InfinityPageController(initialPage: 0);
    _infinityPageControllerList = InfinityPageController(initialPage: 0);
    monthChange();
    super.initState();
  }

  @override
  void dispose() {
    _infinityPageController.dispose();
    _infinityPageControllerList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            //上から合計額、カレンダー、メモ
            children: <Widget>[
              Container(
                height: 40,
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                        child: IconButton(
                          icon:  Icon(calendarClose%2==0 ? Icons.file_upload : Icons.file_download),
                          onPressed: () {
                            calendarClose++;
                            setState(() {});
                          },
                        ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(""),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context){
                                return EditForm(inputMode: InputMode.create,selectDay: selectDay,);
                              },
                            ),
                          );
                          updateListView();
                          monthChange();
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              calendarClose % 2 == 0
              ? Container(
                height: 40,
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectMonthValue--;
                          selectDay = selectOfMonth(selectMonthValue);
                          monthChange();
                        });
                      },
                      iconSize: 30,
                      icon: Icon(Icons.arrow_left),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    //アイコン
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        DateFormat.yMMM("ja_JP").format(selectOfMonth(selectMonthValue)),
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    //アイコン
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectMonthValue++;
                          selectDay = selectOfMonth(selectMonthValue);
                          monthChange();
                        });
                      },
                      iconSize: 30,
                      icon: Icon(Icons.arrow_right),
                    ),
                  ),
                ]),
              )
              : Container(
                height: 40,
                child: InfinityPageView(
                  itemCount: 3,
                  controller: _infinityPageControllerList,
                  itemBuilder: (content, index) {
                    return Container(
                      child: Text(DateFormat("yyyy年MM月dd日").format(selectDay),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    selectDay = selectDay.add(Duration(days: _infinityPageControllerList.realIndex-_realIndex));
                    _realIndex =_infinityPageControllerList.realIndex;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: InfinityPageView(
                  controller: _infinityPageController,
                  itemCount: 3,
                  itemBuilder: (content, index) {
                    return Column(
                      children: <Widget>[
                        //曜日用に1行作る。
                        Row(children: weekList(),),
                        scrollPage(index),
                        (_initialPage == index)
                            ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(children: memoList()),
                            )
                        )
                            : Container()
                      ],
                    );
                  },
                  onPageChanged: (index) {
                    _scrollIndex = 0;
                    scrollValue(index);
                    monthChange();
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget scrollPage(index) {
    if ((index - _initialPage).abs() == 1) {
      _scrollIndex = (index - _initialPage);
    } else if ((index - _initialPage).abs() == 2) {
      _scrollIndex = (((index - _initialPage) / 2) * -1).floor();
    } else {
      _scrollIndex = 0;
    }
    return Column(children: dayList());
    //print(scrollIndex);

  }

  void scrollValue(index) {
    if ((index - _initialPage).abs() == 1) {
      selectMonthValue += (index - _initialPage);
    } else if ((index - _initialPage).abs() == 2) {
      selectMonthValue += (((index - _initialPage) / 2) * -1).floor();
    }
    selectDay = selectOfMonth(selectMonthValue);
    _initialPage = index;
  }

  //カレンダーの曜日部分（1行目）
  List<Widget> weekList() {
    List<Widget> _list = [];
    for (int i = 0; i < 7; i++) {
      _list.add(
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            color: _weekColor[i],
            child: Text(_week[i]),
          ),
        ),
      );
    }
    return calendarClose % 2 == 0 ? _list : List<Widget>() ;
  }

//カレンダーの日付部分（2行目以降）
  List<Widget> dayList() {
    List<Widget> _list = [];
    for (int j = 0; j < 6; j++) {
      List<Widget> _listCache = [];
      for (int i = 0; i < 7; i++) {
        _listCache.add(
          Expanded(
            flex: 1,
            child: calendarSquare(calendarDay(i, j)),
          ),
        );
      }
      _list.add(Row(children: _listCache));
      //土曜日の月が選択月でない　または、月末の場合は終わる。
      if (Utils.toInt(calendarDay(6, j).month) !=
          selectOfMonth(selectMonthValue + _scrollIndex).month ||
          endOfMonth() == Utils.toInt(calendarDay(6, j).day)) {
        break;
      }
    }
    return calendarClose % 2 == 0 ? _list : List<Widget>();
  }

//カレンダー１日のマス（その月以外は空白にする）
  Widget calendarSquare(DateTime date) {
    if (date.month == selectOfMonth(selectMonthValue + _scrollIndex).month) {
      return Container(
        color: Colors.grey[100],
        height: 50.0,
        child: Stack(
          children: <Widget>[
            Container(
//              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                color: DateFormat.yMMMd().format(selectDay) == DateFormat.yMMMd().format(date) ? Colors.yellow[300] : _color,
              ),
              child: Column(
                  children: squareValue(date)
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(DateTime.now()) ? Colors.red[300] : Colors.transparent,
                        child: AutoSizeText(
                          "${Utils.toInt(date.day)}",
                          textAlign: TextAlign.center,
                          minFontSize: 4,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(DateTime.now())
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 2,
                    )
                  ],
                ),
              ),
            ),
            //クリック時選択表示する。
            FlatButton(
              child: Container(),
              onPressed: () {
                selectDay = date;
                setState(() {});
              },
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        height: 50.0,
      );
    }
  }

  //１日のマスの中身
  List<Widget> squareValue(date) {
    List<Widget> _list = [Expanded(flex: 1, child: Container())];
    _list.add(
      Expanded(
          flex: 2,
          child: Container(
              child: Align(
                  alignment: Alignment.center,
                  child: date == DateTime.now()  ? Icon(Icons.panorama_fish_eye,color: Colors.red,):Text("")
              )
          )
      ),
    );
    return _list;
  }

  //一日のリスト（カレンダー下）
  List<Widget> memoList() {
    List<Widget> _list = [];
    for(int _clearIndex = 0; _clearIndex < 2; _clearIndex++){
      for (int i = 0; i < (_clearIndex == 0 ? todoList.length: expiredList.length); i++) {
        //（作成日 < 選択日）かつ（期限がnull）または（selectDayでまだクリアしていないリスト）
        if (_clearIndex == 0 ?( (todoList[i].createdAt).compareTo(selectDay) <= 0  && (expiredList.where((expired) => (expired.todoId == todoList[i].id && DateFormat("yyyy年MM月dd").format(expired.timeLimit) == DateFormat("yyyy年MM月dd").format(selectDay)) ).length < 1) )
            && todoList[i].repetition % 2 == 0 && selectDay.weekday == 7
            || todoList[i].repetition % 3 == 0 && selectDay.weekday == 1
            || todoList[i].repetition % 5 == 0 && selectDay.weekday == 2
            || todoList[i].repetition % 7 == 0 && selectDay.weekday == 3
            || todoList[i].repetition % 11 == 0 && selectDay.weekday == 4
            || todoList[i].repetition % 13 == 0 && selectDay.weekday == 5
            || todoList[i].repetition % 17 == 0 && selectDay.weekday == 6

            :  (DateFormat("yyyy年MM月dd").format(expiredList[i].timeLimit) == DateFormat("yyyy年MM月dd").format(selectDay)) ) {
          _list.add(
            Container(
              height: 50.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]),
                  ),
                ),
                child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.15,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _clearIndex == 0 ? todoList[i].clear: true,
                          onChanged: (value){
                            todoList[i].clear = !todoList[i].clear;
                            if(todoList[i].repetition == 1){
                              _save(todoList[i]);
                            }else{
                              _clearIndex == 0 ? _insertExpired(todoList[i]):_deleteExpired(expiredList[i].id);
                            }
                            updateListView();
                            setState(() {});
                          },
                        ),
                      Expanded(
                        child: InkWell(
                            child: Container(
                                height:50,
                                child: _clearIndex == 0 ? Text( todoList[i].title,textAlign:TextAlign.center) : Text( expiredList[i].title ,textAlign:TextAlign.center,style: TextStyle(decoration: TextDecoration.lineThrough) )
                            ),
                            onTap: () async {
                              _color = Colors.transparent;
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context){
                                    return EditForm(inputMode: InputMode.edit,selectDay: selectDay,todo:todoList[i]);
                                  },
                                ),
                              );
                              updateListView();
                              monthChange();
                            },
                            onTapCancel: () {
                              _color = Colors.transparent;
                              setState(() {});
                        },
                            onTapDown: (TapDownDetails details) {
                              _color = Colors.lightBlueAccent;
                              setState(() {});
                            }),
                      ),
                    ],
                    ),
                    secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '削除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            _clearIndex == 0 ? _delete(todoList[i].id):_deleteExpired(expiredList[i].id);
                            updateListView();
                            setState(() {});
                          }
                      )
                    ]
                ),
              ),
          );
        }
      }
    }
    return _list;
  }


  Future<void> updateListView() async{
//全てのDBを取得
    todoList = await databaseHelper.getTodoList();
    expiredList = await databaseHelperExpired.getExpiredList();
    setState(() {});
  }

  Future<void> monthChange() async {
    final DateTime _date = DateTime.now();
    isLoading = false;
    setState(() {});
  }

//iとjから日程のデータを出す（Date型）
  DateTime calendarDay(i, j) {
    final DateTime _date = DateTime.now();
    var startDay = DateTime(
        _date.year, _date.month + selectMonthValue + _scrollIndex, 1);
    int weekNumber = startDay.weekday;
    DateTime calendarStartDay =
    startDay.add(Duration(days: -(weekNumber % 7) + (i + 7 * j)));
    return calendarStartDay;
  }

//月末の日を取得（来月の１日を取得して１引く）
  int endOfMonth() {
    final DateTime _date = DateTime.now();
    var startDay = DateTime(
        _date.year, _date.month + 1 + selectMonthValue + _scrollIndex, 1);
    DateTime endOfMonth = startDay.add(Duration(days: -1));
    final int _endOfMonth = Utils.toInt(endOfMonth.day);
    return _endOfMonth;
  }

//選択中の月をdate型で出す。
  DateTime selectOfMonth(value) {
    final DateTime _date = DateTime.now();
    var _selectOfMonth = DateTime(_date.year, _date.month + value, 1);
    return _selectOfMonth;
  }

  Future<void> _save(Todo todo)async{
    await databaseHelper.updateTodo(todo);
  }
  Future <void> _delete(int id) async{
    await databaseHelper.deleteTodo(id);
  }

  Future<void> _insertExpired(Todo todo)async{
    await databaseHelperExpired.insertExpired(Expired(todo.title, true, selectDay, todo.id));
  }
  Future <void> _deleteExpired(int id) async{
    await databaseHelperExpired.deleteExpired(id);
  }


}



