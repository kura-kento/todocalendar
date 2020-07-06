import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todocarendarapp/models/todo.dart';
import 'package:todocarendarapp/utils/database_help.dart';

enum InputMode{
  create,
  edit
}


class EditForm extends StatefulWidget {
  EditForm({Key key,this.inputMode, this.selectDay}) : super(key: key);

  final InputMode inputMode;
  final DateTime selectDay;

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  TextEditingController titleController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList = List<Todo>();

  DateTime _timeText;
  DateTime _dateText;
  bool _longTimeBool = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Container(
      color: Colors.grey[300],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(icon: Icon(
                          Icons.arrow_back),
                        onPressed: () => moveToLastScreen(),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(widget.inputMode == InputMode.edit ? "編集フォーム" : "新規追加フォーム")),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                  child: Padding(
                      padding: EdgeInsets.only(top:15.0,left:10.0,right:10.0),
                      child: ListView(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top:15,bottom:15),
                              child: TextField(
                                controller: titleController,
                                style: textStyle,
                                decoration: InputDecoration(
                                    labelText: 'タイトル',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                    )
                                ),
                              )
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("  日程"),
                                  Text((_dateText == null ? DateFormat("M月d日").format(widget.selectDay) : DateFormat("M月d日").format(_dateText)) + " ＞")
                                ],
                              ),
                            ),
                            onTap: (){
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState1) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xff999999),
                                                    width: 0.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(),
                                                  CupertinoButton(
                                                    child: Text('決定', style: TextStyle(color: Colors.cyan),),
                                                    onPressed: () {
                                                      moveToLastScreen();
                                                    },
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xffffffff),
                                              height: MediaQuery.of(context).size.height / 3,
                                              child:
                                              SizedBox(
                                                  height: 200,
                                                  child: CupertinoDatePicker(
                                                    mode: CupertinoDatePickerMode.date,
                                                    initialDateTime:widget.selectDay,
                                                    use24hFormat: true,
                                                    onDateTimeChanged: (DateTime newDateTime) {
                                                      _dateText = newDateTime;
                                                      setState(() {});
                                                    },
                                                  ),
                                              ),

                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                              );
                            },
                          ),
                          Divider(color: Colors.grey[100],height: 2.5),
                          InkWell(
                            child: Container(
                              height: 50,
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("  時間"),
                                  Text((_timeText == null ? DateFormat("HH:mm").format(widget.selectDay) : DateFormat("HH:mm").format(_timeText)) + " ＞")
                                ],
                              ),
                            ),
                            onTap: (){
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState1) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xff999999),
                                                    width: 0.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(),
                                                  CupertinoButton(
                                                    child: Text('決定',
                                                      style: TextStyle(color: Colors.cyan),
                                                    ),
                                                    onPressed: () {
                                                      moveToLastScreen();
                                                    },
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 5.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xffffffff),
                                              height: MediaQuery.of(context).size.height / 3,
                                              child:
                                              SizedBox(
                                                height: 200,
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode.time,
                                                  initialDateTime: widget.selectDay,
                                                  use24hFormat: true,
                                                  onDateTimeChanged: (DateTime newDateTime) {
                                                    _timeText = newDateTime;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),

                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                              );
                            },
                          ),
                          Divider(color: Colors.grey[100],height: 2.5),
                          Container(
                            color: Colors.grey[200],
                            child: CheckboxListTile(
                              title: Text("長期目標"),
                              value:  _longTimeBool,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value){
                                _longTimeBool = !_longTimeBool;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                              padding:EdgeInsets.only(top:15.0,bottom:15.0),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  '保存',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: (){
                                  _save(Todo(titleController.text,false,DateTime(_dateText.year,_dateText.month, _dateText.day),_longTimeBool ? 1:0));
                                  moveToLastScreen();
                                  setState(() {});
                                },
                              )
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveToLastScreen() async{
    FocusScope.of(context).unfocus();
    await new Future.delayed(new Duration(microseconds: 3000));
    Navigator.pop(context);
  }

  Future<void> _save(Todo todo)async{
    await databaseHelper.insertTodo(todo);
  }
}
