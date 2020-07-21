import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class OrderInfoPage extends StatefulWidget {
  OrderInfoPage({Key key}) : super(key: key);

  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("訂單詳情")),
      body: Container(
        child: ListView(
          children: <Widget>[
            //收貨地址
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.add_location),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("張三  15201686455"),
                        SizedBox(height: 10),
                        Text("台南市永康區中華路 "),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 16),
            //列表
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: ScreenAdapter.width(120),
                        child: Image.network(
                            "https://www.itying.com/images/flutter/list2.jpg",
                            fit: BoxFit.cover),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("四季沐歌 (MICOE) 洗衣機水龍頭 洗衣機水嘴 單冷快開铜材質龍頭",
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.black54)),
                                Text("水龍頭 洗衣機",
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.black54)),
                                ListTile(
                                  leading: Text("\$100",
                                      style: TextStyle(color: Colors.red)),
                                  trailing: Text("x2"),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: ScreenAdapter.width(120),
                        child: Image.network(
                            "https://www.itying.com/images/flutter/list2.jpg",
                            fit: BoxFit.cover),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("四季沐歌 (MICOE) 洗衣機水龍頭 洗衣機水嘴 單冷快開铜材質龍頭",
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.black54)),
                                Text("水龍頭 洗衣機",
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.black54)),
                                ListTile(
                                  leading: Text("\$100",
                                      style: TextStyle(color: Colors.red)),
                                  trailing: Text("x2"),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),

            //詳情信息
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("訂單编号:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("124215215xx324")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("下單日期:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("2019-12-09")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("支付方式:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("微信支付")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("配送方式:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("順豐")
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Row(
                    children: <Widget>[
                      Text("總金額:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("\$414元", style: TextStyle(color: Colors.red))
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
