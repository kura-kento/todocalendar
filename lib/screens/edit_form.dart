import 'package:flutter/material.dart';

enum InputMode{
  create,
  edit
}


class EditForm extends StatefulWidget {
  EditForm({Key key,this.inputMode}) : super(key: key);

  final InputMode inputMode;

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
