import 'dart:convert';
import 'Storage.dart';
import '../config/Config.dart';

class CartServices {
  static addCart(item) async {
    //把對象轉換成Map類型的數據
    item = CartServices.formatCartData(item);

    /*
      1、獲取本地存儲的cartList數據
      2、判斷cartList是否有數據
            有數據：
                1、判斷購物車有没有當前數據：
                        有當前數據：
                            1、讓購物車中的當前數據數量 等於以前的數量+現在的數量
                            2、重新寫入本地存儲

                        没有當前數據：
                            1、把購物車cartList的數據和當前數據拼接，拼接後重新寫入本地存儲。

            没有數據：
                1、把當前商品數據以及属性數據放在數组中然後寫入本地存儲



                List list=[
                  {"_id": "1", 
                    "title": "磨砂牛皮男休闲鞋-有属性", 
                    "price": 688, 
                    "selectedAttr": "牛皮 ,系带,黄色", 
                    "count": 4, 
                    "pic":"public\upload\RinsvExKu7Ed-ocs_7W1DxYO.png",
                    "checked": true
                  },  
                    {"_id": "2", 
                    "title": "磨xxxxxxxxxxxxx", 
                    "price": 688, 
                    "selectedAttr": "牛皮 ,系带,黄色", 
                    "count": 2, 
                    "pic":"public\upload\RinsvExKu7Ed-ocs_7W1DxYO.png",
                    "checked": true
                  }              
                  
                ];

    
      */

    try {
      List cartListData = json.decode(await Storage.getString('cartList'));

      //判斷購物車有没有當前數據
      bool hasData = cartListData.any((value) {
        return value['_id'] == item['_id'] &&
            value['selectedAttr'] == item['selectedAttr'];
      });

      if (hasData) {
        for (var i = 0; i < cartListData.length; i++) {
          if (cartListData[i]['_id'] == item['_id'] &&
              cartListData[i]['selectedAttr'] == item['selectedAttr']) {
            cartListData[i]["count"] = cartListData[i]["count"] + 1;
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      } else {
        cartListData.add(item);
        await Storage.setString('cartList', json.encode(cartListData));
      }
    } catch (e) {
      List tempList = [];
      tempList.add(item);
      await Storage.setString('cartList', json.encode(tempList));
    }
  }

  //過濾數據
  static formatCartData(item) {
    //處理圖片
    String pic = item.pic;
    pic = Config.domain + pic.replaceAll('\\', '/');

    final Map data = new Map<String, dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;
    //處理 string 和int類型的價格
    if (item.price is int || item.price is double) {
      data['price'] = item.price;
    } else {
      data['price'] = double.parse(item.price);
    }
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = pic;
    //是否選中
    data['checked'] = true;
    return data;
  }

  //獲取購物車選中的數據
  static getCheckOutData() async {
    List cartListData = [];
    List tempCheckOutData = [];
    try {
      cartListData = json.decode(await Storage.getString('cartList'));
    } catch (e) {
      cartListData = [];
    }
    for (var i = 0; i < cartListData.length; i++) {
      if (cartListData[i]["checked"] == true) {
        tempCheckOutData.add(cartListData[i]);
      }
    }

    return tempCheckOutData;
  }
}
