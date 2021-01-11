
import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  static newUserSubs()  async{

    GraphQLClient client = GQL.getSocketClient();

    Operation operation = Operation(
        documentNode: gql(newUsers),
        operationName: 'newUsers'
    );

    return client.subscribe(operation);
  }


}

