import 'dart:convert';

import 'package:begrateful/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var name="",password="";
  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("Name");
      password = prefs.getString("Password");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage.."),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child:Column(
          children: [
            Text("Name : "+name,style: TextStyle(fontSize: 20),),
            Text("Password : "+password,style: TextStyle(fontSize: 20),),

            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove("islogin");

                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> LoginPage())
                  );
                },
                child: Text("LogOut",style: TextStyle(fontSize: 20),)
            ),
          ],
        ),
      ),
    );
  }
}
