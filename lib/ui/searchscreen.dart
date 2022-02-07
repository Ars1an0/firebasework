import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/ui/addcategory.dart';
import 'package:firebaseintegrate/ui/adminpanel.dart';
import 'package:firebaseintegrate/ui/detailview.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPanel()));}, icon: Icon(Icons.person)),
          IconButton(onPressed: (){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCategory()));}, icon: Icon(Icons.category)),
        ],
        title: Card(
          child: TextField(
            onChanged: (val) {
              setState(() {
                name = val.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search Text Here',
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('post')
                .where('searchIndex', arrayContains: name)
                .snapshots()
            : FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
            children:
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return InkWell(
                onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewScreen(data:data)),
                );},
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data['img'][0])),
                  title: Text(data['title']),
                  subtitle: Text(data['subtitle']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

