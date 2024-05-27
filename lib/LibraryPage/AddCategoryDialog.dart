import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/LibraryPage/LibraryPage.dart';
import 'package:connect/main.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatelessWidget {
  final Function(String) onCategoryAdded;

  AddCategoryDialog({
    required this.onCategoryAdded,
  });

  @override
  Widget build(BuildContext context) {
    String newCategoryName = '';
    return AlertDialog(
      title: Text(
        'Add New Course',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        onChanged: (value) {
          newCategoryName = value;
        },
        decoration: InputDecoration(
          labelText: 'Course Name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onCategoryAdded(newCategoryName);
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
