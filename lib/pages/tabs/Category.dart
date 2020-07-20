import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/ScreenAdapter.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../model/CateModel.dart';

import '../../shared/loading.dart';
// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("CategoryPage"),
//     );
//   }
// }

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _getLeftCateData();
    print("category");
  }

  //左側分類
  _getLeftCateData() async {
    var api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    // print(result.data is Map);
    // print(result.data['result']);
    // result.data['result'].forEach((element) {
    //   Firestore.instance
    //       .collection('/leftcateList')
    //       .document()
    //       .setData(element);
    // });
    // var leftCateList = new CateModel.fromJson(result.data);
    // // print(leftCateList.result);
    // setState(() {
    //   this._leftCateList = leftCateList.result;
    // });
    // _getRightCateData(leftCateList.result[0].sId);
    _getRightCateData(result.data['result'][0]['_id']);
  }

  //右側分類
  _getRightCateData(pid) async {
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    // var rightCateList = new CateModel.fromJson(result.data);
    // print(rightCateList.result);
    print(result.data['result']);
    setState(() {
      this._rightCateList = result.data['result'];
    });
  }

  Widget _leftCateWidget(leftWidth) {
    // if (this._leftCateList.length > 0) {
    return StreamBuilder(
        stream: Firestore.instance.collection('/leftcateList')?.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container(
              child: Loading(),
            );
          }
          List<DocumentSnapshot> docs = snap.data.documents;
          return Container(
            width: leftWidth,
            height: double.infinity,
            // color: Colors.red,
            child: ListView.builder(
              // itemCount: this._leftCateList.length,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectIndex = index;
                          // this._getRightCateData(this._leftCateList[index].sId);
                          this._getRightCateData(docs[index]['_id']);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: ScreenAdapter.height(84),
                        padding: EdgeInsets.only(top: ScreenAdapter.height(24)),
                        // child: Text("${this._leftCateList[index].title}",
                        child: Text("${docs[index]['title']}",
                            textAlign: TextAlign.center),
                        color: _selectIndex == index
                            ? Color.fromRGBO(240, 246, 246, 0.9)
                            : Colors.white,
                      ),
                    ),
                    Divider(height: 1),
                  ],
                );
              },
            ),
          );
        });
    // } else {
    //   return Container(width: leftWidth, height: double.infinity);
    // }
  }

  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: rightItemWidth / rightItemHeight,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: this._rightCateList.length,
              itemBuilder: (context, index) {
                //處理图片
                // String pic = this._rightCateList[index].pic;
                String pic = this._rightCateList[index]['pic'];
                pic = Config.domain + pic.replaceAll('\\', '/');

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/productList',
                        // arguments: {"cid": this._rightCateList[index].sId});
                        arguments: {"cid": this._rightCateList[index]['_id']});
                  },
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.network("${pic}", fit: BoxFit.cover),
                        ),
                        Container(
                          height: ScreenAdapter.height(28),
                          child: Text("${this._rightCateList[index]['title']}"),
                          // child: Text("${this._rightCateList[index].title}"),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
      );
    } else {
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("加載中..."),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //注意用ScreenAdapter必须得在build方法里面初始化
    ScreenAdapter.init(context);

    //左側宽度
    var leftWidth = ScreenAdapter.getScreenWidth() / 4;
    //右側每一项宽度=（总宽度-左側宽度-GridView外側元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth =
        (ScreenAdapter.getScreenWidth() - leftWidth - 20 - 20) / 3;
    //获取计算后的宽度
    rightItemWidth = ScreenAdapter.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdapter.height(28);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak, size: 28, color: Colors.black87),
          onPressed: null,
        ),
        title: InkWell(
          child: Container(
            height: ScreenAdapter.height(68),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                Text("筆記本", style: TextStyle(fontSize: ScreenAdapter.size(28)))
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message, size: 28, color: Colors.black87),
            onPressed: null,
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          _leftCateWidget(leftWidth),
          _rightCateWidget(rightItemWidth, rightItemHeight)
        ],
      ),
    );
  }
}
