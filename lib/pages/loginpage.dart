import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/config/ip.config.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/pages/HomePage.dart';
import 'package:todoapp/pages/register_page.dart';
import 'package:http/http.dart' as http;

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    final globalkey = GlobalKey<FormState>();
    final globalkey1 = GlobalKey<FormState>();
    TextEditingController cntrl1 = TextEditingController();
    TextEditingController cntrl2 = TextEditingController();

    void loginuser() async {
      if (cntrl1.text.isNotEmpty && cntrl2.text.isNotEmpty) {
        print(cntrl1.text);
        print(cntrl2.text);
        var regbody = {"email": cntrl1.text, "password": cntrl2.text};
        var response = await http.post(Uri.parse(login),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regbody));
        var jsonresponse = jsonDecode(response.body);
        print(jsonresponse);
        var prefs = await SharedPreferences.getInstance();
        String mytoken = jsonresponse['token'];
        prefs.setString("token", mytoken);
        if (jsonresponse['status'] == 200) {
          print(mytoken);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage(
              token: mytoken,
            );
          }));
        } else {
          print("not work");
        }
      }
    }

    return Scaffold(
      // backgroundColor: grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.login,
            size: 100,
            color: lightblue,
            shadows: [
              Shadow(color: white, offset: Offset(-5, 5), blurRadius: 10)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Welcome back, You\'ve been missed',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w200, color: white),
            ),
          ),
          Form(
            key: globalkey,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextFormField(
                controller: cntrl1,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    label: Text('E M A I L'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
            ),
          ),
          Form(
            key: globalkey1,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: TextFormField(
                obscureText: true,
                controller: cntrl2,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    label: Text('P A S S W O R D'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                if (globalkey.currentState!.validate() &&
                    globalkey1.currentState!.validate()) {
                  loginuser();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 131, 79, 219),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a Member? ',
                style: TextStyle(color: white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return registerpage();
                  }));
                },
                child: const Text(
                  'Register Now',
                  style: TextStyle(color: blue, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void initSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getString("token") == "") {
        print("nulll");
      } else {
        print(prefs.getString("token"));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(token: prefs.getString(("token"))),
            ));
      }
    } catch (err) {
      print("Token is expired");
    }
  }
}
