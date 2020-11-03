import 'package:chat_app/utility/utility.dart';

import 'models/user.dart';

class G{
  static User loggedInUser;
  static User toUser;
  static SocketUtils socketUtils;


  static List<User> dummyUser = [
    User(id: 1,name: 'Alu', email: 'aa@gmail.com', image: 'assets/images/1.jpg'),
    User(id: 2,name: 'Bob', email: 'bb@gmail.com', image: 'assets/images/2.jpg'),
    User(id: 3,name: 'Cix', email: 'cc@gmail.com', image: 'assets/images/3.jpg'),
  ];

  static List<User> getUserList(User user) {
    List<User> filteredUsers = dummyUser.where((u) => (!u.name.toLowerCase().contains(user.name.toLowerCase()))).toList();
    return filteredUsers;
  }

  static initSocket() {
    if (null == socketUtils) {
      socketUtils = SocketUtils();
    }
  }
}