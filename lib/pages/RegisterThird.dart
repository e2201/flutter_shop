import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../services/ScreenAdapter.dart';

import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/Storage.dart';
import 'dart:convert';
//引入Tabs

import '../pages/tabs/Tabs.dart';

class RegisterThirdPage extends StatefulWidget {
  Map arguments;
  RegisterThirdPage({Key key, this.arguments}) : super(key: key);

  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  String tel;
  String code;
  String password = '';
  String rpassword = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel = widget.arguments["tel"];
    this.code = widget.arguments["code"];
  }

  //注册
  doRegister() async {
    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: '密碼長度不能小於6位',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (rpassword != password) {
      Fluttertoast.showToast(
        msg: '密碼和確認密碼不一致',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      var api = '${Config.domain}api/register';
      var response = await Dio().post(api, data: {
        "tel": this.tel,
        "code": this.code,
        "password": this.password
      });
      if (response.data["success"]) {
        //保存用户信息
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));

        //返回到根
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new Tabs()),
            (route) => route == null);
      } else {
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第三步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "請輸入密碼",
              password: true,
              onChanged: (value) {
                this.password = value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: "請輸入確認密碼",
              password: true,
              onChanged: (value) {
                this.rpassword = value;
              },
            ),
            SizedBox(height: 20),
            JdButton(
              text: "注册",
              color: Colors.red,
              height: 74,
              cb: doRegister,
            )
          ],
        ),
      ),
    );
  }
}
