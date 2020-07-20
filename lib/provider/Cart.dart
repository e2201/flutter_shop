import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';

class Cart with ChangeNotifier {
  List _cartList = []; //購物車數據
  bool _isCheckedAll = false; //全選
  double _allPrice = 0; //總價

  List get cartList => this._cartList;
  bool get isCheckedAll => this._isCheckedAll;
  double get allPrice => this._allPrice;

  Cart() {
    this.init();
  }
  //初始化的時候獲取購物車數據
  init() async {
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      this._cartList = cartListData;
    } catch (e) {
      this._cartList = [];
    }
    //獲取全選的狀態
    this._isCheckedAll = this.isCheckAll();
    //計算總價
    this.computeAllPrice();

    notifyListeners();
  }

  updateCartList() {
    this.init();
  }

  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
    //計算總價
    this.computeAllPrice();

    notifyListeners();
  }

  //全選 反選
  checkAll(value) {
    for (var i = 0; i < this._cartList.length; i++) {
      this._cartList[i]["checked"] = value;
    }
    this._isCheckedAll = value;
    //計算總價
    this.computeAllPrice();

    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  //判断是否全選
  bool isCheckAll() {
    if (this._cartList.length > 0) {
      for (var i = 0; i < this._cartList.length; i++) {
        if (this._cartList[i]["checked"] == false) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  //監聽每一項的選中事件
  itemChage() {
    if (this.isCheckAll() == true) {
      this._isCheckedAll = true;
    } else {
      this._isCheckedAll = false;
    }
    //計算總價
    this.computeAllPrice();

    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  //計算總價
  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    notifyListeners();
  }

  //删除數據
  removeItem() {
    //  1        2
    // ['1111','2222','333333333','4444444444']
    // 錯誤的寫法
    // for (var i = 0; i < this._cartList.length; i++) {
    //   if (this._cartList[i]["checked"] == true) {
    //      this._cartList.removeAt(i);
    //   }
    // }

    List tempList = [];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList = tempList;
    //計算總價
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }
}
