import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  File? _imgPath;

  bool _isFlashOn = false;
  final IconData _flashOnIcon = Icons.flash_on;
  final IconData _flashOffIcon = Icons.flash_off;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _controller.value.isInitialized
                  ? Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: CameraPreview(_controller)))
                  : const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Positioned(
          bottom: 40,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: 80,
              width: 80,
              child: FloatingActionButton(
                backgroundColor: Colors.grey.withOpacity(0.5),
                shape: const CircleBorder(),
                onPressed: () {
                  log("take picture");
                  _takePicture(context);
                },
                child: Container(),
              ),
            ),
            GestureDetector(
              onTap: () {
                log("take picture");
                _takePicture(context);
              },
              child: Icon(
                Icons.circle,
                color: Colors.white.withOpacity(0.7),
                size: 75,
              ),
            ),
          ]),
        ),
        Positioned(
          bottom: 50,
          right: 40,
          child: GestureDetector(
            onTap: () {
              log("open gallery");
              _openGallery(context);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 30,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 40,
          child: GestureDetector(
            onTap: () {
              _toggleFlash();
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isFlashOn ? _flashOnIcon : _flashOffIcon,
                size: 30,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    //拍照
    try {
      await _initializeControllerFuture;
      var image = await _controller.takePicture();
      if (!mounted) return;

      setState(() {
        _imgPath = File(image.path);
      });
      await _cropImage(_imgPath!);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    //打开相册
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imgPath = File(pickedImage.path);
      });
      await _cropImage(_imgPath!);
    }
  }

  void _toggleFlash() {
    //闪光灯开关
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _isFlashOn
        ? _controller.setFlashMode(FlashMode.torch)
        : _controller.setFlashMode(FlashMode.off);
  }

  Future<void> _cropImage(File imageFile) async {
    //裁剪图片
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 100,
      maxWidth: 700,
      maxHeight: 700,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '裁剪图片',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
          aspectRatioLockEnabled: false,
          aspectRatioPickerButtonHidden: true,
          resetAspectRatioEnabled: false,
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    if (croppedFile != null) {
      log('croppedFile: ${croppedFile.path}');
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DisplayPictureScreen(imagePath: croppedFile.path),
          ),
        );
      }
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  //图片处理窗口
  final String imagePath;
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
