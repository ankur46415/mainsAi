import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../payment_result_screen/result_screen.dart';

class PaytmPaymentPage extends StatefulWidget {
  final String paytmUrl;
  final Map<String, String> paytmParams;

  const PaytmPaymentPage({
    super.key,
    required this.paytmUrl,
    required this.paytmParams,
  });

  @override
  State<PaytmPaymentPage> createState() => _PaytmPaymentPageState();
}

class _PaytmPaymentPageState extends State<PaytmPaymentPage> {
  late final WebViewController _controller;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    print("paytmUrl: ${widget.paytmUrl}");

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) => debugPrint("Started: $url"),
              onPageFinished: _handlePageFinished,
              onWebResourceError:
                  (error) => debugPrint("WebView error: ${error.description}"),
            ),
          );

    _loadPostRequest();
  }

  void _loadPostRequest() {
    final postData = utf8.encode(_encodeFormData(widget.paytmParams));
    _controller.loadRequest(
      Uri.parse(widget.paytmUrl),
      method: LoadRequestMethod.post,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: Uint8List.fromList(postData),
    );
  }

  String _encodeFormData(Map<String, String> data) {
    return data.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> _handlePageFinished(String url) async {
    debugPrint("Finished: $url");

    if (_isNavigated) return;

    try {
      final result = await _controller.runJavaScriptReturningResult(
        "document.body.innerText",
      );

      String bodyText = result.toString();

      // Clean quotes
      if (bodyText.startsWith('"') && bodyText.endsWith('"')) {
        bodyText = bodyText.substring(1, bodyText.length - 1);
      }

      // Unescape characters
      bodyText = bodyText.replaceAll(r'\"', '"');
      debugPrint("Parsed body: $bodyText");

      // Parse JSON
      final decoded = jsonDecode(bodyText);

      // Get status from actual response key
      final status = decoded['status']?.toString().toUpperCase() ?? '';

      if (status == 'SUCCESS') {
        _navigateToResultScreen(success: true, data: decoded);
      } else {
        _navigateToResultScreen(success: false, data: decoded);
      }
    } catch (e) {
      debugPrint("Error parsing payment response: $e");
    }
  }

  void _navigateToResultScreen({
    required bool success,
    required Map<String, dynamic> data,
  }) {
    _isNavigated = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentResultScreen(isSuccess: success, paymentData: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: WebViewWidget(controller: _controller)),
    );
  }
}
