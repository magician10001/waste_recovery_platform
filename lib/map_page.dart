import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'config.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  ///地图通信中心
  AMapController? mapController;

  /// 定位插件
  AMapFlutterLocation? location;

  /// 权限状态
  PermissionStatus? permissionStatus;

  /// 相机位置
  CameraPosition? currentLocation;

  /// 地图类型
  late MapType _mapType;

  /// 周边数据
  List poisData = [];

  var markerLatitude;
  var markerLongitude;

  double? meLatitude;
  double? meLongitude;

  @override
  void initState() {
    super.initState();
    _mapType = MapType.normal;

    /// 设置Android和iOS的apikey，
    AMapFlutterLocation.setApiKey(ConstConfig.androidKey, ConstConfig.iosKey);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyShow(true, true);
    requestPermission();
  }

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        //print("拒绝");
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        //print("限制");
        break;
      default:
        //print("其他状态");
        requestLocation();
        break;
    }
  }

  /// 请求位置
  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        double? latitude = double.tryParse(event['latitude'].toString());
        double? longitude = double.tryParse(event['longitude'].toString());
        markerLatitude = latitude.toString();
        markerLongitude = longitude.toString();
        meLatitude = latitude;
        meLongitude = longitude;
        if (latitude != null && longitude != null) {
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            );
          });
        }
      })
      ..startLocation();
  }

  void _onMapPoiTouched(AMapPoi poi) async {
    // if (null == poi) {
    //   return;
    // }
    print('_onMapPoiTouched===> ${poi.toJson()}');
    var xx = poi.toJson();
    print(xx['latLng']);
    markerLatitude = xx['latLng'][1];
    markerLongitude = xx['latLng'][0];
    setState(() {
      _addMarker(poi.latLng!);
    });
    _getPoisData();
  }

  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};
  //添加一个marker
  void _addMarker(LatLng markPostion) async {
    //_removeAll();
    final Marker marker = Marker(
      position: markPostion,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
    _changeCameraPosition(markPostion);
  }

  void _addMarker_noCameraChange(LatLng markPostion) async {
    //_removeAll();
    final Marker marker = Marker(
      position: markPostion,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
  }

  // /// 清除marker
  // void _removeAll() {
  //   if (_markers.isNotEmpty) {
  //     setState(() {
  //       _markers.clear();
  //     });
  //   }
  // }

  /// 改变中心点
  void _changeCameraPosition(LatLng markPostion, {double zoom = 18}) {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            //中心点
            target: markPostion,
            //缩放级别
            zoom: zoom,
            //俯仰角0°~45°（垂直与地图时为0）
            tilt: 30,
            //偏航角 0~360° (正北方为0)
            bearing: 0),
      ),
      animated: true,
    );
  }

  @override
  void dispose() {
    location?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "搜寻回收点",
          style: TextStyle(),
        ),
      ),
      body: currentLocation == null
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  child: SizedBox(
                    child: AMapWidget(
                      // 隐私政策包含高德 必须填写
                      privacyStatement: ConstConfig.amapPrivacyStatement,
                      apiKey: ConstConfig.amapApiKeys,
                      // 初始化地图中心店
                      initialCameraPosition: currentLocation!,
                      //定位小蓝点
                      myLocationStyleOptions: MyLocationStyleOptions(
                        true,
                      ),
                      // 普通地图normal,卫星地图satellite,夜间视图night,导航视图 navi,公交视图bus,
                      mapType: _mapType,
                      // 缩放级别范围
                      minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
                      onPoiTouched: _onMapPoiTouched,
                      markers: Set<Marker>.of(_markers.values),
                      // 地图创建成功时返回AMapController
                      onMapCreated: (AMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          '周边信息',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _buildPoisList(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ElevatedButton(
                          onPressed: _getPoisData_init,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xfc77be87),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 8),
                              Text(
                                '获取周边数据',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        // marginRight: 25, //右边距
        // marginBottom: 50, //下边距
        animatedIcon: AnimatedIcons.menu_close, //带动画的按钮
        animatedIconTheme: const IconThemeData(size: 22.0),
        // visible: isShow, //是否显示按钮
        closeManually: false, //是否在点击子按钮后关闭展开项
        curve: Curves.bounceIn, //展开动画曲线
        overlayColor: Colors.black, //遮罩层颜色
        overlayOpacity: 0.5, //遮罩层透明度
        onOpen: () => print('OPENING DIAL'), //展开回调
        onClose: () => print('DIAL CLOSED'), //关闭回调
        tooltip: 'Speed Dial', //长按提示文字
        heroTag: 'speed-dial-hero-tag', //hero标记
        backgroundColor: const Color(0xfc77be87), //按钮背景色
        foregroundColor: Colors.white, //按钮前景色/文字色
        elevation: 8.0, //阴影
        shape: const CircleBorder(), //shape修饰
        children: [
          //子按钮
          SpeedDialChild(
              label: '普通地图',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                // onButtonClick(1);
                setState(() {
                  _mapType = MapType.normal;
                });
              }),
          SpeedDialChild(
            label: '卫星地图',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.satellite;
              });
            },
          ),
          SpeedDialChild(
            label: '导航地图',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.navi;
              });
            },
          ),
          SpeedDialChild(
            label: '公交地图',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.bus;
              });
            },
          ),
          SpeedDialChild(
            label: '黑夜模式',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.night;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPoisList() {
    return Column(
      children: poisData.map((value) {
        return ListTile(
          title: Text('${value['name']}'),
          subtitle: Text(
              '${value['pname']}${value['cityname']}${value['adname']}${value['address']}'),
          onTap: () async {
            List locationData = value['location'].split(',');
            double l1 = double.parse(locationData[1]);
            double l2 = double.parse(locationData[0]);
            markerLatitude = l2;
            markerLongitude = l1;
            _getPoisData();
            _addMarker(LatLng(l1, l2));
            _changeCameraPosition(LatLng(l1, l2));
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('物品详情', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text('类别: ${value['name']}'),
                      Text('数量: ${value['weight']}'),
                      Text('价格: ${value['price']}'),
                      Text('联系人: ${value['username']}'),
                      Text('详细地址: ${value['address']}'),
                      Text('联系方式: ${value['tel']}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // 实现联系物主的逻辑
                          // 可以在这里处理拨打电话、发送消息等操作
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xfc77be87),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('我要回收', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }).toList(),
    );
  }

  /// 获取周边数据
  Future<void> _getPoisData() async {
    //var response = await Dio().get('https://restapi.amap.com/v3/place/around?key=${ConstConfig.webKey}&location=$markerLatitude,$markerLongitude&keywords=&types=&radius=1000&offset=20&page=1&extensions=base');
    setState(() {
      //poisData = response.data['pois'];
      poisData = customPoisData;
    });
  }

  ///第一次初始化时将全部pois在地图上标出
  Future<void> _getPoisData_init() async {
    setState(() {
      poisData = customPoisData;
    });
    poisData.forEach((poi) {
      var xx = poi['location'].split(',');
      var markPostion = LatLng(double.parse(xx[1]), double.parse(xx[0]));
      _addMarker_noCameraChange(markPostion);
    });
  }
}
