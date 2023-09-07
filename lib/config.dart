import 'package:amap_flutter_base/amap_flutter_base.dart';

class ConstConfig {
  ///配置您申请的apikey，在此处配置之后，可以在初始化[AMapWidget]时，通过`apiKey`属性设置
  ///
  ///注意：使用[AMapWidget]的`apiKey`属性设置的key的优先级高于通过Native配置key的优先级，
  ///使用[AMapWidget]的`apiKey`属性配置后Native配置的key将失效，请根据实际情况选择使用

  /// 安卓key
  static const androidKey = '0888b5e8d3804534b3c4e5741bfbb029';

  /// 苹果key
  static const iosKey = 'd2555847188002d350dffb528777bfc3';

  /// web服务
  static const webKey = '1fdc832712135264c88bac2a9619e9e0';

  /// 构造AMapKeyConfig
  static const AMapApiKey amapApiKeys =
  AMapApiKey(iosKey: iosKey, androidKey: androidKey);

  /// 注意：[AMapPrivacyStatement]的'hasContains''hasShow''hasAgree'这三个参数中有一个为false，高德SDK均不会工作，会造成地图白屏等现象

  static const AMapPrivacyStatement amapPrivacyStatement =
  AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}
const String androidKey = "0888b5e8d3804534b3c4e5741bfbb029";
const String iosKey = "d2555847188002d350dffb528777bfc3";
const String webKey = "1fdc832712135264c88bac2a9619e9e0";

List<Map<String, dynamic>> customPoisData = [
  {"address":"红凌路西150米","distance":"0","pname":"辽宁省","cityname":"大连市","photos":[],"typecode":"050100","adname":"甘井子区","name":"废铁","weight":"1.5kg","location":"121.522332,38.882768","tel":"0411-84708375","id":"00001", "price":"9", "username":"atlas"},
  {"address":"大连理工大学29舍","distance":"0","pname":"辽宁省","cityname":"大连市","photos":[],"typecode":"050100","adname":"甘井子区","name":"塑料瓶","weight":"2kg","location":"121.523000,38.882750","tel":"0411-84708375","id":"00002", "price":"2.5", "username":"plato"},
  // 添加更多自定义数据项
];