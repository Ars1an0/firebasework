import 'package:firebaseintegrate/model/category_model.dart';
import 'package:firebaseintegrate/ui/detailview.dart';
import 'package:firebaseintegrate/ui/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  String? _selectedCategory;
  // fetchDataFromFirebase() {
  //   Stream<QuerySnapshot> list =
  //       FirebaseFirestore.instance.collection('post').snapshots();
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()));

      }, icon: Icon(Icons.search))],),
      body: FirestoreListView<Category>(
        query: categoryCollection,
        itemBuilder: (context, snapshot) {
          Category category = snapshot.data();
          return ActionChip(
            backgroundColor: _selectedCategory ==category.catName ? Colors.blue : Colors.grey.shade300 ,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              label: Text(category.catName!,), onPressed: (){
setState(() {
  _selectedCategory = category.catName;
});
          });
        },
      ),
      // fetchDataFromFirebase() == null
      //     ? CircularProgressIndicator()
      //     : StreamBuilder<QuerySnapshot>(
      //         stream: FirebaseFirestore.instance
      //             .collection('post')
      //             .where('img',)
      //             .snapshots(),
      //         // initialData: null,
      //         builder: (BuildContext context,
      //             AsyncSnapshot<QuerySnapshot> snapshot) {
      //           if (snapshot.hasError || snapshot.data == null) {
      //             return Text('Something went wrong');
      //           }
      //
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Text("Loading");
      //           }
      //
      //           return ListView(
      //             children:
      //             snapshot.data!.docs.map((DocumentSnapshot document) {
      //               Map<String, dynamic> data =
      //                   document.data()! as Map<String, dynamic>;
      //               return InkWell(
      //                 onTap: (){Navigator.push(
      //                   context,
      //                   MaterialPageRoute(builder: (context) => ViewScreen(data:data)),
      //                 );},
      //                 child: ListTile(
      //                   leading: CircleAvatar(
      //                       radius: 20,
      //                       backgroundImage: NetworkImage(data['img'][1])),
      //                   title: Text(data['title']),
      //                   subtitle: Text(data['subtitle']),
      //                 ),
      //               );
      //             }).toList(),
      //           );
      //         },
      //       ),
    );
  }
}
