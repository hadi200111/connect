import 'package:connect/CalendarPage.dart';
import 'package:connect/Library.dart';
import 'package:connect/LibraryPage/LibraryPage.dart';
import 'package:connect/LibraryPage/PrevoisMaterial.dart';
import 'package:connect/PostWidget.dart';
import 'package:connect/WelcomeLogIn/WelcomePage.dart';
import 'package:connect/main.dart';
import 'package:connect/masseging/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:connect/Posts.dart';

List<Posts> posts = [
  Posts(
    userName: 'DANAR',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  /*Posts(
    userName: 'Dana',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Hadi',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Dana',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Hadi',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Dana',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Hadi',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ),
  Posts(
    userName: 'Dana',
    userImageUrl: 'https://picsum.photos/250?image=9',
    postImageUrl: 'https://picsum.photos/250?image=9',
    caption: 'ضيعت شنتتي في المجمع, حدا شافها؟',
    likeCounter: 0,
  ), */
];

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  Main_PageState createState() => Main_PageState();
}

class Main_PageState extends State<Main_Page> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: const Text('Library'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: const Text('PrevoisMaterial'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Library()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: const Text('masseges'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatId: '1', // replace with actual chatId
                    currentUserId: Globals.userID, // replace with actual userId
                  ),
                ),
              );
            },
          ),
        ],
      )),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostWidget(
                post: posts[index],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined), label: 'Calender'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Messages'),
          NavigationDestination(
              icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
