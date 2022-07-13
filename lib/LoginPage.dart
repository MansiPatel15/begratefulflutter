import 'dart:convert';

import 'package:begrateful/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  checklogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("islogin"))
    {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => HomePage())
      );
    }
  }
  //Page Load
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginPage..."),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _name,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter A Name',
                    focusColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Password :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  autofocus: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter A Password',
                    focusColor: Colors.purple,
                  ),
                  validator: (value)
                  {
                    if (value.isEmpty)
                    {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        if(_form.currentState.validate())
                          {
                            var name = _name.text.toString();
                            var pass = _password.text.toString();
                            
                            Uri url = Uri.parse("https://begratefulapp.ca/api/login");
                            Map<String,String> params = {
                              "name":name,
                              "password":pass,
                              "device_token":"123432",
                              "device_os":"android",
                            };
                            Map<String,String> headers = {
                              "Content-Type":"application/json",
                            };

                            var response = await http.post(url,body:jsonEncode(params),headers: headers);
                            if(response.statusCode==200)
                              {
                                var body = response.body.toString();
                                var json = jsonDecode(body);
                                var message =
                                json["message"].toString();

                                if(json["result"]=="success")
                                  {
                                    Fluttertoast.showToast(
                                      msg: message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                    );
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString("Name", name);
                                    prefs.setString("Password", pass);
                                    prefs.setString("islogin","yes");

                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => HomePage()));
                                  }
                                else
                                  {
                                    Fluttertoast.showToast(
                                      msg: message,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                    );
                                  }
                              }
                          }

                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
