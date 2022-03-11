package com.sm.captcha;

import android.content.Context;
import android.view.View;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public final class SmCaptchaViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final View containerView;

    /**
     * @param messenger
     * @param containerView the codec used to decode the args parameter of {@link #create}.
     */
    public SmCaptchaViewFactory(BinaryMessenger messenger, View containerView) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.containerView = containerView;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        MethodChannel methodChannel = new MethodChannel(messenger, "plugins.flutter.io/sm_captcha_view_" + viewId);
        return new SmCaptchaView(context, methodChannel, params, containerView);
    }
}
