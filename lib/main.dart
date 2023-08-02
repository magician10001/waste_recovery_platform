import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'camera_preview.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      padding: const EdgeInsets.only(top: 0, left:10, right: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: Colors.white70,
        child: ListTile(
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: const Text("Title"),
          subtitle: const Text("Subtitle"),
        ),
      ),
    );
  }
}
