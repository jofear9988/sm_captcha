part of sm_captcha;

///数美滑块验证码
class SmCaptchaView extends StatefulWidget {
  const SmCaptchaView({
    Key? key,
    required this.onReady,
    required this.onSuccess,
    this.onCaptchaCreated,
    SmCaptchaMode? captchaMode,
    SmCaptchaStyle? captchaStyle,
    this.onError,
    this.onCancel,
  })  : captchaViewMode = captchaMode ?? SmCaptchaMode.MODE_SLIDE,
        captchaViewStyle = captchaStyle ??SmCaptchaStyle.POPUPS,
        super(key: key);

  final SmCaptchaCreatedCallback? onCaptchaCreated;
  final SmCaptchaViewReadyCallback onReady; //Ui初始化回调
  final SmCaptchaSuccessCallback onSuccess; //成功回调
  final SmCaptchaViewNullCallback? onCancel; //关闭回调
  final SmCaptchaCallback? onError; //错误回调
  final SmCaptchaMode captchaViewMode; //验证码模式
  final SmCaptchaStyle captchaViewStyle; //验证码样式

  @override
  State<StatefulWidget> createState() => _SmCaptchaViewState();
}

class _SmCaptchaViewState extends State<SmCaptchaView> {
  final Completer<SmCaptchaController> _controller = Completer<SmCaptchaController>();

  //操作回调
  late _PlatformCallbacksHandler _platformCallbacksHandler;
  late SmCaptchaViewPlatform? _platform;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = _SurfaceAndroidCaptchaView();
    }
    _platformCallbacksHandler = _PlatformCallbacksHandler(widget);
  }

  @override
  void didUpdateWidget(SmCaptchaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.future.then((SmCaptchaController controller) {
      _platformCallbacksHandler._widget = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return platform._build(
        context: context,
        handler: _platformCallbacksHandler, //数据回调处理
        onSmCaptchaViewCreated: _onCaptchaCreated, //视图创建
    );
  }

  //创建视图
  void _onCaptchaCreated(SmCaptchaViewController captchaViewPlatform) {
    final SmCaptchaController controller = SmCaptchaController._(captchaViewPlatform);
    _controller.complete(controller);
    if (widget.onCaptchaCreated != null) {
      widget.onCaptchaCreated!(controller);
    }
  }

  set platform(SmCaptchaViewPlatform? platform) {
    _platform = platform;
  }

  SmCaptchaViewPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidSmCaptcha();
          break;
        case TargetPlatform.iOS:
          _platform = IosSmCaptcha();
          break;
        default:
          throw UnsupportedError("尝试用默认实现 $defaultTargetPlatform");
      }
    }
    return _platform!;
  }
}

class _SurfaceAndroidCaptchaView extends AndroidSmCaptcha {
  @override
  Widget build({
    required BuildContext context,
    SmCaptchaViewCreatedCallback? onCaptchaViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    required SmCaptchaViewCallbacksHandler handler,
  }) {
    assert(Platform.isAndroid);
    return PlatformViewLink(
      viewType: 'plugins.flutter.io/sm_captcha_view',
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: 'plugins.flutter.io/sm_captcha_view',
          // WebView content is not affected by the Android view's layout direction,
          // we explicitly set it here so that the widget doesn't require an ambient
          // directionality.
          layoutDirection: TextDirection.rtl,
          creationParamsCodec: const StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((int id) {
            if (onCaptchaViewCreated == null) {
              return;
            }
            onCaptchaViewCreated(
              MethodChannelSmCaptchaView(id, handler),
            );
          })
          ..create();
      },
    );
  }
}

class _PlatformCallbacksHandler implements SmCaptchaViewCallbacksHandler {
  _PlatformCallbacksHandler(this._widget);

  SmCaptchaView _widget;

  @override
  Future<Null> onCancel() async {
    return await _widget.onCancel!();
  }

  @override
  Future<Null> onError(int code,String msg) async {
    return await _widget.onError!(code,msg);
  }

  @override
  Future<String?> onReady() async {
    return await _widget.onReady();
  }

  @override
  Future<bool?> onSuccess(pass,rid) async {
    //pass 0 成功 pass 为1 失败
    return await _widget.onSuccess(pass,rid);
  }
}
