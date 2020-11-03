import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GQL{
  static final HttpLink httpLink = HttpLink(
      uri: 'https://gql-chat-v2.herokuapp.com/graphql'
  );
  GraphQLClient graphQLClient = GraphQLClient(link: httpLink, cache: InMemoryCache());

  static String _token;

  static final AuthLink authLink = AuthLink(getToken: () => _token);

  static final WebSocketLink webSocketLink = WebSocketLink(
      url: 'wss://gql-chat-v2.herokuapp.com/graphql',
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(days: 1),
      )
  );

  static final Link link = authLink.concat(httpLink).concat(webSocketLink);

  static String token;
  static ValueNotifier<GraphQLClient> initClient(String token){
    _token = token;
    ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
            cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
            link: link
        )
    );
    return client;
  }
}