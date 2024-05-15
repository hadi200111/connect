import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Library.dart';
import 'package:connect/LibraryPage/AddCategoryDialog.dart';
import 'package:connect/LibraryPage/BooksPage.dart';
import 'package:connect/LibraryPage/CategoryTile.dart';
import 'package:connect/LibraryPage/SearchPage.dart';
import 'package:flutter/material.dart';

String myid = "";
Map<String, Map<String, List<String>>> _categories = {};

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchBarApp()),
              );
            },
          ),
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder(
        future: getCata(), // Get the list of majors
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> majors = snapshot.data as List<String>;
            return FutureBuilder(
              future: getCourses(majors), // Get courses for each major
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, Map<String, List<String>>>> courses =
                      snapshot.data
                          as List<Map<String, Map<String, List<String>>>>;
                  // Update _categories with the retrieved courses
                  _categories.clear();
                  for (var course in courses) {
                    _categories.addAll(course);
                  }
                  return ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = _categories.keys.elementAt(index);
                      return CategoryExpansionTile(
                        category: category,
                        subCategories: _categories[category]!,
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          onCategoryAdded: (category) {
            if (_categories.containsKey(category)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Category Already Exists'),
                    content: Text('The category "$category" already exists.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              setState(() {
                _categories[category] = {};
              });
            }
          },
        );
      },
    );
  }
}

Future<List<String>> getCata() async {
  List<String> majors = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Categories').get();
  querySnapshot.docs.forEach((doc) {
    myid = doc.id;
    List<dynamic> scheduleFromFirestore = doc.get("majors");
    majors.addAll(scheduleFromFirestore.map((major) => major.toString()));
  });

  return majors;
}

Future<List<Map<String, Map<String, List<String>>>>> getCourses(
    List<String> majors) async {
  List<Map<String, Map<String, List<String>>>> categories = [];

  // Fetch categories from the 'Categories' collection
  QuerySnapshot categoriesSnapshot =
      await FirebaseFirestore.instance.collection('Categories').get();

  for (QueryDocumentSnapshot categoryDoc in categoriesSnapshot.docs) {
    String category = categoryDoc.id;
    Map<String, List<String>> subCategories = {};

    // Fetch subcategories from the 'mymajors' collection under each category
    QuerySnapshot subCategoriesSnapshot =
        await categoryDoc.reference.collection('mymajors').get();

    for (QueryDocumentSnapshot subCategoryDoc in subCategoriesSnapshot.docs) {
      String subCategory = subCategoryDoc.id;
      List<String> courses = [];

      // Fetch courses from the subcollection under each subcategory
      QuerySnapshot coursesSnapshot =
          await subCategoryDoc.reference.collection('courses').get();

      for (QueryDocumentSnapshot courseDoc in coursesSnapshot.docs) {
        courses.add(courseDoc.id);
      }

      subCategories[subCategory] = courses;
    }

    categories.add({category: subCategories});
  }

  return categories;
}

class CategoryExpansionTile extends StatefulWidget {
  final String category;
  final Map<String, List<String>> subCategories;

  const CategoryExpansionTile({
    required this.category,
    required this.subCategories,
  });

  @override
  _CategoryExpansionTileState createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.category),
      children: widget.subCategories.entries
          .map((entry) => SubCategoryExpansionTile(
                subCategory: entry.key,
                courses: entry.value,
              ))
          .toList(),
    );
  }
}

class SubCategoryExpansionTile extends StatefulWidget {
  final String subCategory;
  final List<String> courses;

  const SubCategoryExpansionTile({
    required this.subCategory,
    required this.courses,
  });

  @override
  _SubCategoryExpansionTileState createState() =>
      _SubCategoryExpansionTileState();
}

class _SubCategoryExpansionTileState extends State<SubCategoryExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.subCategory),
      children: widget.courses
          .map((course) => GestureDetector(
                onTap: () {
                  // Navigate to the book page when tapping on a course
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Library(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(course),
                ),
              ))
          .toList(),
    );
  }
}
