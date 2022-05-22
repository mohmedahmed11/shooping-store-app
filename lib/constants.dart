import 'package:flutter/material.dart';

const primaryColor = Color(0xFFe21d40);
const secoundColor = Color(0xFF147820);

const String baseUrl = 'http://192.168.2.1:8000'; //'172.20.10.3:8000'; //
const String baseUrlApi = '/api';
const String baseUrlImage =
    'http://192.168.2.1:8000/storage/'; //'http://172.20.10.3:8000/storage/'; //

String deviceTokenToSendPushNotification = "";

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => _FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.2)),
        child: const Center(child: CircularProgressIndicator()));
  }
}

const List<Color> kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];
