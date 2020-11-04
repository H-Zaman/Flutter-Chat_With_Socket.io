import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final bool isMine;
  final String message;
  final String time;
  const ChatBubble({
    this.message,
    this.time,
    this.isMine
});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Card(
        color: isMine ? Colors.grey[300] : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: isMine ? Radius.circular(20) : Radius.zero,
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: isMine ? Radius.zero : Radius.circular(20)
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * .2,
              maxWidth: MediaQuery.of(context).size.width * .8
            ),
            child: ListTile(
              title: Text(message),
              subtitle: Text(time),
            ),
          ),
        ),
      ),
    );
  }
}
