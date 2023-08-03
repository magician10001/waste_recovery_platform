import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'camera_preview.dart';
import 'map.dart';
import 'CreateRoutes.dart';
import 'chatPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _selectedIndex = 0;

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
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const MyHomePage(title: 'Flutter Demo Home Page'),
            ChatScreen(),
             MapPage(),
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('主页'),
              selectedColor: Colors.redAccent,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.textsms),
              title: const Text('消息'),
              selectedColor: Colors.deepOrange,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('我的'),
              selectedColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const Icon(Icons.menu),
      title: const Text('Flutter Demo Home Page'),
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
      expandedBody: const CameraPreview(),
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
          Icons.camera,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
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
                    child: Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, createRoute_bottom());
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
                          Navigator.push(context, createRoute_bottom());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
