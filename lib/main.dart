import 'package:flutter/material.dart';
import 'package:gpa_calc/new_ui/screens/splash_screen.dart';
import 'package:hexcolor/hexcolor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _courseName;
  int _courseCredit = 1;
  double _courseScore = 4;
  List<Course> ? allCourses;
  var formKey = GlobalKey<FormState>();
  double average = 0;
  TextEditingController? textController;
  static int counter = 0;
  var _sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    allCourses = [];
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sKey,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#00FFAB'),
          child: Icon(Icons.add,color: Colors.black),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              textController!.text = "";
              _sKey.currentState!.showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  content: Text(
                    "Course added",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  )));
            }
          },
        ),
        appBar: AppBar(
          backgroundColor: HexColor('#00FFAB'),
          title: Text("GPA Calculator",
          style: TextStyle(
            color: Colors.black,
            fontSize:20,
            letterSpacing: 1
          ),
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return appBody(orientation);
            } else {
              return appBodyLandscape();
            }
          },
        ));
  }

  Widget appBody(var orientation) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.all(10),
            // color: HexColor('#E3FCBF'),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.length > 0) {
                          return null;
                        } else {
                          _sKey.currentState!.showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text(
                                "Failed",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              )));
                          return "Entre course name";
                        }
                      },
                      onSaved: (savedValue) {
                        _courseName = savedValue!;
                        setState(() {
                          allCourses!.add(
                              Course(_courseName, _courseScore, _courseCredit));
                          average = 0;
                          calculateAvg();
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,

                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: HexColor('#00FFAB'))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: HexColor('#00FFAB'))
                          ),
                          hintText: "Course Name",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color:HexColor('#00FFAB'),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          width: MediaQuery.of(context).size.width*0.33,
                          height: MediaQuery.of(context).size.width*0.1,
                          margin: EdgeInsets.only(top: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: DropdownButton<int>(
                            dropdownColor: HexColor('#00FFAB'),
                            items: courseCreditItems(),
                            iconEnabledColor: Colors.black,
                            value: _courseCredit,
                            onChanged: (selectedCredit) {
                              setState(() {
                                _courseCredit = selectedCredit!;
                              });
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color:HexColor('#00FFAB'),
                            borderRadius: BorderRadius.circular(20)

                          ),
                          height: MediaQuery.of(context).size.height*0.05,
                          margin: EdgeInsets.only(top: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: DropdownButton<double>(

                            dropdownColor: HexColor('#00FFAB'),
                            iconEnabledColor: Colors.black,
                            items: courseScoresItems(),
                            value: _courseScore,
                            onChanged: (selectedCourseScore) {
                              setState(() {
                                _courseScore = selectedCourseScore!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: HexColor('#00FFAB'), width: 2),
                                  bottom: BorderSide(
                                      color: HexColor('#00FFAB'), width: 2))),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: allCourses!.length == 0
                                              ? ""
                                              : "GPA: ",
                                          style: TextStyle(fontSize: 18,color: Colors.black,letterSpacing: 1)),
                                      TextSpan(
                                          text: allCourses!.length == 0
                                              ? "No course added !"
                                              : "${average.toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500)),
                                    ],
                                    //       child: Text(
                                    //     "Average: ",
                                    //     style: TextStyle(color: Colors.white),
                                    //   )),
                                    //   height: 70,
                                    // ),

                                    // Divider(
                                    //   indent: MediaQuery.of(context).size.height / 32,
                                    //   height: MediaQuery.of(context).size.height / 8,
                                    //   color: Colors.white,
                                    //   endIndent: MediaQuery.of(context).size.height / 32,
                                    // ),
                                  )))),
                    ),
                  ],
                )),
          ),

          //. DYNAMIC LIST CONTAINER
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemBuilder: _createListElements,
                itemCount: allCourses!.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> courseCreditItems() {
    List<DropdownMenuItem<int>> credits = [];

    for (int i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem(
          child: Text(
            "  $i Credit",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          value: i));
    }
    return credits;
  }

  List<DropdownMenuItem<double>> courseScoresItems() {
    List<DropdownMenuItem<double>> courseScores = [];
    courseScores.add(DropdownMenuItem(
      child: Text("A", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 4,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("A-", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 3.67,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("B+", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 3.33,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("B", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 3,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("B-", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 2.67,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("C+", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 2.33,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("C", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 2,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("C-", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 1.67,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("D+", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 1.33,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("D", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 1.0,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("F", style: TextStyle(color: Colors.black, fontSize: 20)),
      value: 0,
    ));
    return courseScores;
  }

  Widget _createListElements(BuildContext context, int index) {
    counter++;
    print(counter);
    return Dismissible(
      key: Key(counter.toString()),
      onDismissed: (dismiss) {
        setState(() {
          allCourses!.removeAt(index);
          print(allCourses!.length.toString() + "s");
          _sKey.currentState!.showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              content: Text(
                "Course deleted",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              )));
          calculateAvg();
        });
      },
      direction: DismissDirection.endToStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: HexColor('#B8F1B0'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(Icons.school_outlined)),
              title: Text(allCourses![index].name,style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(allCourses![index].credit.toString() + " Credit")),
        ),
      ),
    );
  }

  void calculateAvg() {
    double allScore = 0;
    double allCredit = 0;

    for (var currentCourse in allCourses!) {
      var credit = currentCourse.credit;
      var score = currentCourse.score;

      allScore = allScore + (score * credit);
      allCredit = allCredit + credit;
    }
    average = allScore / allCredit;
  }

  //. Landscape

  Widget appBodyLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue[900],
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: textController,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.length > 0) {
                            return null;
                          } else {
                            return "Course name cannot be blank!";
                          }
                        },
                        onSaved: (savedValue) {
                          _courseName = savedValue!;
                          setState(() {
                            allCourses!.add(Course(
                                _courseName, _courseScore, _courseCredit));
                            average = 0;
                            calculateAvg();
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Course Name",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: DropdownButton<int>(
                              dropdownColor: Colors.blue[800],
                              items: courseCreditItems(),
                              value: _courseCredit,
                              onChanged: (selectedCredit) {
                                setState(() {
                                  _courseCredit = selectedCredit!;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: DropdownButton<double>(
                              dropdownColor: Colors.blue[800],
                              items: courseScoresItems(),
                              value: _courseScore,
                              onChanged: (selectedCourseScore) {
                                setState(() {
                                  _courseScore = selectedCourseScore!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: BorderDirectional(
                                  top: BorderSide(
                                      color: Colors.orange, width: 2),
                                  bottom: BorderSide(
                                      color: Colors.orange, width: 2))),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: allCourses!.length == 0
                                              ? ""
                                              : "Average: ",
                                          style: TextStyle(fontSize: 16)),
                                      TextSpan(
                                          text: allCourses!.length == 0
                                              ? "No course added!"
                                              : "${average.toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 16,color: Colors.black)),
                                    ],
                                    //       child: Text(
                                    //     "Average: ",
                                    //     style: TextStyle(color: Colors.white),
                                    //   )),
                                    //   height: 70,
                                    // ),

                                    // Divider(
                                    //   indent: MediaQuery.of(context).size.height / 32,
                                    //   height: MediaQuery.of(context).size.height / 8,
                                    //   color: Colors.white,
                                    //   endIndent: MediaQuery.of(context).size.height / 32,
                                    // ),
                                  )))),
                    ],
                  )),
            ),
          ),
          //. DYNAMIC LIST CONTAINER
          Expanded(
            child: Container(
              color: Colors.blue[900],
              child: ListView.builder(
                itemBuilder: _createListElements,
                itemCount: allCourses!.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Course {
  String name;
  double score;
  int credit;

  Course(
      this.name,
      this.score,
      this.credit,
      );

  get getName => this.name;

  set setName(name) => this.name = name;

  get getScore => this.score;

  set setScore(score) => this.score = score;

  get getCredit => this.credit;

  set setCredit(credit) => this.credit = credit;
}