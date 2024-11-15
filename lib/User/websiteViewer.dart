import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  const WebViewScreen({super.key, required this.title, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true; // Page is loading
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false; // Page loaded
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
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
          if (_isLoading)
            const Center(
              child: SpinKitCircle(
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
