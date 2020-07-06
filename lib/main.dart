import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todocarendarapp/screens/top.dart';
import 'package:todocarendarapp/utils/database_help.dart';
import 'package:todocarendarapp/utils/database_helper_expired.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [Locale("ja","JP")],
      localizationsDelegates: [GlobalMaterialLocalizations.delegate,GlobalWidgetsLocalizations.delegate,GlobalCupertinoLocalizations.delegate,DefaultCupertinoLocalizations.delegate],
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        ),
        home: FutureBuilder(
          builder: (BuildContext context ,AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return snapshot.data;
            }else{
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          future: setting(),
        )
    );
  }

  Future<Widget> setting()async{
    DatabaseHelper.db = await DatabaseHelper.initializeDatabase();
    DatabaseHelperExpired.db = await DatabaseHelperExpired.initializeDatabase();
    return MyHomePage();
  }
}