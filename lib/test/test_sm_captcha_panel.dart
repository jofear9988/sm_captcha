part of sm_captcha;

class SmCaptchaPanel extends StatefulWidget {
  const SmCaptchaPanel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmCaptchaState();
}

class _SmCaptchaState extends State<SmCaptchaPanel> {
  //创建通道对象，与android端创建的通道对象名称一致
  late MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel("plugins.flutter.io/sm_captcha_view");
    _channel.setMethodCallHandler(_handlerMethodCall);
  }

  @override
  void dispose() {
    super.dispose();
    //注销通道的监听
    _channel.setMethodCallHandler(null);
  }

  Future<dynamic> _handlerMethodCall(MethodCall call) async {
    //获取通道监听中调用的函数名称
    String method = call.method;
    if (method == 'start') {
      method = "init";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Expanded(
            child: AndroidView(
              viewType: 'plugins.flutter.io/sm_captcha_view',
            ),
          ),
        ],
      ),
    );
  }
}
