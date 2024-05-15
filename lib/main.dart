import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Appointments.dart';
import 'package:connect/Main_Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect/Posts.dart';

class Globals {
  static String userID = "";
  static String roll = "";
  static List<String> Schedule = [];
  static Appointments app = Appointments(
      id: "1192016",
      subject: "subject",
      description: "description",
      date: DateTime(2024, 9, 9, 9),
      startTime: DateTime(2024, 9, 9, 9),
      appointmentLength: 2,
      location: "location",
      status: "Private");
}

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDK07y9RLzWSoLPrxAgY_gegeL-_qNsY8M",
        appId: "1:476838126677:android:a4b14bb36537f271d960dc",
        messagingSenderId: "476838126677",
        projectId: "campus-connect-3917b",
        storageBucket: "campus-connect-3917b.appspot.com"),
  );
  runApp(const MyApp());
}

Future<int> fetchData(List<Posts> posts) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Posts').get();
  querySnapshot.docs.forEach((doc) {
    // Accessing individual fields

    var field1 = doc.get("caption");
    var field2 = doc.get("likeCounter");
    var field3 = doc.get("postImageUrl");
    var field4 = doc.get("userImageUrl");
    var field5 = doc.get("userName");

    // Do whatever you need with the fields
    print('Field 1: $field1');
    print('Field 2: $field2');
    print('Field 3: $field3');
    print('Field 3: $field4');
    print('Field 3: $field5');
    //print(split[0] + " " + split[1] + " " + split[2] + " HEY");
    Posts post = Posts(
        caption: field1,
        likeCounter: field2,
        postImageUrl: field3,
        userImageUrl: field4,
        userName: field5);
    posts.add(post);
    /*for (Posts obj in posts) {
      print("ID: ${obj.userName}, Name: ${obj.userImageUrl}");
    } */
  });
  return 0;
}

Future<bool> fetchUserData(String email, String password) async {
  bool check = false;
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();
  querySnapshot.docs.forEach((doc) {
    // Accessing individual fields

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
    }
  });
  return check;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Connect Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue)),
                //--------------------------------------------------------------->
                onPressed: () async {
                  String email = usernameController.text;
                  String password = passwordController.text;
                  if (await fetchUserData(email, password)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Main_Page()),
                    );
                  }
                },
                //---------------------------------------------------------------------->
                child: const Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
