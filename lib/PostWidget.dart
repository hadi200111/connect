import 'package:flutter/material.dart';
import 'package:connect/Posts.dart';

class PostWidget extends StatefulWidget {
  final Posts post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void _incrementCounter() {
    setState(() {
      widget.post.likeCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.post.userImageUrl),
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //Image.network(widget.post.postImageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              readOnly: true,
              controller: TextEditingController(text: widget.post.caption),
            ),
          ),
          SizedBox(
            width: 100,
            height: 300,
            child: Image.network(
              widget.post.postImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Text('${widget.post.likeCounter}'),
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  _incrementCounter();
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
