import 'package:event_bus/event_bus.dart';

//Bus 初始化

EventBus eventBus = EventBus();

//商品詳情廣播數據
class ProductContentEvent {
  String str;
  ProductContentEvent(String str) {
    this.str = str;
  }
}

//用户中心廣播
class UserEvent {
  String str;
  UserEvent(String str) {
    this.str = str;
  }
}

//收貨地址廣播
class AddressEvent {
  String str;
  AddressEvent(String str) {
    this.str = str;
  }
}

//結算頁面
class CheckOutEvent {
  String str;
  CheckOutEvent(String str) {
    this.str = str;
  }
}
