library sm_captcha;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

part 'captcha/sm_interface.dart';       //接口
part 'captcha/sm_captcha_method_channel.dart'; // 渠道方法处理
part 'sm_captcha_view.dart';            // 滑块视图
part 'captcha/android_sm_captcha.dart'; // Android 视图实现
part 'captcha/ios_sm_captcha.dart';     // Ios 视图实现
part 'captcha/sm_config.dart';

part 'test/test_sm_captcha_panel.dart';   //测试 视图创建
part 'test/test_sm_captcha.dart';     //测试 接口方法调用
