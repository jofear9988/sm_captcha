part of sm_captcha;

//TODO: 静态调用方法
class SmCaptcha {
  static const MethodChannel _channel = MethodChannel('plugins.flutter.io/sm_captcha_view');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('start');
    return version;
  }
}
