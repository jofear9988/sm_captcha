part of sm_captcha;

///Android滑块验证码交互视图创建
class AndroidSmCaptcha implements SmCaptchaViewPlatform {
  @override
  Widget _build({
    required BuildContext context,
    required SmCaptchaViewCallbacksHandler handler,
    SmCaptchaViewCreatedCallback? onSmCaptchaViewCreated,
  }) {
    return GestureDetector(
      onLongPress: () {},
      excludeFromSemantics: true,
      child: AndroidView(
        viewType: 'plugins.flutter.io/sm_captcha_view',
        onPlatformViewCreated: (int id) {
          if (onSmCaptchaViewCreated == null) {
            return;
          }
          onSmCaptchaViewCreated(MethodChannelSmCaptchaView(id, handler));
        },
        layoutDirection: Directionality.maybeOf(context) ?? TextDirection.rtl,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
