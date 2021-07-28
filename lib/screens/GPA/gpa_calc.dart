import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GpaCalcScreen.dart';

class GPACalc extends StatefulWidget {
  static const routeName = '/gpacalc';
  @override
  _GPACalcState createState() => _GPACalcState();
}

class _GPACalcState extends State<GPACalc> {
  final _formKey = GlobalKey<FormState>();
  int _numSbj;
  int totalOldCreidt;
  double oldGpa;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(oldGpa);
      print(totalOldCreidt);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => GpaCalcScreen(
                    n: _numSbj,
                    totalOldCreidt: totalOldCreidt,
                    oldGpa: oldGpa,
                  )));
    }
  }

  bool isdark;

  getPref() async {
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        title: Row(
          children: [
            Image.asset(
              'assets/images/calc.png',
              height: 32,
              fit: BoxFit.contain,
            ),
            Text('  GPA Calculator', style: TextStyle(color: Colors.white)),
          ],
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
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Note: please enter your old GPA and total passed hours and courses number , if it was your first semster put old GPA and total old credits with zeroes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 160,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Total old credits',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (input) => input.trim().isEmpty
                                  ? 'Enter your old credits'
                                  : null,
                              onSaved: (input) {
                                setState(() {
                                  String _oldCredits = input;
                                  totalOldCreidt = int.parse(_oldCredits);
                                });
                              }),
                        ),
                        Container(
                          width: 160,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Old GPA',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (input) => input.trim().isEmpty
                                  ? 'Enter your old GPA'
                                  : double.parse(input) > 4
                                      ? 'Enter GPA less than 4'
                                      : null,
                              onSaved: (input) {
                                setState(() {
                                  String oldgpa = input;
                                  oldGpa = double.parse(oldgpa);
                                });
                              }),
                        )
                      ],
                    ),
                    Divider(
                        height: 40,
                        color: Theme.of(context).dividerColor,
                        thickness: 2),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          labelText: 'Number of courses',
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter number of courses'
                            : null,
                        onSaved: (input) {
                          setState(() {
                            String _numSb = input;
                            _numSbj = int.parse(_numSb);
                          });
                        }),
                  ]),
                ),
                SizedBox(height: size.height * 0.2),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    child: Text(
                      ' Continue ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                    ),
                    onPressed: () => _submit(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
