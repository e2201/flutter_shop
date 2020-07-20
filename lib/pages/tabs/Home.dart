import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../model/ProductModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../services/ScreenAdapter.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
// import '../../services/SignServices.dart';
import '../../shared/loading.dart';
// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
//輪播圖類模型
import '../../model/FocusModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List _focusData = [];
  List _hotProductList = [];
  List _bestProductList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getFocusData();
    // _getHotProductData();
    // _getBestProductData();
    //     // SignServices.getSign();
  }

  //獲取輪播圖數據
  _getFocusData() async {
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    //Save to Cloud FireBase
    print(result.data is Map);
    print(result.data['result']);
    result.data['result'].forEach((element) {
      Firestore.instance.collection('/focus').document().setData(element);
    });
    //-----------------------------------------------
    // var focusList = FocusModel.fromJson(result.data);
    // setState(() {
    //   this._focusData = focusList.result;
    // });
  }

  //   //獲取猜你喜歡的數據
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    result.data['result'].forEach((element) {
      Firestore.instance.collection('/hotproducts').document().setData(element);
    });
    // var hotProductList = ProductModel.fromJson(result.data);
    // setState(() {
    //   this._hotProductList = hotProductList.result;
    // });
  }

  //   //獲取熱門推薦的數據
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    print(result.data is Map);
    print(result.data['result']);
    result.data['result'].forEach((element) {
      Firestore.instance
          .collection('/bestproducts')
          .document()
          .setData(element);
    });
    // var bestProductList = ProductModel.fromJson(result.data);
    // setState(() {
    //   this._bestProductList = bestProductList.result;
    // });
  }

  Widget _swiperWidget1() {
    return StreamBuilder(
        stream: Firestore.instance.collection('/focus')?.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container(
              child: Loading(),
            );
          }
          List<DocumentSnapshot> docs = snap.data.documents;
          // print(docs is Map);
          return Container(
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    // String pic = docs[index].pic;

                    String pic = docs[index]['pic'];
                    // print(pic);
                    // pic = 'http://jd.itying.com/' + pic;
                    pic = Config.domain + pic.replaceAll('\\', '/');
                    return new Image.network(
                      "$pic",
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: docs.length,
                  pagination: new SwiperPagination(),
                  autoplay: false),
            ),
          );
        });
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdapter.height(32),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: ScreenAdapter.width(10),
      ))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  //熱門商品
  Widget _hotProductListWidget() {
    return StreamBuilder(
        stream: Firestore.instance.collection('/hotproducts')?.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container(
              child: Loading(),
            );
          }
          List<DocumentSnapshot> docs = snap.data.documents;
          return Container(
            height: ScreenAdapter.height(234),
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (contxt, index) {
                //處理圖片
                // String sPic = this._hotProductList[index].sPic;
                String sPic = docs[index]['s_pic'];
                sPic = Config.domain + sPic.replaceAll('\\', '/');

                return Column(
                  children: <Widget>[
                    Container(
                      height: ScreenAdapter.height(140),
                      width: ScreenAdapter.width(140),
                      margin: EdgeInsets.only(right: ScreenAdapter.width(21)),
                      child: Image.network(sPic, fit: BoxFit.cover),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
                      height: ScreenAdapter.height(44),
                      child: Text(
                        // "\$${this._hotProductList[index].price}",
                        "\$${docs[index]['price']}",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                );
              },
              // itemCount: this._hotProductList.length,
              itemCount: docs.length,
            ),
          );
        });
  }

  //推薦商品
  Widget _recProductListWidget() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    return StreamBuilder(
        stream: Firestore.instance.collection('/bestproducts')?.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container(
              child: Loading(),
            );
          }
          List<DocumentSnapshot> docs = snap.data.documents;
          return Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              // children: this._bestProductList.map((value) {
              children: docs.map((value) {
                //圖片
                // String sPic = value.sPic;
                String sPic = value['s_pic'];
                sPic = Config.domain + sPic.replaceAll('\\', '/');

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/productContent',
                        // arguments: {"id": value.sId});
                        arguments: {"id": value['_id']});
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: itemWidth,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(233, 233, 233, 0.9),
                            width: 1)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: AspectRatio(
                            //防止服務器返回的圖片大小不一致導致高度不一致問題
                            aspectRatio: 1 / 1,
                            child: Image.network(
                              "${sPic}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: ScreenAdapter.height(20)),
                          child: Text(
                            "${value['title']}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: ScreenAdapter.height(20)),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\$${value['price']}",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text("\$${value['oldPrice']}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

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
      body: ListView(
        children: <Widget>[
          _swiperWidget1(),
          SizedBox(height: ScreenAdapter.height(20)),
          _titleWidget("猜你喜歡"),
          SizedBox(height: ScreenAdapter.height(20)),
          _hotProductListWidget(),
          _titleWidget("熱門推薦"),
          _recProductListWidget()
        ],
      ),
    );
  }
}
// class HomePage extends StatefulWidget {
//   HomePage({Key key}) : super(key: key);

//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with AutomaticKeepAliveClientMixin {
//   List _focusData = [];
//   List _hotProductList = [];
//   List _bestProductList = [];

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _getFocusData();
//     _getHotProductData();
//     _getBestProductData();
//     // SignServices.getSign();
//   }

//   //獲取輪播圖數據
//   _getFocusData() async {
//     var api = '${Config.domain}api/focus';
//     var result = await Dio().get(api);
//     //Save to Cloud FireBase
//     print(result.data is Map);
//     print(result.data['result']);
//     // result.data['result'].forEach((element) {
//     //   Firestore.instance.collection('/focus').document().setData(element);
//     // });
//     //-----------------------------------------------
//     var focusList = FocusModel.fromJson(result.data);
//     setState(() {
//       this._focusData = focusList.result;
//     });
//   }

//   //獲取猜你喜歡的數據
//   _getHotProductData() async {
//     var api = '${Config.domain}api/plist?is_hot=1';
//     var result = await Dio().get(api);
//     var hotProductList = ProductModel.fromJson(result.data);
//     setState(() {
//       this._hotProductList = hotProductList.result;
//     });
//   }

//   //獲取熱門推薦的數據
//   _getBestProductData() async {
//     var api = '${Config.domain}api/plist?is_best=1';
//     var result = await Dio().get(api);
//     var bestProductList = ProductModel.fromJson(result.data);
//     setState(() {
//       this._bestProductList = bestProductList.result;
//     });
//   }

// Widget _swiperWidget1() {
//   return StreamBuilder(
//       stream: Firestore.instance.collection('/focus')?.snapshots(),
//       builder: (context, snap) {
//         if (!snap.hasData) {
//           return Container();
//         }
//         List<DocumentSnapshot> docs = snap.data.documents;
//         // print(docs is Map);
//         return Container(
//           child: AspectRatio(
//             aspectRatio: 2 / 1,
//             child: Swiper(
//                 itemBuilder: (BuildContext context, int index) {
//                   // String pic = docs[index].pic;
//                   String pic = docs[index]['pic'];
//                   print(pic);
//                   pic = 'http://jd.itying.com/' + pic;
//                   return new Image.network(
//                     "$pic",
//                     fit: BoxFit.fill,
//                   );
//                 },
//                 itemCount: docs.length,
//                 pagination: new SwiperPagination(),
//                 autoplay: true),
//           ),
//         );
//       });
// }

//   Widget _titleWidget(value) {
//     return Container(
//       height: ScreenAdapter.height(32),
//       margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
//       padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
//       decoration: BoxDecoration(
//           border: Border(
//               left: BorderSide(
//         color: Colors.red,
//         width: ScreenAdapter.width(10),
//       ))),
//       child: Text(
//         value,
//         style: TextStyle(color: Colors.black54),
//       ),
//     );
//   }

//   //熱門商品
//   Widget _hotProductListWidget() {
//     if (this._hotProductList.length > 0) {
//       return Container(
//         height: ScreenAdapter.height(234),
//         padding: EdgeInsets.all(ScreenAdapter.width(20)),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemBuilder: (contxt, index) {
//             //處理圖片
//             String sPic = this._hotProductList[index].sPic;
//             sPic = Config.domain + sPic.replaceAll('\\', '/');

//             return Column(
//               children: <Widget>[
//                 Container(
//                   height: ScreenAdapter.height(140),
//                   width: ScreenAdapter.width(140),
//                   margin: EdgeInsets.only(right: ScreenAdapter.width(21)),
//                   child: Image.network(sPic, fit: BoxFit.cover),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
//                   height: ScreenAdapter.height(44),
//                   child: Text(
//                     "\$${this._hotProductList[index].price}",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 )
//               ],
//             );
//           },
//           itemCount: this._hotProductList.length,
//         ),
//       );
//     } else {
//       return Text("");
//     }
//   }

//   //推薦商品
//   Widget _recProductListWidget() {
//     var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Wrap(
//         runSpacing: 10,
//         spacing: 10,
//         children: this._bestProductList.map((value) {
//           //圖片
//           String sPic = value.sPic;
//           sPic = Config.domain + sPic.replaceAll('\\', '/');

//           return InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, '/productContent',
//                   arguments: {"id": value.sId});
//             },
//             child: Container(
//               padding: EdgeInsets.all(10),
//               width: itemWidth,
//               decoration: BoxDecoration(
//                   border: Border.all(
//                       color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     width: double.infinity,
//                     child: AspectRatio(
//                       //防止服務器返回的圖片大小不一致導致高度不一致問題
//                       aspectRatio: 1 / 1,
//                       child: Image.network(
//                         "${sPic}",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
//                     child: Text(
//                       "${value.title}",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
//                     child: Stack(
//                       children: <Widget>[
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "\$${value.price}",
//                             style: TextStyle(color: Colors.red, fontSize: 16),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Text("\$${value.oldPrice}",
//                               style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: 14,
//                                   decoration: TextDecoration.lineThrough)),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenAdapter.init(context);

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.center_focus_weak, size: 28, color: Colors.black87),
//           onPressed: null,
//         ),
//         title: InkWell(
//           child: Container(
//             height: ScreenAdapter.height(68),
//             decoration: BoxDecoration(
//                 color: Color.fromRGBO(233, 233, 233, 0.8),
//                 borderRadius: BorderRadius.circular(30)),
//             padding: EdgeInsets.only(left: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Icon(Icons.search),
//                 Text("筆記本", style: TextStyle(fontSize: ScreenAdapter.size(28)))
//               ],
//             ),
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/search');
//           },
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.message, size: 28, color: Colors.black87),
//             onPressed: null,
//           )
//         ],
//       ),
//       body: ListView(
//         children: <Widget>[
//           _swiperWidget(),
//           SizedBox(height: ScreenAdapter.height(20)),
//           _titleWidget("猜你喜歡"),
//           SizedBox(height: ScreenAdapter.height(20)),
//           _hotProductListWidget(),
//           _titleWidget("熱門推薦"),
//           _recProductListWidget()
//         ],
//       ),
//     );
//   }
// }
