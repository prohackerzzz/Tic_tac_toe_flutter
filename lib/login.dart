import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/sign_up.dart';
import 'package:tic_tac_toe/main.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<FirebaseApp> _fbinit() async {
    FirebaseApp fireb = await Firebase.initializeApp();

    return fireb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _fbinit(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Screen();
            }
            return const Center(child: const CircularProgressIndicator());
          }),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  static Future<User?> loginfunc(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    try {
      UserCredential usercr =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
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
              User? user = await loginfunc(
                  email: _emailc.text, pass: _passc.text, context: context);
              if (user != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Start()));
              }
            },
            child: Text("Login")),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sign_up()));
            },
            child: Text("SignUp"))
      ]),
    )));
  }
}
