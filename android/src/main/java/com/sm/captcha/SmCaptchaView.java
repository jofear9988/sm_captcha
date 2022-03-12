package com.sm.captcha;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.webkit.WebView;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.ishumei.sdk.captcha.SmCaptchaWebView;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class SmCaptchaView implements PlatformView, MethodChannel.MethodCallHandler {
    public static final String TAG = "SmCaptcha";

    private final Context context;
    private final MethodChannel methodChannel;
    private FrameLayout captchaContainer;
    private SmCaptchaWebView mCaptchaView;

    SmCaptchaView(
            final Context context,
            MethodChannel methodChannel,
            Map<String, Object> params,
            View containerView) {
        this.context = context;
        this.methodChannel = methodChannel;
        this.methodChannel.setMethodCallHandler(this);

        captchaContainer = new FrameLayout(context);
        captchaContainer.setBackgroundResource(R.drawable.bg_rounded_shape);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // todo: 测试代码，正式环境需要移除
            WebView.setWebContentsDebuggingEnabled(true);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        //获取监听到的函数名称
        String methodName = call.method;
        if (methodName.equals("start")) {
            onReadyResult();
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public View getView() {
        return captchaContainer;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
    }

    //
    private void onReadyResult() {
        methodChannel.invokeMethod("onReady", null, new MethodChannel.Result() {

            @Override
            public void success(@Nullable Object result) {
                if (result != null) {
                    SmConfigBean configBean = SmConfigBean.fromJsonData(result.toString());
                    loadCaptcha(configBean);
                } else {

                }
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

            }

            @Override
            public void notImplemented() {

            }
        });
    }


    //定义结果回调方法 备注 0 成功; 1001 传入参数为空; 1002 未传入 organization; 1003 未传入 appId; 1004 未设置回调; 1005 网络问题; 1006 返回结果出错
    public void loadCaptcha(SmConfigBean configBean) {
        log("loadCaptcha");
        // 定义结果回调方法
        SmCaptchaWebView.ResultListener listener = new SmCaptchaWebView.ResultListener() {
            // 验证码图片加载成功回调函数
            @Override
            public void onReady() {
                log("onRead");
            }

            // 处理过程出现异常回调函数
            @Override
            public void onError(int code) {
                String errorMap = "{\"code\": \"" + code + "\", \"msg\": \"" + errCode(code) + "\"}";
                methodChannel.invokeMethod("onError", errorMap, null);
            }

            // 滑动结束回调函数，滑动验证未通过pass为false，滑动验证通过pass为true。
            @Override
            public void onSuccess(CharSequence rid, boolean pass) {
                String passMap = "{\"rid\": \"" + rid.toString() + "\", \"pass\": \"" + (pass ? 0 : 1) + "\"}";
                methodChannel.invokeMethod("onSuccess", passMap, null);
            }
        };

        // 初始化
        mCaptchaView = new SmCaptchaWebView(context);
        mCaptchaView.setBackgroundColor(0);
        // 验证码 View 推荐宽高比为 3:2
        int width = captchaContainer.getMeasuredWidth() - getPixels(16) * 2;
        int height = (int) (width * 2f / 3);
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(width, height);
        layoutParams.gravity = Gravity.CENTER;
        mCaptchaView.setLayoutParams(layoutParams);

        SmCaptchaWebView.SmOption option = new SmCaptchaWebView.SmOption();
        // （必填项） todo: 替换成自己的organization
        option.setOrganization(configBean.getOrganization());
        // （必填项）todo: 与后台管理页面保持一致，可直接使用 default
        option.setAppId(configBean.getAppId());

        option.setMode(getCaptchaMode(configBean.getCaptchaMode()));
        // （选填项）渠道标识
        if (!TextUtils.isEmpty(configBean.getChannel())) {
            option.setChannel(configBean.getChannel());
        }
        // （选填项）数美反欺诈 SDK 获取到的设备标识，如果有数美标识就填入，没有则删除
        if (!TextUtils.isEmpty(configBean.getDeviceId())) {
            option.setDeviceId(configBean.getDeviceId());
        }
        // （选填项）自定义提示文字，仅滑动式支持
        if (!TextUtils.isEmpty(configBean.getTipMessage())) {
            option.setTipMessage(configBean.getTipMessage());
        }

        // （选填项）验证码英文主题，默认中文
        if (configBean.getLanguage() == 1) {
            Map<String, Object> extOption = new HashMap<>();
            extOption.put("lang", "en");
            option.setExtOption(extOption);
        }

        // （选填项）连接新加坡机房特殊配置项，仅供验证码数据上报新加坡机房客户使用
        // option.setCdnHost("castatic-xjp.fengkongcloud.com");
        // option.setHost("captcha-xjp.fengkongcloud.com");
        // （选填项）连接美国机房特殊配置项，仅供验证码数据上报美国机房客户使用
        // option.setCdnHost("castatic-fjny.fengkongcloud.com");
        // option.setHost("captcha-fjny.fengkongcloud.com");
        if (!TextUtils.isEmpty(configBean.getCdnHost())) {
            option.setCdnHost(configBean.getCdnHost());
        }

        if (!TextUtils.isEmpty(configBean.getHost())) {
            option.setHost(configBean.getHost());
        }

        // 私有化设置
        /*String captchaHtml = etCaptchaHtml.getText().toString().trim();
        if (!TextUtils.isEmpty(captchaHtml)) {
            // 设置验证码 url
            option.setCaptchaHtml(captchaHtml);
            // 设置验证码 api 接口域名：格式 host[:port]
            option.setHost(host);
        }*/

        // （选填项）选择使用 https 网络协议，默认使用 http
        option.setHttps(configBean.getProtocol() == 0);

        int code = mCaptchaView.initWithOption(option, listener);
        if (SmCaptchaWebView.SMCAPTCHA_SUCCESS != code) {
            log("init failed:" + code);
        }

        // 放到容器中
        captchaContainer.removeAllViews();
        captchaContainer.addView(mCaptchaView);
    }

    private void log(final String log) {
        Log.i(TAG, log);
    }

    public void disable(View view) {
        mCaptchaView.disableCaptcha();
    }

    public void enable(View view) {
        mCaptchaView.enableCaptcha();
    }

    public int getPixels(int dp) {
        float scale = this.getView().getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }

    @NonNull
    private String getCaptchaMode(int mode) {
        // （选填项）选择验证模式，支持以下模式
        //      1. SmCaptchaWebView.MODE_SLIDE          滑动式（默认）
        //      2. SmCaptchaWebView.MODE_SELECT         文字点选式
        //      3. SmCaptchaWebView.MODE_ICON_SELECT    图标点选式
        //      4. SmCaptchaWebView.MODE_SEQ_SELECT     语序点选
        //      5. SmCaptchaWebView.MODE_SPATIAL_SELECT 空间逻辑推理
        if (mode == 1) {
            return SmCaptchaWebView.MODE_SELECT;
        } else if (mode == 2) {
            return SmCaptchaWebView.MODE_ICON_SELECT;
        } else if (mode == 3) {
            return SmCaptchaWebView.MODE_SEQ_SELECT;
        } else if (mode == 4) {
            return SmCaptchaWebView.MODE_SPATIAL_SELECT;
        } else {
            return SmCaptchaWebView.MODE_SLIDE;
        }
    }

    private String errCode(int code) {
        if (code == 0) {
            return "0:--成功";
        } else if (code == 1001) {
            return "1001:--传入参数为空";
        } else if (code == 1002) {
            return "1002:--未传入 organization";
        } else if (code == 1003) {
            return "1003:--未传入 appId";
        } else if (code == 1004) {
            return "1004:--未设置回调";
        } else if (code == 1005) {
            return "1005:--网络问题";
        } else if (code == 1006) {
            return "1006:--返回结果出错";
        } else {
            return "错误";
        }
    }
}
