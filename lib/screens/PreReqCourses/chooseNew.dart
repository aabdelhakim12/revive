import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:revive/widgets/drawer.dart';

import 'CoursesScreen.dart';

class ChooseNew extends StatefulWidget {
  @override
  _ChooseNewState createState() => _ChooseNewState();
}

String _level = 'Level 000';
String prereq;
var decoration = BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xff2a61a8), Color(0xff2d377a)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft),
  borderRadius: BorderRadius.circular(15),
);

final List<String> level000 = [
  'Mathematics (1)',
  'Mechanics (1)',
  'Physics (1)',
  'English (1)',
  'Engineering Drawing',
  'Fundamentals of Engineering Chemistry',
  'Mathematics (2)',
  'Mechanics (2)',
  'Physics (2)',
  'English (2)',
  'Principals of Manufacturing Engineering',
  'Introduction to Computer Systems',
  ' ',
];
final List<String> level100 = [
  'Mathematics (3)',
  'Statistics & Probability Theory',
  'Digital Design',
  'Strength of Materials',
  'Electrical Circuits',
  'Technical Reports Writing',
  'Mathematics (4)',
  'Electronics (1)',
  'Algorithms and Data Structures',
  'Power and Electrical Machines',
  'History of Engineering and Technology',
  'Organic Chemistry',
  'Practical Training',
];

final List<String> level200 = [
  'Mathematics (5)',
  'Electromagnetic Fields',
  'Presentation and Communications Skills',
  'Biochemistry',
  'Introduction to Anatomy',
  'Automatic Control',
  'Introduction to Physiology',
  'Measurements and Instrumentations',
  'Sensors and Actuators',
  'Electronics (2)',
  'Signal Analysis',
  'Law and Human Rights',
  'Field Training 1',
];

final List<String> level300 = [
  'Microbiology',
  'Biomedical Instrumentations',
  'Digital Signal Processing',
  'Biomaterial Properties',
  'Clinical Engineering',
  'Digital Image Processing',
  'Embedded Systems',
  'Bioinformatics',
  'Project (1) in BME',
  'Field Training 2',
  ' ',
  ' ',
  ' ',
];

final List<String> level400 = [
  'Biomedical Imaging',
  'Medical Equipment (1)',
  'Project (2) in BME',
  'Medical Equipment (2)',
  'Database Systems',
  'Project (3) in BME',
  'Ethics and Morals of the Profession',
  'Marketing',
  'Project Management',
  ' ',
  ' ',
  ' ',
  ' ',
];

final List<String> elective = [
  'Medical Decision Support Systems (MDSS)',
  'Healthcare Information Systems (HCIS)',
  'Internet of Medical Things (IoMT)',
  'Public Health',
  'Opto-electronics',
  'Pattern Recognition',
  'Introduction to Deep Learning',
  'Introduction to Nanotechnology',
  'Medical and Pharmaceutical Procedures',
  'Fluid Flow in Bio-Systems',
  'Clinical Pathology',
  'Industrial Pharmacy',
  ' ',
];

class _ChooseNewState extends State<ChooseNew> {
  var sems = {
    'Level 000': level000,
    'Level 100': level100,
    'Level 200': level200,
    'Level 300': level300,
    'Level 400': level400,
    'Elective Courses': elective,
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
            hint: Text(_level),
            items: [
              'Level 000',
              'Level 100',
              'Level 200',
              'Level 300',
              'Level 400',
              'Elective Courses',
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
                _level = value.toString();
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
            items: sems[_level].map((String course) {
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
                String val = value.toString();
                val == 'Mathematics (1)' ||
                        val == 'Mechanics (1)' ||
                        val == 'Physics (1)' ||
                        val == 'English (1)' ||
                        val == 'Engineering Drawing' ||
                        val == 'Fundamentals of Engineering Chemistry' ||
                        val == 'Physics (2)' ||
                        val == 'Principals of Manufacturing Engineering' ||
                        val == 'Introduction to Computer Systems' ||
                        val == 'Practical Training' ||
                        val == 'Organic Chemistry' ||
                        val == 'Power and Electrical Machines' ||
                        val == 'History of Engineering and Technology' ||
                        val == 'Introduction to Anatomy' ||
                        val == 'Presentation and Communications Skills' ||
                        val == 'Law and Human Rights' ||
                        val == 'Marketing' ||
                        val == 'Project Management' ||
                        val == 'Ethics and Morals of the Profession'
                    ? prereq = 'No Pre-requistites'
                    : val == 'Mathematics (2)'
                        ? prereq = 'Mathematics (1)'
                        : val == 'English (2)'
                            ? prereq = 'English (1)'
                            : val == 'Mechanics (2)'
                                ? prereq = 'Mechanics (1)'
                                : val == 'Mathematics (3)' ||
                                        val == 'Statistics & Probability Theory'
                                    ? prereq = 'Mathematics (2)'
                                    : val == 'Strength of Materials'
                                        ? prereq = 'Mechanics (1) & Physics (1)'
                                        : val == 'Electrical Circuits'
                                            ? prereq = 'Physics (2)'
                                            : val == 'Technical Reports Writing'
                                                ? prereq = 'English (2)'
                                                : val == 'Mathematics (4)' ||
                                                        val ==
                                                            'Mathematics (5)' ||
                                                        val ==
                                                            'Automatic Control' ||
                                                        val == 'Signal Analysis'
                                                    ? prereq = 'Mathematics (3)'
                                                    : val == 'Algorithms and Data Structures' ||
                                                            val ==
                                                                'Database Systems' ||
                                                            val ==
                                                                'Digital Design'
                                                        ? prereq =
                                                            'Introduction to Computer Systems'
                                                        : val == 'Electronics (1)' ||
                                                                val ==
                                                                    'Measurements and Instrumentations'
                                                            ? prereq =
                                                                'Electrical Circuits'
                                                            : val ==
                                                                    'Electromagnetic Fields'
                                                                ? prereq =
                                                                    'Electrical Circuits & Mathematics (3)'
                                                                : val ==
                                                                        'Biochemistry'
                                                                    ? prereq =
                                                                        'Organic Chemistry'
                                                                    : val ==
                                                                            'Introduction to Physiology'
                                                                        ? prereq =
                                                                            'Introduction to Anatomy'
                                                                        : val ==
                                                                                'Electronics (2)'
                                                                            ? prereq =
                                                                                'Electronics (1)'
                                                                            : val == 'Sensors and Actuators' || val == 'Embedded Systems'
                                                                                ? prereq = 'Automatic Control'
                                                                                : val == 'Microbiology'
                                                                                    ? prereq = 'Biochemistry'
                                                                                    : val == 'Biomedical Instrumentations'
                                                                                        ? prereq = 'Introduction to Physiology & Measurements and Instrumentations'
                                                                                        : val == 'Digital Signal Processing'
                                                                                            ? prereq = 'Signal Analysis'
                                                                                            : val == 'Biomaterial Properties'
                                                                                                ? prereq = 'Strength of Materials'
                                                                                                : val == 'Clinical Engineering'
                                                                                                    ? prereq = 'Introduction to Physiology & Biomedical Instrumentations'
                                                                                                    : val == 'Digital Image Processing' || val == 'Bioinformatics'
                                                                                                        ? prereq = 'Digital Signal Processing'
                                                                                                        : val == ' '
                                                                                                            ? prereq = 'Please Select Course'
                                                                                                            : val == 'Project (1) in BME' || val == 'Medical Decision Support Systems (MDSS)' || val == 'Field Training 1'
                                                                                                                ? prereq = 'Passing 96 Hours'
                                                                                                                : val == 'Project (2) in BME' || val == 'Project (3) in BME' || val == 'Field Training 2'
                                                                                                                    ? prereq = 'Passing 128 Hours'
                                                                                                                    : val == 'Biomedical Imaging'
                                                                                                                        ? prereq = 'Digital Image Processing'
                                                                                                                        : val == 'Medical Equipment (1)' || val == 'Medical Equipment (2)'
                                                                                                                            ? prereq = 'Biomedical Instrumentations'
                                                                                                                            : val == 'Healthcare Information Systems (HCIS)' || val == 'Internet of Medical Things (IoMT)'
                                                                                                                                ? prereq = 'Algorithms and Data Structures & Passing 96 Hours'
                                                                                                                                : val == 'Fluid Flow in Bio-Systems' || val == 'Clinical Pathology'
                                                                                                                                    ? prereq = 'Introduction to Physiology & Passing 96 Hours'
                                                                                                                                    : val == 'Public Health'
                                                                                                                                        ? prereq = 'Statistics & Probability Theory & Biochemistry & Passing 96 Hours'
                                                                                                                                        : val == 'Opto-electronics' || val == 'Introduction to Nanotechnology'
                                                                                                                                            ? prereq = 'Electronics (2) & Passing 96 Hours'
                                                                                                                                            : val == 'Pattern Recognition'
                                                                                                                                                ? prereq = 'Digital Image Processing & Passing 96 Hours'
                                                                                                                                                : val == 'Introduction to Deep Learning'
                                                                                                                                                    ? prereq = 'Biomedical Instrumentations & Digital Signal Processing & Passing 96 Hours'
                                                                                                                                                    : val == 'Medical and Pharmaceutical Procedures' || val == 'Industrial Pharmacy'
                                                                                                                                                        ? prereq = 'Biochemistry & Passing 96 Hours'
                                                                                                                                                        : prereq = 'Please Select Sourse';
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
