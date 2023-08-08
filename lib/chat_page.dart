import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60, // 替换为您的头像图片
            ),
            SizedBox(height: 20),
            Text(
              '用户名：John Doe', // 替换为您的用户名
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '电子邮件：johndoe@example.com', // 替换为您的电子邮件
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '简介：这里是您的个人简介，您可以在这里写一些关于自己的描述。', // 替换为您的个人简介
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
