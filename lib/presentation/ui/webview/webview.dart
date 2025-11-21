import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      );
    loadUrl();
  }

  Future<void> loadUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String savedUrl = prefs.getString('website_url') ?? 'https://google.com';

    // Add scheme if missing
    if (!savedUrl.startsWith('http://') && !savedUrl.startsWith('https://')) {
      savedUrl = 'https://$savedUrl';
    }

    setState(() => isLoading = true);
    await controller.loadRequest(Uri.parse(savedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: WebViewWidget(controller: controller),
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Center(child: const Text("WebView")),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
