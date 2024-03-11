import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/config/ip.config.dart';
import 'package:todoapp/constants/colors.dart';
import 'package:todoapp/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/tiling/tiling.dart';

class HomePage extends StatefulWidget {
  final token;
  HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String id;
  late String email;
  List todos = [];
  List found = [];
  TextEditingController _addtask = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var selectedmenu = 0;

  void onitemTapped(int item) {
    setState(() {
      selectedmenu = item;
    });
  }

  void readdata() async {
    var req = {"email": email};
    var response = await http.post(Uri.parse(read),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(req));
    print(email);
    var decoded = jsonDecode(response.body)['td']['description'];
    // print(jsonDecode(response.body)['td']['description']);
    todos = decoded;
    found = todos;
    setState(() {});
    // found = todos;
    print(todos);
  }

  void addtask() async {
    if (_addtask.text.isNotEmpty) {
      print(_addtask.text);
      var regbody = {"email": email, "description": _addtask.text};
      var response = await http.post(Uri.parse(todo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody));
      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse);
      if (jsonresponse['status'] == 200) {
        todos.add(_addtask.text.trim());
        found = todos;
        print("add ");
        print(todos);
        setState(() {});
      } else {
        print("not work in homepage");
      }
      _addtask.clear();
    }
  }

  void deletetask(String item) async {
    var deletetodo = {"email": email, "item": item};
    var response = await http.post(Uri.parse(delete),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletetodo));
    var jsonresponse = jsonDecode(response.body);
    print(jsonresponse);
    if (jsonresponse['status'] == 200) {
      todos.remove(item);
      found = todos;
      print("delete task ");
      print(todos);
      setState(() {});
    } else {
      print("delete is not work");
    }
  }

  void _runfilter(String enteredkeyword) {
    List result = [];
    if (enteredkeyword.isEmpty) {
      result = todos;
    } else {
      result = todos
          .where((user) =>
              user.toLowerCase().contains(enteredkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      found = result;
    });
  }

  @override
  void initState() {
    // print("init");
    // print(todos);
    try {
      Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
      id = jwtdecodedtoken['_id'];
      email = jwtdecodedtoken['email'];
    } catch (err) {
      print("invalid token at homepage");
      id = "";
      email = "";
    }
    setState(() {
      readdata();
    });
    super.initState();
    // found = todos;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData.dark();
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey2,
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('T O D O'),
            GestureDetector(
              child: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString("token", "");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => registerpage()));
              },
            )
          ]),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => _runfilter(value),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('S E A R C H'),
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, mainAxisSpacing: 1),
                  itemCount: found.length,
                  itemBuilder: (context, index) {
                    // readdata();
                    return todo_tile(
                      text: found[index],
                      deletetask: (context) => deletetask(found[index]),
                      index: index,
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 170,
          width: 350,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20, left: 20),
                  width: double.infinity,
                  child: Form(
                    key: _formkey,
                    child: TextFormField(
                      controller: _addtask,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            'E n t e r  T a s k',
                            style: TextStyle(color: Colors.white),
                          )),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Enter Task';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (_formkey.currentState!.validate() &&
                            _addtask.text.trim() != "") {
                          addtask();
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(3, 3),
                                  spreadRadius: 1.0,
                                  blurRadius: 2),
                              BoxShadow(
                                color: Colors.white30,
                                blurRadius: 3,
                                offset: Offset(-1, -1),
                                spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(7)),
                        child: const Center(
                            child: Text(
                          'A D D',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        _addtask.clear();
                      },
                      child: Container(
                        // color: Colors.amber,
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(3, 3),
                                  spreadRadius: 1.0,
                                  blurRadius: 2),
                              BoxShadow(
                                color: Colors.white30,
                                blurRadius: 3,
                                offset: Offset(-1, -1),
                                spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(7)),
                        child: const Center(
                            child: Text(
                          'C A N C E L',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('M E N U ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text(
                  'H O M E',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                selected: selectedmenu == 0,
                onTap: () {
                  (selectedmenu != 0) ? onitemTapped(0) : print("");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
