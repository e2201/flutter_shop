import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../services/CartServices.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../provider/CheckOut.dart';
import '../Cart/CartItem.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("CartPage"),
//     );
//   }
// }
class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit = false;

  var checkOutProvider;
  @override
  void initState() {
    super.initState();
    print("cart");
  }

  //去結算

  doCheckOut() async {
    //1、獲取購物車選中的數據
    List checkOutData = await CartServices.getCheckOutData();
    //2、保存購物車選中的數據
    this.checkOutProvider.changeCheckOutListData(checkOutData);
    //3、購物車有没有選中的數據
    if (checkOutData.length > 0) {
      //4、判斷用户有没有登錄
      var loginState = await UserServices.getUserLoginState();
      if (loginState) {
        Navigator.pushNamed(context, '/checkOut');
      } else {
        Fluttertoast.showToast(
          msg: '您還没有登錄，請登錄以後再去結算',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, '/login');
      }
    } else {
      Fluttertoast.showToast(
        msg: '購物車没有選中的數據',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    var cartProvider = Provider.of<Cart>(context);

    checkOutProvider = Provider.of<CheckOut>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("購物車"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: () {
              setState(() {
                this._isEdit = !this._isEdit;
              });
            },
          )
        ],
      ),
      body: cartProvider.cartList.length > 0
          ? Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Column(
                        children: cartProvider.cartList.map((value) {
                      return CartItem(value);
                    }).toList()),
                    SizedBox(height: ScreenAdapter.height(100))
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(78),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black12)),
                      color: Colors.white,
                    ),
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(78),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenAdapter.width(60),
                                child: Checkbox(
                                  value: cartProvider.isCheckedAll,
                                  activeColor: Colors.pink,
                                  onChanged: (val) {
                                    //實現全選或者反選
                                    cartProvider.checkAll(val);
                                  },
                                ),
                              ),
                              Text("全選"),
                              SizedBox(width: 20),
                              this._isEdit == false ? Text("合計:") : Text(""),
                              this._isEdit == false
                                  ? Text("\$${cartProvider.allPrice}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red))
                                  : Text(""),
                            ],
                          ),
                        ),
                        this._isEdit == false
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RaisedButton(
                                  child: Text("結算",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: doCheckOut,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: RaisedButton(
                                  child: Text("删除",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () {
                                    cartProvider.removeItem();
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text("購物車空空的..."),
            ),
    );
  }
}
