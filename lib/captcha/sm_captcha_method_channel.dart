part of sm_captcha;

class MethodChannelSmCaptchaView implements SmCaptchaViewController {
  MethodChannelSmCaptchaView(int id, this._platformCallbacksHandler)
      : _channel = MethodChannel('plugins.flutter.io/sm_captcha_view_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final SmCaptchaViewCallbacksHandler _platformCallbacksHandler;

  final MethodChannel _channel;

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onReady':
        return await _platformCallbacksHandler.onReady();
      case 'onSuccess':
        Map<String, dynamic> passMap = convert.jsonDecode(call.arguments);
        bool pass = passMap['pass'] == '0' ? true : false;
        String rid = passMap['rid'] ?? "";
        return await _platformCallbacksHandler.onSuccess(pass, rid);
      case 'onError':
        Map<String, dynamic> errorMap = convert.jsonDecode(call.arguments);
        int code = int.parse(errorMap['code']);
        String msg = errorMap['msg'] ?? "";
        return await _platformCallbacksHandler.onError(code, msg);
      case 'onCancel':
        return await _platformCallbacksHandler.onCancel();
    }

    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  @override
  Future<Null> start() => _channel.invokeMethod("start");
}
