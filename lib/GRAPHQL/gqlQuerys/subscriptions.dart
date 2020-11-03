class GSubscription{
  static String onlineUsers = '''
subscription onlineUsers(\$userId: String!){
  messageAdded(reciverId: \$userId){
    _id
    message
    sender
    receiver
  }
}  
''';

  static String newUsers = '''
subscription newUsers{
  userAdded{
    email
  }
}  
''';
}