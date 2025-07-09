import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keluhan pelanggan',

      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  get http => null;
  late final WebViewController controller;
  get builder => null;

  get flutterWebViewPlugin => null;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition (required for Android 10+)
    WebView.platform = SurfaceAndroidWebView();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var loadingPercentage = 0;
  @override
  Completer<WebViewController> _controller = Completer<WebViewController>();



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/LOGO BAMBI SINCE.png',height:30),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.circle_notifications),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewsNotificationPage()));
            },),
        ],
      ),
      body: WebView(
        initialUrl: 'https://27.123.222.151:886/keluhan_pelanggan',
        //initialUrl: 'https://27.123.222.151:886/keluhan_pelanggan/public/custfile',
        // Replace this URL with your desired website
        javascriptMode: JavascriptMode.unrestricted,

        onWebViewCreated: (WebViewController webViewController) async{

          // You can use the webViewController to control the WebView programmatically
          await controller.evaluateJavascript('''
            // Add your JavaScript code here to modify the select element
            // For example, you can change the font color of select options
            document.getElementById("type").style.color = "red";
          ''');


          //_controller!.runJavascript(script);


        },

        onPageStarted: (String url) {
          setState(() {
            loadingPercentage = 0;
          });
          // Do something when the page starts loading
        },

        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (String url) async {

          // untuk mendapatkan upload image
          // Jalankan skrip JavaScript di WebView untuk mengubah font
          String customCss = '''
             var style = document.createElement('style');
            style.innerHTML = 'select { font-size: 5px; }'; // Ubah ukuran font sesuai kebutuhan
            document.head.appendChild(style);
            ''';
          controller.evaluateJavascript(customCss);
          //end mendapatkan image
          RegExp regex = RegExp(r"/whatsapp/(\w+)");
          Match? match = regex.firstMatch(url);
          if (match != null && match.groupCount > 0) {
            Uri uri = Uri.parse(url);
            // final response = await http.get(Uri.parse(url));
            //var respnse = json.decode(response.body);
            //String path = uri.path;
            var data =uri.queryParameters;
            String jsonString = jsonEncode(data);

            String rep = jsonString.replaceAll('"','');
            String rep1 = rep.replaceAll(':}','}');
            String datas = rep1.replaceAll("'",'"');

            _openWhatsApp(datas);

          }
          // Do something when the page finishes loading
        },

        navigationDelegate: (NavigationRequest request) {
          // You can use this callback to control navigation, e.g., prevent certain URLs from loading
          return NavigationDecision.navigate;
        },

      ),


    );
  }

  /// Function for file selection from gallery
  // Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
  //   final result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null && result.files.single.path != null) {
  //     final file = File(result.files.single.path!);
  //     return [file.uri.toString()];
  //   }
  //   return [];
  // }
// Function to open WhatsApp with a specific phone number
  _openWhatsApp(String datas) async {
    Map<String, dynamic> item = json.decode(datas);
    String nohp = item['nohp'];
    String nama   = item['nama'];
    String email  = item['email'];
    //String rep_no = nohp.trim();
    String phoneNumber ="";
    if(nohp =="081280377888"){
      phoneNumber ="+6281280377888";
    }
    String message ="Mohon didaftarkan:\n"
        "${nama}\n${email}";
    String url = 'https://wa.me/$phoneNumber?text=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Jika gagal membuka WhatsApp, tampilkan pesan kesalahan
      print('Gagal membuka WhatsApp');
    }

  }

  void evaluateJavascript(String s) {


  }
}



_getbuttonupload(){

}















_dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Basic dialog title'),
        content: const Text(
            'Periksa Konesi Anda'
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


//fungsi untuk mendapatkan lokasi
