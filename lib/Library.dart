import 'dart:typed_data';

import 'package:connect/Addappointment.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class Book {
  final String title;
  final String author;
  final double rating;
  final String pdfUrl;

  Book(
      {required this.title,
      required this.author,
      required this.rating,
      required this.pdfUrl});
}

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<Library> {
  List<Book> books = [
    Book(
        title: "Book 1",
        author: "Author 1",
        rating: 4.5,
        pdfUrl: "https://example.com/book1.pdf"),
    Book(
        title: "Book 2",
        author: "Author 2",
        rating: 3.8,
        pdfUrl: "https://example.com/book2.pdf"),
    // Add more books as needed
  ];

  Uint8List? _pdfBytes;

  Future<void> _uploadFileToFirebaseStorage(
      Uint8List bytes, String course, String name) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(course)
          .child(name);

      await ref.putData(bytes);

      String downloadURL = await ref.getDownloadURL();

      // Save downloadURL to Firestore
      await FirebaseFirestore.instance
          .collection('pdfs')
          .add({'url': downloadURL});
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Book',
            onPressed: () {
              // Implement navigation to add appointment screen
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                ),
                onPressed: () async {
                  // Open the file picker
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  if (result != null) {
                    // File picked
                    setState(() {
                      _pdfBytes = result.files.single.bytes;
                    });
                    // Upload the file to Firebase Storage
                    await _uploadFileToFirebaseStorage(
                        _pdfBytes!, "COMP333", "12345-Chapter 1.pdf");
                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text('import'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookItem(book: book);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;

  const BookItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200], // Set background color for the book item
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Author: ${book.author}",
                style: TextStyle(
                    color: Colors.black87)), // Set text color for author
            Text("Rating: ${book.rating}",
                style: TextStyle(
                    color: Colors.black87)), // Set text color for rating
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.download,
              color: Colors.blue), // Set icon color for download button
          onPressed: () {
            // Add download functionality here
            // You can use packages like 'url_launcher' to open the PDF link in a browser
            // Or use a PDF viewer package to view the PDF in the app
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Library(),
  ));
}
