import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalLoadingScreen extends StatefulWidget {
  final VoidCallback? onLoaded;

  const GlobalLoadingScreen({Key? key, this.onLoaded}) : super(key: key);

  @override
  _GlobalLoadingScreenState createState() => _GlobalLoadingScreenState();
}

class _GlobalLoadingScreenState extends State<GlobalLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      widget.onLoaded?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: CircularProgressIndicator()

        // child: Image.asset(
          //   'assets/images/lod.gif',
          //   width: 100,
          //   height: 100,
          // ),
        ),
      ),
    );
  }
}