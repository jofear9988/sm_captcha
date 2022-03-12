import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:sm_captcha/sm_captcha.dart';
import 'dart:convert' as convert;

import 'gradient_button.dart';

void main() {
  runApp(const MyInitApp());
}

class MyInitApp extends StatelessWidget {
  const MyInitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyApp(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('滑块验证码'),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int captchaMode = 0;
  List<SmCaptchaMode> mode = [
    SmCaptchaMode.MODE_SLIDE,
    SmCaptchaMode.MODE_SELECT,
    SmCaptchaMode.MODE_ICON_SELECT,
    SmCaptchaMode.MODE_SEQ_SELECT,
    SmCaptchaMode.MODE_SPATIAL_SELECT
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 16.0,right: 16.0,top:56.0),
        child: Column(
          children: [
            Container(
              height: 285,
              width: double.infinity,
              color: const Color(0xFF1D2933),
              child: SmCaptchaView(
                onCaptchaCreated: (controller) {
                  controller.start();
                },
                onReady: () {
                  return onReady();
                },
                onSuccess: (pass, rid) async {
                  print("--------->onSuccess $pass,$rid");
                },
                onError: (code, msg) async {
                  print("--------->onError $code,$msg");
                },
                onCancel: () async {
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: _getCaptchaMode(),
            ),
            Container(
              height: 40.0,
              child: Row(
                children: [
                  GradientButton(
                    beginColor: const Color(0xffff9047),
                    endColor: const Color(0xffff5722),
                    height: 40.0,
                    width: 130.0,
                    onPress: () {
                      setState(() {
                        _show();
                      });
                    },
                    isEnabled: true,
                    text: "弹窗验证码",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ); /*Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [


            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [

                  ],
                ),
              ),
            ),

            // rgMode = mNativeView.findViewById(R.id.rg_mode);
            //         tvResult = mNativeView.findViewById(R.id.tv_result);
            //         etTips = mNativeView.findViewById(R.id.et_tip_message);
            //         captchaContainer = mNativeView.findViewById(R.id.captcha_container);
            //         rgLang = mNativeView.findViewById(R.id.rg_lang);
            //         etHost = mNativeView.findViewById(R.id.et_host);
            //         rgHttps = mNativeView.findViewById(R.id.rg_https);
            //         etCDNHost = mNativeView.findViewById(R.id.et_cdn_host);
            //         etCaptchaHtml = mNativeView.findViewById(R.id.et_captcha_html);
            //         etSmId = mNativeView.findViewById(R.id.et_device_id);
            //         loadCaptcha = mNativeView.findViewById(R.id.load_captcha);
            //         enableCaptcha = mNativeView.findViewById(R.id.enable);
            //         disableCaptcha = mNativeView.findViewById(R.id.disable);
            //
            // //        loadCaptcha.setOnClickListener(v -> loadCaptcha());
            //         enableCaptcha.setOnClickListener(v -> enable(v));
            //         disableCaptcha.setOnClickListener(v -> disable(v));
          ],
        ),
      )*/
  }

  ///获取数美图形验证码 授权
  Future<String?> onReady() async {
    final completer = Completer<String>();
    SmConfig config = SmConfig(
      organization: 'RlokQwRlVjUrTUlkIqOg',
      appId: 'default',
      captchaMode: captchaMode,
    );
    String json = convert.jsonEncode(config);
    completer.complete(json);
    return completer.future;
  }

  // （选填项）选择验证模式，支持以下模式
  //      1. SmCaptchaWebView.MODE_SLIDE          滑动式（默认）
  //      2. SmCaptchaWebView.MODE_SELECT         文字点选式
  //      3. SmCaptchaWebView.MODE_ICON_SELECT    图标点选式
  //      4. SmCaptchaWebView.MODE_SEQ_SELECT     语序点选
  //      5. SmCaptchaWebView.MODE_SPATIAL_SELECT 空间逻辑推理
  //模式
  Widget _getCaptchaMode() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _radioWidget('滑动式', 0),
        const SizedBox(width: 20),
        _radioWidget('文字点选式', 1),
        const SizedBox(width: 20),
        _radioWidget('图标点选式', 2),
        const SizedBox(width: 20),
        _radioWidget('语序点选', 3),
        const SizedBox(width: 20),
        _radioWidget('空间逻辑推理', 4),
      ],
    );
  }

  Widget _radioWidget(String title, int val) {
    return SizedBox(
      height: 30.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Radio(
          value: val,
          groupValue: captchaMode,
          onChanged: (value) {
            setState(() {
              captchaMode = int.parse(value.toString());
            });
          },
        ),
        Text(title, style: const TextStyle(color: Colors.black45)),
      ]),
    );
  }

  void _show() {
    SmartDialog.show(
      isLoadingTemp: false,
      widget: Container(
        height: 275.0,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1D2933),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: SmCaptchaView(
          onCaptchaCreated: (controller) {
            controller.start();
          },
          onReady: () {
            return onReady();
          },
          onSuccess: (pass, rid) async {
            print("--------->onSuccess $pass,$rid");
            if (pass) {
              SmartDialog.dismiss();
            }
          },
          onError: (code, msg) async {
            print("--------->onError $code,$msg");
          },
          onCancel: () async {
            SmartDialog.dismiss();
          },
        ),
      ),
    );
  }
}
