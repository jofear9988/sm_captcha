part of sm_captcha;

class SmConfig {

  String organization;  //（必填项） 替换成自己的organization
  String appId;         //（必填项） 与后台管理页面保持一致，可直接使用 default
  int? captchaMode = 0;       //（选填项）选择验证码模式，支持以下模式
  String? channel = '';       // （选填项）渠道标识
  String? tipMessage = '';    // （选填项）自定义提示文字，仅滑动式支持
  int? language = 0;          // （选填项）验证码英文主题，默认中文
  // （选填项）连接新加坡机房特殊配置项，仅供验证码数据上报新加坡机房客户使用
  // option.setCdnHost("castatic-xjp.fengkongcloud.com");
  // option.setHost("captcha-xjp.fengkongcloud.com");
  // （选填项）连接美国机房特殊配置项，仅供验证码数据上报美国机房客户使用
  // option.setCdnHost("castatic-fjny.fengkongcloud.com");
  // option.setHost("captcha-fjny.fengkongcloud.com");
  String? cdnHost = '';
  String? host = '';
  int? protocol = 0;          // （选填项）选择使用 https 网络协议，默认使用 http

  SmConfig({
    required this.organization,
    required this.appId,
    this.captchaMode,
    this.channel,
    this.tipMessage,
    this.language,
    this.cdnHost,
    this.host,
    this.protocol,
  });

  factory SmConfig.fromJson(Map<String, dynamic> jsonRes) => SmConfig(
        organization: jsonRes['organization'],
        appId: jsonRes['appId'],
        captchaMode: jsonRes['captchaMode'] ?? 0,
        channel: jsonRes['channel'] ?? '',
        tipMessage: jsonRes['tipMessage'] ?? '',
        language: jsonRes['language'] ?? 0,
        cdnHost: jsonRes['cdnHost'] ?? '',
        host: jsonRes['host'] ?? '',
        protocol: jsonRes['protocol'] ?? 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'appId': appId,
      'captchaMode': captchaMode,
      'channel': channel,
      'tipMessage': tipMessage,
      'language': language,
      'cdnHost': cdnHost,
      'host': host,
      'protocol': protocol,
    };
  }
}
