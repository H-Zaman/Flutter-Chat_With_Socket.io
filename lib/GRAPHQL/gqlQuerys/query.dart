class GQuery{
  static String loginUser = '''
query(\$email: String!, \$password: String!){
  userLogin(
    email: \$email,
    password: \$password
  ){
    token
  }
}
''';
}