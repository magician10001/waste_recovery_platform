import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:developer';
import 'package:draggable_home/draggable_home.dart';
import 'camera_page.dart';
import 'create_routes.dart';

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
      expandedBody: widget.cameras !=null ? TakePictureScreen(
        camera: widget.cameras!.first,
      ) : const Center(child: CircularProgressIndicator()),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            "下拉拍照",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "识别物品并估值",
                  style: TextStyle(
                    fontSize: 30,  // 修改字体大小
                    fontWeight: FontWeight.bold,  // 加粗字体
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            "使用 AI 技术,快速获取物品信息和估值",
            style: TextStyle(color: Colors.white24),
          ),
        ],
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
