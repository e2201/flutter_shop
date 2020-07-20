import 'dart:convert';

import 'Storage.dart';

class SearchServices {
  static setHistoryData(keywords) async {
    /*
          1、獲取本地存儲裡面的數據  (searchList)

          2、判断本地存儲是否有數據

              2.1、如果有數據 

                    1、讀取本地存儲的數據
                    2、判断本地存儲中有没有當前數據，
                        如果有不做操作、
                        如果没有當前數據,本地存儲的數據和當前數據拼接後重新寫入           


              2.2、如果没有數據

                    直接把當前數據放在數组中寫入到本地存儲
      
      
      */

    try {
      List searchListData = json.decode(await Storage.getString('searchList'));

      print(searchListData);
      var hasData = searchListData.any((v) {
        return v == keywords;
      });
      if (!hasData) {
        searchListData.add(keywords);
        await Storage.setString('searchList', json.encode(searchListData));
      }
    } catch (e) {
      List tempList = new List();
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  static getHistoryList() async {
    try {
      List searchListData = json.decode(await Storage.getString('searchList'));
      return searchListData;
    } catch (e) {
      return [];
    }
  }

  static clearHistoryList() async {
    await Storage.remove('searchList');
  }

  static removeHistoryData(keywords) async {
    List searchListData = json.decode(await Storage.getString('searchList'));
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }
}
