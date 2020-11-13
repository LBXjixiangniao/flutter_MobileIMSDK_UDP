package com.lbx.flutter_MobileIMSDK;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

import net.x52im.mobileimsdk.android.ClientCoreSDK;
import net.x52im.mobileimsdk.android.conf.ConfigEntity;
import net.x52im.mobileimsdk.android.core.AutoReLoginDaemon;
import net.x52im.mobileimsdk.android.core.KeepAliveDaemon;
import net.x52im.mobileimsdk.android.core.LocalDataSender;
import net.x52im.mobileimsdk.android.core.QoS4ReciveDaemon;
import net.x52im.mobileimsdk.android.core.QoS4SendDaemon;
import net.x52im.mobileimsdk.android.event.ChatBaseEvent;
import net.x52im.mobileimsdk.android.event.ChatMessageEvent;
import net.x52im.mobileimsdk.android.event.MessageQoSEvent;
import net.x52im.mobileimsdk.server.protocal.Protocal;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Observer;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;



/** FlutterMobileIMSDKPlugin */
public class FlutterMobileIMSDKPlugin implements FlutterPlugin, MethodCallHandler, ChatBaseEvent, ChatMessageEvent, MessageQoSEvent {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  /** MobileIMSDK是否已被初始化. true表示已初化完成，否则未初始化. */
  private boolean init = false;

  private Context context;

  private static final String TAG = "FMobileIMSDKPlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_MobileIMSDK");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  private  HashMap getLoginInfo(){
    HashMap<String,Object> dic = new HashMap<String,Object>();
    dic.put("currentLoginUserId",ClientCoreSDK.getInstance().getCurrentLoginUserId());
    dic.put("currentLoginToken",ClientCoreSDK.getInstance().getCurrentLoginToken());
    dic.put("currentLoginExtra",ClientCoreSDK.getInstance().getCurrentLoginExtra());
    return dic;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "initMobileIMSDK":{
        initMobileIMSDK(call,result);
        break;
      }
      case "login":{
        login(call,result);
        break;
      }
      case "sendMessage":{
        sendMessage(call,result);
        break;
      }
      case "logout":{
        logout(call,result);
        break;
      }
      case "getConnectedStatus":{
        getConnectedStatus(call,result);
        break;
      }
      case "getCurrentLoginInfo":{
        getCurrentLoginInfo(call,result);
        break;
      }
      case "isAutoReLoginRunning":{
        isAutoReLoginRunning(call,result);
        break;
      }
      case "isKeepAliveRunning":{
        isKeepAliveRunning(call,result);
        break;
      }
      case "isQoS4SendDaemonRunning":{
        isQoS4SendDaemonRunning(call,result);
        break;
      }
      case "isQoS4ReciveDaemonRunning":{
        isQoS4ReciveDaemonRunning(call,result);
        break;
      }
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    // 释放IM占用资源
    ClientCoreSDK.getInstance().release();
  }

  private void initMobileIMSDK(@NonNull MethodCall call,@NonNull Result result)
  {
    if(!init) {
      if (call.arguments instanceof Map) {
        Map<Object, Object> dic = (Map) call.arguments;
        String serverIP = (String) dic.get("serverIP");
        Integer serverPort = (Integer) dic.get("serverPort");
        Integer senseMode = (Integer) dic.get("senseMode");
        Boolean debug = (Boolean) dic.get("debug");
        String appKey = (String) dic.get("appKey");
        if (serverIP != null && serverPort != null) {
          init = true;
          ConfigEntity.serverIP = serverIP;
          ConfigEntity.serverPort = serverPort;

          ClientCoreSDK.DEBUG = debug == Boolean.TRUE;
          if(ClientCoreSDK.DEBUG) {
            AutoReLoginDaemon.getInstance().setDebugObserver(
                    createObserverCompletionForDEBUG("AutoReLoginDaemonObserver"));
            KeepAliveDaemon.getInstance().setDebugObserver(
                    createObserverCompletionForDEBUG("KeepAliveDaemonObserver"));
            QoS4SendDaemon.getInstance().setDebugObserver(
                    createObserverCompletionForDEBUG("QoS4SendDaemonObserver"));
            QoS4ReciveDaemon.getInstance().setDebugObserver(
                    createObserverCompletionForDEBUG("QoS4ReciveDaemonObserver"));
          }
          if (senseMode != null && senseMode < ConfigEntity.SenseMode.values().length) {
            ConfigEntity.setSenseMode(ConfigEntity.SenseMode.values()[senseMode]);
          }
          if(appKey != null) {
            // 设置AppKey
            ConfigEntity.appKey = appKey;
          }
          // 【特别注意】请确保首先进行核心库的初始化（这是不同于iOS和Java端的地方)
          ClientCoreSDK.getInstance().init(this.context);

          ClientCoreSDK.getInstance().setChatBaseEvent(this);
          ClientCoreSDK.getInstance().setChatMessageEvent(this);
          ClientCoreSDK.getInstance().setMessageQoSEvent(this);

          HashMap<String, Object> resultDic = new HashMap<>();
          resultDic.put("result", Boolean.TRUE);
          result.success(resultDic);
          return;
        }
      }
      HashMap<String, Object> resultDic = new HashMap<>();
      resultDic.put("result", Boolean.FALSE);
      result.success(resultDic);
    }
  }

  private Observer createObserverCompletionForDEBUG(@NonNull String methodName)
  {
    final WeakReference<FlutterMobileIMSDKPlugin> weakSelf = new WeakReference<>(this);
    return (o, arg) -> {
      if(arg != null) {
        int status = (int) arg;
        if(weakSelf.get() != null) {
          weakSelf.get().channel.invokeMethod(methodName,status);
        }
      }
    };
  }

  @SuppressLint("StaticFieldLeak")
  private void login(@NonNull MethodCall call, @NonNull final Result result) {
    if(call.arguments instanceof Map) {
      Map dic = (Map) call.arguments;
      String loginUserId = (String) dic.get("loginUserId");
      String loginToken = (String) dic.get("loginToken");
      String extra = (String) dic.get("extra");

      if (loginUserId != null && loginToken != null) {
        // * 发送登陆数据包(提交登陆名和密码)
        new LocalDataSender.SendLoginDataAsync(loginUserId, loginToken, extra) {
          /**
           * 登陆信息发送完成后将调用本方法（注意：此处仅是登陆信息发送完成
           * ，真正的登陆结果要在异步回调中处理哦）。
           *
           * @param code 数据发送返回码，0 表示数据成功发出，否则是错误码
           */
          @Override
          protected void fireAfterSendLogin(int code) {
            HashMap<String, Object> resultDic = new HashMap<String, Object>();
            if (code == 0) {
              Log.d(TAG, "登陆/连接信息已成功发出！");
              resultDic.put("result", Boolean.TRUE);
            } else {
              Log.d(TAG, "登陆/连接信息发送失败！");
              resultDic.put("result", Boolean.FALSE);
            }
            result.success(resultDic);
          }
        }.execute();
        return;
      }
    }
      HashMap<String,Object> resultDic = new HashMap<>();
      resultDic.put("result", Boolean.FALSE);
      result.success(resultDic);

  }

  @SuppressLint("StaticFieldLeak")
  private void logout(@NonNull MethodCall call, @NonNull final Result result) {
    final WeakReference<FlutterMobileIMSDKPlugin> weakSelf = new WeakReference<>(this);
    // 发出退出登陆请求包（Android系统要求必须要在独立的线程中发送哦）
    new AsyncTask<Object, Integer, Integer>(){
      @Override
      protected Integer doInBackground(Object... params)
      {
        int code = -1;
        try{
          code = LocalDataSender.getInstance().sendLoginout();
        }
        catch (Exception e){
          Log.w(TAG, e);
        }

        //## BUG FIX: 20170713 START by JackJiang
        // 退出登陆时记得一定要调用此行，不然不退出APP的情况下再登陆时会报 code=203错误哦！
        if(weakSelf.get() != null) {
          weakSelf.get().init = false;
        }
        //## BUG FIX: 20170713 END by JackJiang

        return code;
      }

      @Override
      protected void onPostExecute(Integer code)
      {
        HashMap<String,Object> resultDic = new HashMap<String,Object>();
        if(code == 0)
          resultDic.put("result", Boolean.TRUE);
        else {
          resultDic.put("result", Boolean.FALSE);
        }
        result.success(resultDic);
      }
    }.execute();
  }

  @SuppressLint("StaticFieldLeak")
  private void sendMessage(@NonNull MethodCall call, @NonNull final Result result) {
    if(call.arguments instanceof Map) {
      Map dic = (Map) call.arguments;
      String dataContent = (String) dic.get("dataContent");
      String toUserId = (String) dic.get("toUserId");
      String fingerPrint = (String) dic.get("fingerPrint");
      Boolean qos = (Boolean) dic.get("qos");
      Integer typeu = (Integer) dic.get("typeu");
      if (dataContent != null && toUserId != null) {
        // 发送消息（Android系统要求必须要在独立的线程中发送哦）
        new AsyncTask<Object, Integer, Integer>() {
          @Override
          protected Integer doInBackground(Object... params) {
            int code = LocalDataSender.getInstance().sendCommonData(dataContent, toUserId, qos == true, fingerPrint, typeu == null ? -1 : typeu);
            return code;
          }

          @Override
          protected void onPostExecute(Integer code) {
            HashMap<String, Object> resultDic = new HashMap<>();
            if (code == 0) {
              resultDic.put("result", Boolean.TRUE);
            } else {
              resultDic.put("result", Boolean.FALSE);
            }
            result.success(resultDic);
          }
        }.execute();
        return;
      }
    }

      HashMap<String,Object> resultDic = new HashMap<>();
      resultDic.put("result", Boolean.FALSE);
      result.success(resultDic);
  }

  private void getConnectedStatus(@NonNull MethodCall call,@NonNull Result result) {
    // 获取与服务器连接状态
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", Boolean.TRUE);
    dic.put("value", ClientCoreSDK.getInstance().isConnectedToServer());
    result.success(dic);
  }

  private void getCurrentLoginInfo(@NonNull MethodCall call,@NonNull Result result) {
    // 获取当前登录信息
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", ClientCoreSDK.getInstance().getCurrentLoginUserId() != null && ClientCoreSDK.getInstance().getCurrentLoginToken() != null);
    dic.put("value", getLoginInfo());
    result.success(dic);
  }

  private void isAutoReLoginRunning(@NonNull MethodCall call,@NonNull Result result) {
    // 自动登录重连是否正在运行
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", Boolean.TRUE);
    dic.put("value", AutoReLoginDaemon.getInstance().isAutoReLoginRunning());
    result.success(dic);
  }

  private void isKeepAliveRunning(@NonNull MethodCall call,@NonNull Result result) {
    // keepAlive是否正在运行
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", Boolean.TRUE);
    dic.put("value", KeepAliveDaemon.getInstance().isKeepAliveRunning());
    result.success(dic);
  }

  private void isQoS4SendDaemonRunning(@NonNull MethodCall call,@NonNull Result result) {
    // QoS4SendDaemon是否正在运行
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", Boolean.TRUE);
    dic.put("value", QoS4SendDaemon.getInstance().isRunning());
    result.success(dic);
  }

  private void isQoS4ReciveDaemonRunning(@NonNull MethodCall call,@NonNull Result result) {
    // QoS4ReciveDaemon是否正在运行
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("result", Boolean.TRUE);
    dic.put("value", QoS4ReciveDaemon.getInstance().isRunning());
    result.success(dic);
  }

  /**
   * 本地用户的登陆结果回调事件通知。
   *
   * @param errorCode 服务端反馈的登录结果：0 表示登陆成功，否则为服务端自定义的出错代码（按照约定通常为>=1025的数）
   */
  @Override
  public void onLoginResponse(int errorCode) {
    if (errorCode == 0)
    {
      Log.i(TAG, "【DEBUG_UI】IM服务器登录/重连成功！");
      channel.invokeMethod("loginSuccess", getLoginInfo());
    }
    else
    {
      Log.e(TAG, "【DEBUG_UI】IM服务器登录/连接失败，错误代码：" + errorCode);
      channel.invokeMethod("loginFail", errorCode);
    }
  }

  /**
   * 与服务端的通信断开的回调事件通知。
   * <br>
   * 该消息只有在客户端连接服务器成功之后网络异常中断之时触发。<br>
   * 导致与与服务端的通信断开的原因有（但不限于）：无线网络信号不稳定、WiFi与2G/3G/4G等同开情况下的网络切换、手机系统的省电策略等。
   *
   * @param errorCode 本回调参数表示表示连接断开的原因，目前错误码没有太多意义，仅作保留字段，目前通常为-1
   */
  @Override
  public void onLinkClose(int errorCode) {
    Log.e(TAG, "【DEBUG_UI】与IM服务器的网络连接出错关闭了，error：" + errorCode);
    channel.invokeMethod("linkClose", errorCode);
  }

  /**
   * 收到普通消息的回调事件通知。
   * <br>应用层可以将此消息进一步按自已的IM协议进行定义，从而实现完整的即时通信软件逻辑。
   *
   * @param fingerPrintOfProtocal 当该消息需要QoS支持时本回调参数为该消息的特征指纹码，否则为null
   * @param userid 消息的发送者id（MobileIMSDK框架中规定发送者id="0"即表示是由服务端主动发过的，否则表示的
   *                  是其它客户端发过来的消息）
   * @param dataContent 消息内容的文本表示形式
   * @param typeu 意义：应用层专用字段——用于应用层存放聊天、推送等场景下的消息类型。 注意：此值为-1时表示未定
   *                 义。MobileIMSDK_X框架中，本字段为保留字段，不参与框架的核心算法，专留用应用 层自行定义
   *                 和使用。 默认：-1。
   * @see <a href="http://docs.52im.net/extend/docs/api/mobileimsdk/server_netty/net/openmob/mobileimsdk/server/protocal/Protocal.html" target="_blank">Protocal</a>
   */
  @Override
  public void onRecieveMessage(String fingerPrintOfProtocal, String userid, String dataContent, int typeu){
    Log.d(TAG, "【DEBUG_UI】[typeu="+typeu+"]收到来自用户"+userid+"的消息:"+dataContent);
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("fingerPrint",fingerPrintOfProtocal);
    dic.put("userId",userid);
    dic.put("dataContent",dataContent);
    dic.put("typeu",typeu);
    channel.invokeMethod("onRecieveMessage", dic);
  }

  /**
   * 服务端反馈的出错信息回调事件通知。
   *
   * @param errorCode 错误码，定义在常量表 ErrorCode.ForS 类中
   * @param errorMsg 描述错误内容的文本信息
   * @see <a href="http://docs.52im.net/extend/docs/api/mobileimsdk/server/net/openmob/mobileimsdk/server/protocal/ErrorCode.ForS.html">ErrorCode.ForS类</a>
   */
  @Override
  public void onErrorResponse(int errorCode, String errorMsg) {
    Log.d(TAG, "【DEBUG_UI】收到服务端错误消息，errorCode="+errorCode+", errorMsg="+errorMsg);
    HashMap<String,Object> dic = new HashMap<>();
    dic.put("errorMsg",errorMsg);
    dic.put("errorCode",errorCode);
    channel.invokeMethod("onErrorResponse", dic);
  }

  /**
   * 消息未送达的回调事件通知.
   *
   * @param arrayList 由MobileIMSDK QoS算法判定出来的未送达消息列表（此列表中的Protocal对象是原对象的
   *                        clone（即原对象的深拷贝），请放心使用哦），应用层可通过指纹特征码找到原消息并可
   *                        以UI上将其标记为”发送失败“以便即时告之用户
   * @see net.x52im.mobileimsdk.server.protocal.Protocal
   */
  @Override
  public void messagesLost(ArrayList<Protocal> arrayList) {
    Log.d(TAG, "【DEBUG_UI】收到系统的未实时送达事件通知，当前共有"+arrayList.size()+"个包QoS保证机制结束，判定为【无法实时送达】！");
    ArrayList<HashMap<String,Object>> lostArray = new ArrayList<>();
    for (Protocal protocal: arrayList) {
      HashMap<String,Object> dic = new HashMap<>();
      dic.put("bridge",protocal.isBridge());
      dic.put("type",protocal.getType());
      dic.put("dataContent",protocal.getDataContent());
      dic.put("from",protocal.getFrom());
      dic.put("to",protocal.getTo());
      dic.put("fp",protocal.getFp());
      dic.put("QoS",protocal.isQoS());
      dic.put("typeu",protocal.getTypeu());
    }
    channel.invokeMethod("qosMessagesLost", lostArray);
  }

  /**
   * 消息已被对方收到的回调事件通知.
   * <p>
   * <b>目前，判定消息被对方收到是有两种可能：</b><br>
   * <ul>
   * <li>1) 对方确实是在线并且实时收到了；</li>
   * <li>2) 对方不在线或者服务端转发过程中出错了，由服务端进行离线存储成功后的反馈（此种情况严格来讲不能算是“已被
   * 		收到”，但对于应用层来说，离线存储了的消息原则上就是已送达了的消息：因为用户下次登陆时肯定能通过HTTP协议取到）。</li>
   * </ul>
   *
   * @param theFingerPrint 已被收到的消息的指纹特征码（唯一ID），应用层可据此ID来找到原先已发生的消息并可在
   *                          UI是将其标记为”已送达“或”已读“以便提升用户体验
   * @see net.x52im.mobileimsdk.server.protocal.Protocal
   */
  @Override
  public void messagesBeReceived(String theFingerPrint) {
    if(theFingerPrint != null)
    {
      Log.d(TAG, "【DEBUG_UI】收到对方已收到消息事件的通知，fp="+theFingerPrint);
      channel.invokeMethod("qosMessagesBeReceived", theFingerPrint);
    }
  }
}
