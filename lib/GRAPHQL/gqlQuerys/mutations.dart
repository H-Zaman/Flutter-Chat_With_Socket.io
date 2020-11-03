class GMutation{
  static String registerUser = '''
mutation(\$email: String!, \$password: String!) {
  addUser(email: \$email, password: \$password) {
    _id
  }
}
''';
}