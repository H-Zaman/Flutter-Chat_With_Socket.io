class GMutation{
  static String registerUser = '''
mutation(\$email: String!, \$password: String!) {
  addUser(email: \$email, password: \$password) {
    _id
  }
}
''';

  static String sendMessage = '''
mutation(\$message:String!, \$sender:ID!, \$receiver:ID!){
  addMessage(
    messageInput:{
      message: \$message,
      sender: \$sender,
      receiver: \$receiver
    }
  ){
    _id
    message
    sender
    receiver
  }
}
''';

}