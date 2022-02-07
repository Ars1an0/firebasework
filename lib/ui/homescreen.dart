import 'package:firebaseintegrate/ui/login.dart';
import 'package:firebaseintegrate/ui/resetscreen.dart';
import 'package:firebaseintegrate/ui/verifyemail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();


    void register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final String email = emailcontroller.text;
      final String password = passwordcontroller.text;
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        print(e);
      }

      print("register");
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [

              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Email'),
              ),
              TextFormField(
                controller: passwordcontroller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Password'),
              ),
              ElevatedButton(onPressed:(){register(); Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VeifyEmail()),
              );
              } , child: Text("Sign Up")),
              ElevatedButton(onPressed: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );}, child: Text("Login")),
              ElevatedButton(onPressed: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetScreen()),
              );}, child: Text("Reset")),
            ],
          ),
        ),
      ),
    );
  }
}




