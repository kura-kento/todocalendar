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
  EditForm({Key key,this.inputMode, this.selectDay,this.todo}) : super(key: key);

  final InputMode inputMode;
  final DateTime selectDay;
  final Todo todo;

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
  List<bool> _boolList = [false,false,false,false,false,false,false];
  List<int> _weekNumbers =[2,3,5,7,11,13,17];
  List<String> _week = ["日","月","火","水","木","金","土"];
  int _number =1;
  @override
  void initState() {
    _dateText = widget.selectDay;
    if(widget.inputMode == InputMode.edit){
      titleController = TextEditingController(text: widget.todo.title);
      _number = widget.todo.repetition;
      _longTimeBool = widget.todo.longTerm == 0 ? true:false;
    }
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
                      child: IconButton(icon: Icon(Icons.arrow_back),
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
                                  Text("   日程",style: TextStyle(fontSize: 20,color: Colors.grey[800])),
                                  Row(
                                    children: [
                                      Text((DateFormat("M月d日").format(_dateText)) + " ",style: TextStyle(fontSize: 20,color: Colors.grey[800])),
                                      Icon(Icons.expand_more,color: Colors.grey[800],),
                                      Text("    ")
                                    ],
                                  )
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
                                  Text("   時間",style: TextStyle(fontSize: 20,color: Colors.grey[800])),
                                  Row(
                                    children: [
                                      Text((_timeText == null ? DateFormat("HH:mm").format(widget.selectDay) : DateFormat("HH:mm").format(_timeText))+" ",style: TextStyle(fontSize: 20,color: Colors.grey[800])),
                                      Icon(Icons.expand_more,color: Colors.grey[800],),
                                      Text("    ")
                                    ],
                                  )
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
                                                    print(_timeText);
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
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("繰り返し"),
                                  Text(weekName())
                                ],
                              ),
                              backgroundColor: Colors.white,
                              children: weekList(),
                              initiallyExpanded: false,
                            ),
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
                                  _save(Todo(titleController.text,false,DateTime(_number == 1 ?_dateText.year:3020,_dateText.month, _dateText.day),_longTimeBool ? 1:0,_number,DateTime.now()));
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

  List<Widget> weekList(){
   List<Widget> _list = [];

   for(int i = 0; i < 7; i++){
     _list.add(
       Container(
       color: Colors.grey[200],
       child: CheckboxListTile(
         title: Text("毎" + _week[i] + "曜日"),
         value:  _boolList[i],
         controlAffinity: ListTileControlAffinity.leading,
         onChanged: (value){
           _number % _weekNumbers[i] == 0 ?  _number ~/= _weekNumbers[i] :_number *= _weekNumbers[i] ;
           _boolList[i] = !_boolList[i];
           setState(() {});
         },
       ),
     ),
     );
   }
   return _list;
}

String weekName(){
    String _text = "";
    for(int i = 0; i < 7; i++){
      if(_number % _weekNumbers[i] == 0){
        _text += _week[i];
      }
    }
  if(_number == 1){
    _text = "なし";
  }
  if(_number == 510510){
    _text = "毎日";
  }
    return _text;
}

  moveToLastScreen() async{
    FocusScope.of(context).unfocus();
    await new Future.delayed(new Duration(microseconds: 3000));
    Navigator.pop(context);
  }

  Future<void> _save(Todo todo)async{
     if(widget.inputMode == InputMode.create){
       await databaseHelper.insertTodo(todo);
     }else{
       await databaseHelper.updateTodo(Todo.withId(widget.todo.id, todo.title, todo.clear, todo.timeLimit, todo.longTerm, todo.repetition, todo.createdAt)

       );
     }

  }
}
