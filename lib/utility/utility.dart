import 'package:chat_app/models/chatMessageModel.dart';
import 'package:chat_app/models/user.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class SocketUtils {
  //
  // static String _connectUrl = 'https://dartchat.herokuapp.com/';
  static String _connectUrl = 'http://192.168.1.108:9000/';

  // Events
  static const String ON_MESSAGE_RECEIVED = 'receive_message';
  static const String SUB_EVENT_MESSAGE_SENT = 'message_sent_to_user';
  static const String IS_USER_CONNECTED_EVENT = 'is_user_connected';
  static const String IS_USER_ONLINE_EVENT = 'check_online';
  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';
  static const String EVENT_ONLINE_USER_LIST = 'online_user_list';

  // Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;
  static const int STATUS_MESSAGE_DELIVERED = 10003;
  static const int STATUS_MESSAGE_READ = 10004;

  // Type of Chat
  static const String SINGLE_CHAT = 'single_chat';

  User _fromUser;

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket(User fromUser) async {
    print('Connecting user: ${fromUser.name}');
    this._fromUser = fromUser;
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  _socketOptions() {
    final Map<String, String> userMap = {
      'from': _fromUser.id.toString(),
    };
    return SocketOptions(
      _connectUrl,
      enableLogging: true,
      transports: [Transports.WEB_SOCKET],
      query: userMap,
    );
  }

  sendSingleChatMessage(ChatMessageModel chatMessageModel, User toChatUser) {
    print('Sending Message to: ${toChatUser.name}, ID: ${toChatUser.id}');
    if (null == _socket) {
      print("Socket is Null, Cannot send message");
      return;
    }
    _socket.emit("single_chat_message", [chatMessageModel.toJson()]);
  }

  setOnMessageBackFromServer(Function onMessageBackFromServer) {
    _socket.on(SUB_EVENT_MESSAGE_FROM_SERVER, (data) {
      onMessageBackFromServer(data);
    });
  }

  checkOnline(ChatMessageModel chatMessageModel) {
    print('Checking Online: ${chatMessageModel.to}');
    if (null == _socket) {
      print("Socket is Null, Cannot send message");
      return;
    }
    _socket.emit(IS_USER_ONLINE_EVENT, [chatMessageModel.toJson()]);
  }

  onlineUserList(Function onlineUserList){
    _socket.on(EVENT_ONLINE_USER_LIST, (data) {
      onlineUserList(data);
    });
  }

  connectToSocket() {
    if (null == _socket) {
      print("Socket is Null");
      return;
    }
    print("Connecting to socket...");
    _socket.connect();
  }

  setConnectListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    _socket.onConnectError((data) {
      onConnectError(data);
    });
  }

  setOnConnectionErrorTimeOutListener(Function onConnectTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectTimeout(data);
    });
  }

  setOnErrorListener(Function onError) {
    _socket.onError((error) {
      onError(error);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket.onDisconnect((data) {
      print("onDisconnect $data");
      onDisconnect(data);
    });
  }

  setOnChatMessageReceivedListener(Function onChatMessageReceived) {
    _socket.on(ON_MESSAGE_RECEIVED, (data) {
      print("Received $data");
      onChatMessageReceived(data);
    });
  }

  setOnMessageSentToChatUserListener(Function onMessageSentListener) {
    _socket.on(SUB_EVENT_MESSAGE_SENT, (data) {
      print("onMessageSentListener $data");
      onMessageSentListener(data);
    });
  }

  setOnUserConnectionStatusListener(Function onUserConnectionStatus) {
    _socket.on(IS_USER_CONNECTED_EVENT, (data) {
      onUserConnectionStatus(data);
    });
  }

  closeConnection() async {
    if (null != _socket) {
      print("Close Connection");
      try{
        await _manager.clearInstance(_socket);
      }catch(e){
        print(e.toString());
      }
    }
  }
}
