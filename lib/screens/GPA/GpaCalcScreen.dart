import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GpaCalcScreen extends StatefulWidget {
  final int n;
  final int totalOldCreidt;
  final double oldGpa;
  final int covid;

  GpaCalcScreen({this.n, this.totalOldCreidt, this.oldGpa, this.covid});

  @override
  GpaCalcScreenstate createState() => new GpaCalcScreenstate();
}

var decoration = BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xff2a61a8), Color(0xff2d377a)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft),
  borderRadius: BorderRadius.circular(15),
);

class GpaCalcScreenstate extends State<GpaCalcScreen> {
  List<String> _itemsCp = ['2', '3', '4', '6'].toList();
  var _selection;
  var _selectionCp;
  var list;
  bool isdark;

  @override
  void initState() {
    super.initState();
    getPref();
    // ignore: deprecated_member_use
    _selection = new List<int>()..length = widget.n;
    // ignore: deprecated_member_use
    _selectionCp = new List<String>()..length = widget.n;
    list = new List<int>.generate(widget.n, (i) => i);
  }

  getPref() async {
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sumgpahours = 0;
    int totalnewhours = 0;
    var textFields = <Widget>[];
    bool safeToNavigate = true;
    list.forEach((i) {
      textFields.add(
        new Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            new Text(
              "Subject ${i + 1}:",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              height: 60,
              width: 90,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: Text("credit"),
                value: _selectionCp[i],
                items: _itemsCp.map((String items) {
                  return new DropdownMenuItem<String>(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (s) {
                  setState(() {
                    _selectionCp[i] = s;
                  });
                },
              ),
            ),
            Container(
              width: 160,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'grade of 100',
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    String s = val;
                    _selection[i] = int.parse(s);
                  });
                },
              ),
            ),
          ]),
          Divider(color: Theme.of(context).dividerColor, thickness: 2),
        ]),
      );
    });

    double newgpa = 0.0;
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "GPA calculator",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: size.height,
          width: double.infinity,
          child: Image.asset(
            isdark ? 'assets/images/BackB.jpg' : 'assets/images/BackWh.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(bottom: 35),
          child: new ListView(
            children: textFields,
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Calculate',
        backgroundColor: Theme.of(context).primaryColor,
        child: new Icon(
          Icons.calculate_outlined,
          size: 36,
        ),
        onPressed: () {
          print(_selection[0]);
          for (int i = 0; i < widget.n; i++) {
            if (_selectionCp[i] == null ||
                _selection[i] > 100 ||
                _selection[i] < 0) {
              safeToNavigate = false;
              continue;
            }
            if (_selection[i] == null) {
              safeToNavigate = false;
              continue;
            }
            int hours = int.parse(_selectionCp[i]);

            double gpa = calculate(_selection[i]);
            double gpahours = gpa * hours;
            sumgpahours += gpahours;
            totalnewhours += hours;
          }
          newgpa = sumgpahours / totalnewhours;
          int totaloldnewhours = totalnewhours + widget.totalOldCreidt;
          double totalGPA =
              ((widget.oldGpa * (widget.totalOldCreidt - widget.covid) +
                      newgpa * totalnewhours)) /
                  (totaloldnewhours - widget.covid);
          print(totalGPA);
          if (safeToNavigate) {
            gpashow(newgpa, totalGPA);
          } else {
            alert();
          }
        },
      ),
    );
  }

  double calculate(var a) {
    if (a >= 93 && a <= 100) return 4;
    if (a >= 89 && a < 93) return 3.7;
    if (a >= 84 && a < 89) return 3.3;
    if (a >= 80 && a < 84) return 3;
    if (a >= 76 && a < 80) return 2.7;
    if (a >= 73 && a < 76) return 2.3;
    if (a >= 70 && a < 73) return 2;
    if (a >= 67 && a < 70) return 1.7;
    if (a >= 64 && a < 67) return 1.3;
    if (a >= 60 && a < 64) return 1;
    if (a < 60) return 0;
    return 0;
  }

  gpashow(newgpa, totalGPA) {
    return AwesomeDialog(
        context: context,
        btnCancel: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        isDense: true,
        btnOkColor: Colors.green,
        btnOk: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                })),
        body: Container(
          decoration: decoration,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(" Your semster GPA is:  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Color(0xff2a61a8))),
              ),
              Text(newgpa.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white)),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(" Your total GPA is: ",
                    style: TextStyle(
                        color: Color(0xff2a61a8),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
              ),
              Text(totalGPA.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white)),
            ],
          ),
        ),
        customHeader: Container(
          decoration: decoration,
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/calc.png',
            height: 70,
          ),
        ),
        dialogType: DialogType.NO_HEADER)
      ..show();
  }

  alert() {
    return AwesomeDialog(
        context: context,
        isDense: true,
        btnCancel: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(4),
            decoration: decoration,
            child: Text('please check you inputs again',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, color: Colors.white))),
        dialogType: DialogType.ERROR)
      ..show();
  }
}
