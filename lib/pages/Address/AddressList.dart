import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';

import '../../services/UserServices.dart';
import '../../services/SignServices.dart';

import '../../config/Config.dart';
import 'package:dio/dio.dart';

import '../../services/EventBus.dart';

class AddressListPage extends StatefulWidget {
  AddressListPage({Key key}) : super(key: key);

  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List addressList = [];

  @override
  void initState() {
    super.initState();
    this._getAddressList();

    //監聽增加收貨地址的廣播
    eventBus.on<AddressEvent>().listen((event) {
      // print(event.str);
      this._getAddressList();
    });
  }

  //監聽頁面銷毁的事件
  dispose() {
    super.dispose();
    eventBus.fire(new CheckOutEvent('改收貨地址成功...'));
  }

  //獲取收貨地址列表
  _getAddressList() async {
    //请求接口
    List userinfo = await UserServices.getUserInfo();

    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};

    var sign = SignServices.getSign(tempJson);

    var api =
        '${Config.domain}api/addressList?uid=${userinfo[0]['_id']}&sign=${sign}';

    var response = await Dio().get(api);
    // print(response.data["result"]);

    setState(() {
      this.addressList = response.data["result"];
    });
  }

  //修改默認收貨地址
  _changeDefaultAddress(id) async {
    List userinfo = await UserServices.getUserInfo();

    var tempJson = {
      "uid": userinfo[0]['_id'],
      "id": id,
      "salt": userinfo[0]["salt"]
    };

    var sign = SignServices.getSign(tempJson);

    var api = '${Config.domain}api/changeDefaultAddress';
    var response = await Dio()
        .post(api, data: {"uid": userinfo[0]['_id'], "id": id, "sign": sign});
    Navigator.pop(context);
  }

  //删除收貨地址

  _delAddress(id) async {
    List userinfo = await UserServices.getUserInfo();
    var tempJson = {
      "uid": userinfo[0]["_id"],
      "id": id,
      "salt": userinfo[0]["salt"]
    };

    var sign = SignServices.getSign(tempJson);

    var api = '${Config.domain}api/deleteAddress';
    var response = await Dio()
        .post(api, data: {"uid": userinfo[0]["_id"], "id": id, "sign": sign});
    this._getAddressList(); //删除收貨地址完成後重新獲取列表
  }

  //彈出框
  _showDelAlertDialog(id) async {
    var result = await showDialog(
        barrierDismissible: false, //表示點击灰色背景的时候是否消失彈出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息!"),
            content: Text("您確定要删除吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("確定"),
                onPressed: () async {
                  //执行删除操作
                  this._delAddress(id);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("收貨地址列表"),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: this.addressList.length,
                itemBuilder: (context, index) {
                  if (this.addressList[index]["default_address"] == 1) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.check, color: Colors.red),
                          title: InkWell(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "${this.addressList[index]["name"]}  ${this.addressList[index]["phone"]}"),
                                  SizedBox(height: 10),
                                  Text("${this.addressList[index]["address"]}"),
                                ]),
                            onTap: () {
                              this._changeDefaultAddress(
                                  this.addressList[index]["_id"]);
                            },
                            onLongPress: () {
                              this._showDelAlertDialog(
                                  this.addressList[index]["_id"]);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addressEdit',
                                  arguments: {
                                    "id": this.addressList[index]["_id"],
                                    "name": this.addressList[index]["name"],
                                    "phone": this.addressList[index]["phone"],
                                    "address": this.addressList[index]
                                        ["address"],
                                  });
                            },
                          ),
                        ),
                        Divider(height: 20),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          title: InkWell(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "${this.addressList[index]["name"]}  ${this.addressList[index]["phone"]}"),
                                  SizedBox(height: 10),
                                  Text("${this.addressList[index]["address"]}"),
                                ]),
                            onTap: () {
                              this._changeDefaultAddress(
                                  this.addressList[index]["_id"]);
                            },
                            onLongPress: () {
                              this._showDelAlertDialog(
                                  this.addressList[index]["_id"]);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addressEdit',
                                  arguments: {
                                    "id": this.addressList[index]["_id"],
                                    "name": this.addressList[index]["name"],
                                    "phone": this.addressList[index]["phone"],
                                    "address": this.addressList[index]
                                        ["address"],
                                  });
                            },
                          ),
                        ),
                        Divider(height: 20),
                      ],
                    );
                  }
                },
              ),
              Positioned(
                bottom: 0,
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(88),
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(88),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black26))),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Text("增加收貨地址", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/addressAdd');
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
