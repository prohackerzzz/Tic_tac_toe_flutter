import 'package:flutter/material.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key}) : super(key: key);

  @override
  State<Sign_up> createState() => _SignupState();
}

class _SignupState extends State<Sign_up> {
  Future create_user(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    try {
      UserCredential usercr = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      user = usercr.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("user nahi mila");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailc = TextEditingController();
    TextEditingController _passc = TextEditingController();
    return Material(
        child: Center(
            child: Container(
      color: Colors.white,
      height: 200,
      child: Column(children: [
        TextFormField(
          controller: _emailc,
          decoration: InputDecoration(
              hintText: "Email", prefixIcon: Icon(Icons.person)),
        ),
        TextFormField(
            controller: _passc,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Password", prefixIcon: Icon(Icons.lock))),
        ElevatedButton(
            onPressed: () async {
              User? user = await create_user(
                  email: _emailc.text, pass: _passc.text, context: context);
              if (user != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Start()));
              }
            },
            child: Text("SignUp"))
      ]),
    )));
  }
}
