import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  final frompage;
  const Browser(this.frompage);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  String privacy_url = "https://privacypolicy.anyquire.com/";
  String termsofservice = "https://termsofservice.anyquire.com/";
  String url = "";
  var controller;

  @override
  void initState() {
    urlinit();
    // TODO: implement initState
    super.initState();
  }

  urlinit() {
    if (widget.frompage == "PRIVACY") {
      setState(() {
        url = privacy_url;
      });
    } else {
      setState(() {
        url = termsofservice;
      });
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('$url'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.frompage == "PRIVACY")
            ? Text("Privacy Policy")
            : Text("Terms of Service"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
