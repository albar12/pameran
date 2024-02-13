import 'package:flutter/material.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LaporanPemasanganPage extends StatefulWidget {
  final String? session;
  const LaporanPemasanganPage({
    super.key,
    this.session,
  });

  @override
  State<LaporanPemasanganPage> createState() => _LaporanPemasanganPageState();
}

class _LaporanPemasanganPageState extends State<LaporanPemasanganPage> {
  var controller = WebViewController()
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
          if (request.url
              .startsWith('https://pameran.jtracker.id/main/pasang')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://pameran.jtracker.id/main/pasang'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (ctx) => HomePage(
                          session: widget.session,
                        )),
                (route) => true);
          },
        ),
        title: Text("Laporan Pemasangan"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) => LaporanPemasanganPage(
                              session: widget.session,
                            )),
                    (route) => false);
                // doDownloadFile();
              },
              child: Icon(
                Icons.refresh,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
