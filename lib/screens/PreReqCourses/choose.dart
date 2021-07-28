import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:revive/widgets/drawer.dart';

import 'CoursesScreen.dart';

class Choose extends StatefulWidget {
  @override
  _ChooseState createState() => _ChooseState();
}

String _semester = 'Level 000';
String prereq;

final List<String> level000 = [
  'Physics 1',
  'Mechanics 1',
  'Maths 1',
  'English 1',
  'Engineering Drawing',
  'Engineering chemistry fundamentals',
  'Physics 2',
  'Mechanics 2',
  'Maths 2',
  'English 2',
  'Workshop technology',
  'Introduction to computer system'
];
final List<String> level100 = [
  'Maths 3',
  'Electric circuit',
  'Technical writing reports',
  'Strength of material',
  'Logic digital design',
  'Fluid mechanics',
  'Maths 4',
  'Electrical power',
  'Thermodynamics',
  'Organic chemistry',
  'Probability and statics',
  'Data structure'
];

final List<String> level200 = [
  'Introduction to Anatomy of human body',
  'Electronics1',
  'Heat mass transefer',
  'Numerical analysis',
  'Legilation in the field of managment and accounting',
  'Stress analysis',
  'Electronis 2',
  'Automatic control system',
  'Measurements and measurement devices',
  'BioChemistry and molecular Biology',
  'Electromagnetic Fields',
  'Presentation Skills'
];

final List<String> level300 = [
  'Analog and digital Signals processing',
  'Trainging in medical and Biomedical Engineering 1',
  'Sensors devices',
  'Microbiology and Immunology',
  'Biometric and medical measuring instruments',
  '3d modeling',
  'Image processing',
  'Marketing',
  'Material properties in biomedical and medical application',
  'Introduction to physiology',
  'Project in Medical and Biomedical Engineering 1',
  'Biofluids',
];

final List<String> level400 = [
  'Medical Imaging',
  'Database',
  'Trainging in medical and Biomedical Engineering 2',
  'Project in Medical and Biomedical Engineering 2',
  'Introduction to Civil Engineering',
  'Medical and paramedical procedures',
  'Project in Medical and Biomedical Engineering 3',
  'Project management',
  'Nanotechnology',
  'Digital control systems',
  'Toxology and public health',
  'Bioinformatics',
];
var decoration = BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xff2a61a8), Color(0xff2d377a)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft),
  borderRadius: BorderRadius.circular(15),
);

class _ChooseState extends State<Choose> {
  var sems = {
    'Level 000': level000,
    'Level 100': level100,
    'Level 200': level200,
    'Level 300': level300,
    'Level 400': level400,
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 20),
          child: DropdownButtonFormField(
            icon: Icon(Icons.arrow_drop_down),
            isExpanded: true,
            isDense: true,
            hint: Text(_semester),
            items: [
              'Level 000',
              'Level 100',
              'Level 200',
              'Level 300',
              'Level 400',
            ].map((String semster) {
              return DropdownMenuItem(
                value: semster,
                child: Text(semster),
              );
            }).toList(),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onChanged: (value) {
              setState(() {
                _semester = value.toString();
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          child: DropdownButtonFormField(
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            isDense: true,
            hint: Text('Select Course'),
            items: sems[_semester].map((String course) {
              return DropdownMenuItem(
                value: course,
                child: Text(course),
              );
            }).toList(),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onChanged: (value) {
              setState(() {
                print(value);
                print('=====================================================');
                String val = value.toString();

                val == 'Workshop technology' ||
                        val == 'Introduction to computer system' ||
                        val == 'Introduction to Anatomy of human body' ||
                        val ==
                            'Legilation in the field of managment and accounting' ||
                        val == 'Marketing' ||
                        val == 'Project management' ||
                        val == 'Introduction to Civil Engineering' ||
                        val == 'Physics 1' ||
                        val == 'Mechanics 1' ||
                        val == 'Maths 1' ||
                        val == 'English 1' ||
                        val == 'Engineering Drawing' ||
                        val == 'Engineering chemistry fundamentals'
                    ? prereq = 'No Pre-requistites'
                    : val == 'Strength of material' ||
                            val == 'Fluid mechanics' ||
                            val == 'Thermodynamics' ||
                            val == 'Physics 2'
                        ? prereq = 'Physics 1'
                        : val == 'English 2'
                            ? prereq = 'English 1'
                            : val == 'Mechanics 2'
                                ? prereq = 'Mechanics 1'
                                : val == 'Maths 2'
                                    ? prereq = 'Maths 1'
                                    : val == 'Maths 3'
                                        ? prereq = 'Maths 2'
                                        : val == 'Technical writing reports'
                                            ? prereq = 'English 2'
                                            : val == 'Electric circuit'
                                                ? prereq = 'Physics 2'
                                                : val == 'Organic chemistry'
                                                    ? prereq =
                                                        'Engineering chemistry fundamentals'
                                                    : val ==
                                                            'Logic digital design'
                                                        ? prereq =
                                                            'Introduction to computer system'
                                                        : val == 'Maths 4' ||
                                                                val ==
                                                                    'Numerical analysis' ||
                                                                val ==
                                                                    'Automatic control system' ||
                                                                val ==
                                                                    'Probability and statics'
                                                            ? prereq = 'Maths 3'
                                                            : val == 'Data structure' ||
                                                                    val ==
                                                                        'Database'
                                                                ? prereq =
                                                                    'Introduction to computer system'
                                                                : val ==
                                                                        'Electrical power'
                                                                    ? prereq =
                                                                        'Electric circuit'
                                                                    : val == 'Electronics1' ||
                                                                            val ==
                                                                                'Electromagnetic Fields'
                                                                        ? prereq =
                                                                            'Electric circuit'
                                                                        : val ==
                                                                                'Stress analysis'
                                                                            ? prereq =
                                                                                'Strength of material'
                                                                            : val == 'Heat mass transefer'
                                                                                ? prereq = 'Thermodynamics'
                                                                                : val == 'Presentation Skills'
                                                                                    ? prereq = 'Technical writing reports'
                                                                                    : val == 'BioChemistry and molecular Biology'
                                                                                        ? prereq = 'Organic chemistry'
                                                                                        : val == 'Electronis 2' || val == 'Analog and digital Signals processing' || val == 'Sensors devices'
                                                                                            ? prereq = 'Electronics1'
                                                                                            : val == 'Measurements and measurement devices'
                                                                                                ? prereq = 'Physics 2 & Probability and statics'
                                                                                                : val == 'Trainging in medical and Biomedical Engineering 1' || val == 'Trainging in medical and Biomedical Engineering 2' || val == 'Project in Medical and Biomedical Engineering 1' || val == 'Project in Medical and Biomedical Engineering 2'
                                                                                                    ? prereq = 'passing 108 credit hours'
                                                                                                    : val == '3d modeling'
                                                                                                        ? prereq = 'Heat mass transefer & Stress analysis'
                                                                                                        : val == 'Biometric and medical measuring instruments'
                                                                                                            ? prereq = 'Introduction to Anatomy of human body & Measurements and measurement devices'
                                                                                                            : val == 'Microbiology and Immunology'
                                                                                                                ? prereq = 'BioChemistry and molecular Biology'
                                                                                                                : val == 'Introduction to physiology'
                                                                                                                    ? prereq = 'BioChemistry and molecular Biology & Introduction to Anatomy of human body'
                                                                                                                    : val == 'Material properties in biomedical and medical application'
                                                                                                                        ? prereq = 'Strength of material'
                                                                                                                        : val == 'Image processing'
                                                                                                                            ? prereq = 'Analog and digital Signals processing'
                                                                                                                            : val == 'Medical Imaging'
                                                                                                                                ? prereq = 'Image processing'
                                                                                                                                : val == 'Project in Medical and Biomedical Engineering 3'
                                                                                                                                    ? prereq = 'passing 144 credit hours'
                                                                                                                                    : val == 'Bioinformatics'
                                                                                                                                        ? prereq = 'Data structure & passing 108 credit hours'
                                                                                                                                        : val == 'Digital control systems'
                                                                                                                                            ? prereq = 'Automatic control system & passing 108 credit hours'
                                                                                                                                            : val == 'Toxology and public health'
                                                                                                                                                ? prereq = 'Probability and statics & passing 108 credit hours'
                                                                                                                                                : val == 'Nanotechnology'
                                                                                                                                                    ? prereq = 'passing 108 credit hours'
                                                                                                                                                    : val == 'Biofluids'
                                                                                                                                                        ? prereq = 'passing 108 credit hours & Heat mass transefer'
                                                                                                                                                        : val == 'Medical and paramedical procedures'
                                                                                                                                                            ? prereq = 'Heat mass transefer'
                                                                                                                                                            : prereq = null;
              });
            },
          ),
        ),
        SizedBox(height: 50),
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
                  ' Show ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  prereqshow();
                })),
      ]),
    );
  }

  prereqshow() {
    return AwesomeDialog(
        context: context,
        isDense: true,
        onDissmissCallback: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(DrawerS.routeName, (route) => false);
          Navigator.of(context).pushNamed(BoardScreen.routeName);
        },
        btnOkColor: Theme.of(context).primaryColor,
        btnOk: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      DrawerS.routeName, (route) => false);
                  Navigator.of(context).pushNamed(BoardScreen.routeName);
                })),
        body: Container(
          padding: EdgeInsets.all(8),
          width: double.maxFinite,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Text(
                ' Pre-requistites: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff2d377a),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              prereq == null ? 'Please Select Course' : '$prereq',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        customHeader: Container(
          decoration: decoration,
          padding: EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/prereq.png',
            height: 50,
          ),
        ),
        dialogType: DialogType.NO_HEADER)
      ..show();
  }
}
