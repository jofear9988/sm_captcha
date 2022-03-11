part of sm_captcha;

enum SmCaptchaStyle { POPUPS, PAGE }
enum SmCaptchaMode {
  MODE_SLIDE,
  MODE_SELECT,
  MODE_ICON_SELECT,
  MODE_SEQ_SELECT,
  MODE_SPATIAL_SELECT
}

typedef void SmCaptchaCreatedCallback(SmCaptchaController controller);
typedef SmCaptchaViewCreatedCallback = void Function(SmCaptchaViewController controller);
typedef SmCaptchaViewReadyCallback = Future<String?> Function();
typedef SmCaptchaViewNullCallback = Future<Null> Function();
typedef SmCaptchaNullCallback = Future<Null> Function(String);
typedef SmCaptchaSuccessCallback = Future<Null> Function(bool,String);
typedef SmCaptchaCallback = Future<Null> Function(int,String);

///各平台交互回调处理
abstract class SmCaptchaViewCallbacksHandler {
  // 验证码图片加载成功回调函数
  Future<String?> onReady();

  // 用户操作结束回调函数，操作验证未通过 pass 为 false，操作验证通过 pass 为 true。 @Override
  Future<bool?> onSuccess(bool pass,String rid);

  // 处理过程出现异常回调函数
  Future<Null> onError(int code,String msg);

  // 关闭
  Future<Null> onCancel();
}

///视图控制器
abstract class SmCaptchaViewController {
  SmCaptchaViewController(SmCaptchaViewCallbacksHandler handler);

  Future<Null> start() {
    throw UnimplementedError("当前平台未实现此方法");
  }
}

///验证码视图创建
abstract class SmCaptchaViewPlatform {
  Widget _build(
      {required BuildContext context,
      required SmCaptchaViewCallbacksHandler handler,
      SmCaptchaViewCreatedCallback? onSmCaptchaViewCreated});
}

class SmCaptchaController {
  SmCaptchaController._(this._smCaptchaViewController);

  final SmCaptchaViewController _smCaptchaViewController;

  Future<Null> start() {
    return _smCaptchaViewController.start();
  }
}
