import 'dart:developer';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

//外部组件
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';

//高德地图
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

//内部文件
import 'camera_preview.dart';
import 'map.dart';
import 'createRoutes.dart';
import 'chatPage.dart';

Future<void> main() async {
// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
        create: (_) => CameraProvider(),
        child: MyApp()),
  );
}


class CameraProvider extends ChangeNotifier {
  List<CameraDescription>? cameras;

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    notifyListeners();
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _selectedIndex = 1;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    List<CameraDescription> cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: IndexedStack(                                                     //IndexedStack组件，用于切换页面
          index: _selectedIndex,
          children: [
            AMapPage(iosKey, androidKey),
            HomePage(title: "Demo", cameras: _cameras),
            MapPage(),
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('我的'),
              selectedColor: const Color(0x89208D6E),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('主页'),
              selectedColor: const Color(0xFF4BAA50),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.textsms),
              title: const Text('消息'),
              selectedColor: const Color(0xFF407157),
            ),

          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.cameras});

  final List<CameraDescription>? cameras;

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const Icon(Icons.menu),
      title: const Text('Demo'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => log('Search button pressed'),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => log('More button pressed'),
        ),
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
      ],
      fullyStretchable: true,
      expandedBody: TakePictureScreen(
        camera: widget.cameras!.first,
      ),
      backgroundColor: Colors.white,
      appBarColor: Colors.white,
      headerExpandedHeight: 0.35,
      stretchMaxHeight: 0.86,
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.green,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          "下拉拍照",
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  ListView listView() {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
              width: double.infinity, // 让容器宽度自适应父级宽度
              height: 100,
              margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x89208D6E),
                            Colors.green,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, createRouteBottom());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // 将文字居左显示
                              children: [
                                SizedBox(width: 15), // 添加文字与按钮左边框的距离
                                Text(
                                  '我要上门回收',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.recycling,
                      color: Colors.lightGreenAccent,
                      size: 100,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, createRouteBottom());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
