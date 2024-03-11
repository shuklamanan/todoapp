import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapp/config/ip.config.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/pages/loginpage.dart';
import 'package:http/http.dart' as http;

class registerpage extends StatelessWidget {
  const registerpage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalkey = GlobalKey<FormState>();
    final globalkey1 = GlobalKey<FormState>();
    TextEditingController cntrl1 = TextEditingController();
    TextEditingController cntrl2 = TextEditingController();

    void registeruser() async {
      if (cntrl1.text.isNotEmpty && cntrl2.text.isNotEmpty) {
        print(cntrl1.text);
        print(cntrl2.text);
        var regbody = {"email": cntrl1.text, "password": cntrl2.text};
        var response = await http.post(Uri.parse(registration),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regbody));
        var jsonresponse = jsonDecode(response.body);
        print(jsonresponse['status']);
        if (jsonresponse['status'] == 200) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return loginpage();
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
              Shadow(color: white, offset: Offset(0, 5), blurRadius: 10)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Fill The Details',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w300, color: white),
            ),
          ),
          Form(
            key: globalkey,
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                  registeruser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
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
                    'Sign Up',
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
                'Already a Member? ',
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return loginpage();
                  }));
                },
                child: const Text(
                  'Login Now',
                  style: TextStyle(color: blue, fontWeight: FontWeight.w600),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
