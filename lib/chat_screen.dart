import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> _messages = [];

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages.add(
        Message(text: "Hi, I am FinGenie. How may I assist you?", isMe: false));
  }

  void onSendMessage() async {
    Message message = Message(text: _textEditingController.text, isMe: true);

    if (message.text.isEmpty) return;

    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });

    //getResponse(message.text);
    String response = await getResponse(message.text);
    Message bot = Message(text: response, isMe: false);

    setState(() {
      _messages.insert(0, bot);
    });
  }

  Future<String> getResponse(String message) async {
    String apiUrl = 'http://127.0.0.1:5000/api?input=$message';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['response'];
    } else {
      throw Exception('Failed to load response');
    }
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.isMe ? 'You' : 'Bot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: message.isMe
                    ? Color.fromARGB(255, 228, 157, 241)
                    : Color.fromARGB(255, 246, 171, 196),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                message.text,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChatBot'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMessage(_messages[index]);
                  }),
            ),
            const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: 'Type a Message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onSendMessage,
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
