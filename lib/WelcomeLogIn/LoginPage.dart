import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Appointments.dart';
import 'package:connect/Main_Page.dart';
import 'package:connect/WelcomeLogIn/About.dart';
import 'package:flutter/material.dart';
import 'package:connect/Posts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static String userID = "";
  static String userName = "";
  static String roll = "";
  static List<String> Schedule = [];
  static List<String> Friends = [];
  static String courseName = "";
  static List<Map<String, Map<String, List<String>>>> categories = [];
  static Appointments app = Appointments(
      id: "1192016",
      subject: "subject",
      description: "description",
      date: DateTime(2024, 9, 9, 9),
      startTime: DateTime(2024, 9, 9, 9),
      appointmentLength: 2,
      location: "location",
      status: "Private");

  static Future<void> saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', userID);
    await prefs.setString('roll', roll);
    await prefs.setStringList('Schedule', Schedule);
    await prefs.setStringList('Friends', Friends);
    await prefs.setString('courseName', courseName);
    // Serialize and save other complex data if needed
  }

  static Future<void> loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
    roll = prefs.getString('roll') ?? '';
    Schedule = prefs.getStringList('Schedule') ?? [];
    Friends = prefs.getStringList('Friends') ?? [];
    courseName = prefs.getString('courseName') ?? '';
    // Deserialize and load other complex data if needed
  }
}

Future<int> fetchData(List<Posts> posts) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Posts').get();
  querySnapshot.docs.forEach((doc) {
    var field1 = doc.get("caption");
    var field2 = doc.get("likeCounter");
    var field3 = doc.get("postImageUrl");
    var field4 = doc.get("userImageUrl");
    var field5 = doc.get("userName");

    Posts post = Posts(
        caption: field1,
        likeCounter: field2,
        postImageUrl: field3,
        userImageUrl: field4,
        userName: field5);
    posts.add(post);
  });
  return 0;
}

Future<bool> fetchUserData(String email, String password) async {
  bool check = false;
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();
  querySnapshot.docs.forEach((doc) {
    var myemail = doc.get("email");
    var mypassword = doc.get("password");

    if (myemail == email && mypassword == password) {
      check = true;
      Globals.userID = doc.get("firstName");
      Globals.roll = doc.get("role");
      List<dynamic> scheduleFromFirestore = doc.get("Schedule");
      Globals.Schedule = List<String>.from(
          scheduleFromFirestore.map((schedule) => schedule.toString()));
      Globals.Schedule.addAll(['Private', 'Public']);
      List<dynamic> friendsFromFirestore = doc.get("Friends");
      Globals.Friends = List<String>.from(
          friendsFromFirestore.map((friends) => friends.toString()));
      Globals.saveToPreferences();
    }
  });
  return check;
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _keepLoggedIn = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepLoggedIn = prefs.getBool('keepLoggedIn') ?? false;
      if (_keepLoggedIn) {
        _usernameController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
        Globals.loadFromPreferences();
      }
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepLoggedIn', _keepLoggedIn);
    if (_keepLoggedIn) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.deepPurple.shade700,
            Colors.deepPurpleAccent,
            Colors.purple.shade300
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 2200),
                          child: CheckboxListTile(
                            title: Text("Remember Me"),
                            value: _keepLoggedIn,
                            onChanged: (newValue) {
                              setState(() {
                                _keepLoggedIn = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await fetchUserData(
                                        _usernameController.text,
                                        _passwordController.text)) {
                                      _saveCredentials();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Main_Page()));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Login Failed'),
                                              content: Text(
                                                  'Incorrect email or password.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.deepPurpleAccent),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 2000),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutPage()),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey),
                                    child: Center(
                                      child: Text(
                                        "About",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 2100),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    const url =
                                        'https://www.example.com/signup';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue),
                                    child: Center(
                                      child: Text(
                                        "Ritaj",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
