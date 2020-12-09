import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webviews/screens/projects_container.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final _url;

  WebViewContainer(this._url);

  @override
  createState() => _WebViewContainerState(this._url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url + 'login.jsp',
              onPageFinished: (url) => _onPageFinished(context),
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              userAgent: 'AtlassianMobileApp',
            ))
          ],
        ));
  }

  void _onPageFinished(BuildContext context) {
    _controller.future.then(
        (controller) => _finishIfAuthenticated(context, controller, _url));
  }

  void _launchProjects(String baseUrl, String cookie) {
    final authenticated = cookie.contains('authenticated=true');
    if (authenticated) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectsContainer(baseUrl, cookie)));
    }
  }

  void _finishIfAuthenticated(BuildContext context,
      WebViewController controller, String baseUrl) async {
    final CookieManager cookieManager = CookieManager();
    cookieManager.getCookie(baseUrl).then((cookie) => _launchProjects(baseUrl, cookie));
//    final cookie = await controller.evaluateJavascript('document.cookie');
//    final authenticated = cookie.contains('authenticated=true');
//    if (authenticated) {
//      String c;
//      if (cookie.startsWith("\"")) {
//        c = cookie.substring(1);
//      }
//      if (c.endsWith("\"")) {
//        c = c.substring(0, c.length - 1);
//      }
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => ProjectsContainer(baseUrl, c)));
//    }
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Column(
//          mainAxisAlignment: MainAxisAlignment.end,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            const Text('Cookies:'),
//            _getCookieList(cookie),
//          ],
//        ),
//      ));
  }

//  Widget _getCookieList(String cookies) {
//    if (cookies == null || cookies == '""') {
//      return Container();
//    }
//    final List<String> cookieList = cookies.split(';');
//    final Iterable<Text> cookieWidgets =
//    cookieList.map((String cookie) => Text(cookie));
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      mainAxisSize: MainAxisSize.min,
//      children: cookieWidgets.toList(),
//    );
//  }
}
