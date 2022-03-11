package com.sm.captcha;

import com.google.gson.Gson;

public class SmConfigBean {

    private String organization;
    private String appId;
    private int captchaMode;
    private String channel;
    private String deviceId;
    private String tipMessage;
    private int language;
    private String cdnHost;
    private String host;
    private int protocol;

    public static SmConfigBean fromJsonData(String str) {
        return new Gson().fromJson(str, SmConfigBean.class);
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public int getCaptchaMode() {
        return captchaMode;
    }

    public void setCaptchaMode(int captchaMode) {
        this.captchaMode = captchaMode;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getTipMessage() {
        return tipMessage;
    }

    public void setTipMessage(String tipMessage) {
        this.tipMessage = tipMessage;
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public String getCdnHost() {
        return cdnHost;
    }

    public void setCdnHost(String cdnHost) {
        this.cdnHost = cdnHost;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public int getProtocol() {
        return protocol;
    }

    public void setProtocol(int protocol) {
        this.protocol = protocol;
    }
}
