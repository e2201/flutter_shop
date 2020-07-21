import 'dart:async';

import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../services/ScreenAdapter.dart';
import 'dart:async'; //Timer定時器需要引入
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSecondPage extends StatefulWidget {
  Map arguments;
  RegisterSecondPage({Key key, this.arguments}) : super(key: key);

  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  String tel;
  bool sendCodeBtn = false;
  int seconds = 10;
  String code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel = widget.arguments['tel'];
    this._showTimer();
  }

  //倒計時
  _showTimer() {
    Timer t;
    t = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        this.seconds--;
      });
      if (this.seconds == 0) {
        t.cancel(); //清除定時器
        setState(() {
          this.sendCodeBtn = true;
        });
      }
    });
  }

  //重新發送驗証碼
  sendCode() async {
    setState(() {
      this.sendCodeBtn = false;
      this.seconds = 10;
      this._showTimer();
    });
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": this.tel});
    if (response.data["success"]) {
      print(response); //演示期間服務器直接返回  给手機發送的驗証碼
    }
  }
  //驗証驗証碼

  validateCode() async {
    var api = '${Config.domain}api/validateCode';
    var response =
        await Dio().post(api, data: {"tel": this.tel, "code": this.code});
    if (response.data["success"]) {
      Navigator.pushNamed(context, '/registerThird',
          arguments: {"tel": this.tel, "code": this.code});
    } else {
      Fluttertoast.showToast(
        msg: '${response.data["message"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第二步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("驗証碼已經發送到了您的${this.tel}手機，請輸入${this.tel}手機号收到的驗証碼"),
            ),
            SizedBox(height: 40),
            Stack(
              children: <Widget>[
                Container(
                  child: JdText(
                    text: "請輸入驗証碼",
                    onChanged: (value) {
                      // print(value);
                      this.code = value;
                    },
                  ),
                  height: ScreenAdapter.height(100),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: this.sendCodeBtn
                      ? RaisedButton(
                          child: Text('重新發送'),
                          onPressed: this.sendCode,
                        )
                      : RaisedButton(
                          child: Text('${this.seconds}秒後重發'),
                          onPressed: () {},
                        ),
                )
              ],
            ),
            SizedBox(height: 20),
            JdButton(
              text: "下一步",
              color: Colors.red,
              height: 74,
              cb: this.validateCode,
            )
          ],
        ),
      ),
    );
  }
}
