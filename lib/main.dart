import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

///外部组件
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

///内部文件
import 'chat_page.dart';
import 'home_page.dart';

Future<void> main() async {
/// Ensure that plugin services are initialized so that `availableCameras()` can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
        create: (_) => CameraProvider(),
        child: const MyApp()),
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
            const ProfilePage(),
            HomePage(title: "Demo", cameras: _cameras),
            const ProfilePage(),
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

