part of sm_captcha;

///数美滑块验证码
class SmCaptchaView extends StatefulWidget {
  const SmCaptchaView({
    Key? key,
    required this.onReady,
    required this.onSuccess,
    this.onCaptchaCreated,
    this.onError,
    this.onCancel,
  }) : super(key: key);

  final SmCaptchaCreatedCallback? onCaptchaCreated;
  final SmCaptchaViewReadyCallback onReady; //Ui初始化回调
  final SmCaptchaSuccessCallback onSuccess; //成功回调
  final SmCaptchaViewNullCallback? onCancel; //关闭回调
  final SmCaptchaCallback? onError; //错误回调

  @override
  State<StatefulWidget> createState() => _SmCaptchaViewState();
}

class _SmCaptchaViewState extends State<SmCaptchaView> {
  final Completer<SmCaptchaController> _controller =
      Completer<SmCaptchaController>();

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
    return Container(
      constraints: const BoxConstraints(
        minHeight: 285.0,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 245.0,
              width: double.infinity,
              child: platform._build(
                context: context,
                handler: _platformCallbacksHandler, //数据回调处理
                onSmCaptchaViewCreated: _onCaptchaCreated, //视图创建
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 16),
                  const Text(
                    '安全验证',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.onCancel?.call();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.clear,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //创建视图
  void _onCaptchaCreated(SmCaptchaViewController captchaViewPlatform) {
    final SmCaptchaController controller =
        SmCaptchaController._(captchaViewPlatform);
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
  Future<Null> onError(int code, String msg) async {
    return await _widget.onError!(code, msg);
  }

  @override
  Future<String?> onReady() async {
    return await _widget.onReady();
  }

  @override
  Future<bool?> onSuccess(pass, rid) async {
    //pass 0 成功 pass 为1 失败
    return await _widget.onSuccess(pass, rid);
  }
}
