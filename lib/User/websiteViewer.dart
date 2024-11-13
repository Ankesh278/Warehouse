import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  const WebViewScreen({Key? key,required this.title,required this.url}) : super(key: key);
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}
class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        ),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WebViewWidget(
              layoutDirection: TextDirection.ltr,
              controller: controller,
            ),
          ),
          // if (_isLoading)
          //   Center(
          //     child:  SpinKitFadingCircle(
          //       color: Colors.redAccent,
          //       size: 50.0,
          //     ),
          //   ),
        ],
      ),
    );
  }
}