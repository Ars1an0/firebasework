import 'dart:io';

import 'package:firebaseintegrate/model/createcategory.dart';
import 'package:firebaseintegrate/widget/catogries_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  getCategories() {
    _service.categories.get().then((value) => {
          value.docs.forEach((element) {
            setState(() {
              _categories.add(element['catName']);
            });
          })
        });
  }

  // Widget _formField(String? label, TextInputType inputType,
  //     void Function(String)? onChanged) {
  //   return TextFormField(
  //     onChanged: onChanged,
  //     keyboardType: inputType,
  //     decoration: InputDecoration(
  //       label: Text(label!),
  //     ),
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return label;
  //       }
  //     },
  //   );
  // }

  Widget _categoryDropDown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: Text('Select Category'),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return 'Select Category';
      },
    );
  }

  // Widget _dropDownButton(){
  //   return FutureBuilder<QuerySnapshot>(
  //     future: _service.categories.get(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         return Text('Something went wrong');
  //       }
  //
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Text("Loading");
  //       }
  //
  //       return  DropdownButton(value: _selectedValue,
  //         hint: Text('Select Category'),
  //         items:snapshot.data!.docs.map((e){
  //           return DropdownMenuItem<String>(value: e['catName'],
  //       child: Text(e['catName']),);
  //       }).toList(),
  //       onChanged:(selectedCat){
  //         setState(() {
  //           _selectedValue = selectedCat;
  //         });
  //       } ,);
  //     },
  //   );
  // }
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController subtitlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  FirebaseService _service = FirebaseService();
  final List<String> _categories = [];
  String? selectedCategory;
  Object? _selectedValue;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  int uploadItem = 0;
  bool isUploading = false;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    label: Text('Enter Title'),
                  )
              ),
              TextFormField(
                controller: subtitlecontroller,
                decoration: InputDecoration(
                  label: Text('Enter SubTitle'),
                )
              ),
              TextFormField(
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                    label: Text('Enter Description'),
                  )
              ),

              ElevatedButton(
                  onPressed: () async {
                    selectImage();
                  },
                  child: Text("Select Images")),
              ElevatedButton(
                  onPressed: () async {
                    if (selectedFiles.length <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please Select Images'),
                      ));
                    } else {

                      uploadFunction(selectedFiles);
                    }
                  },
                  child: Text("Submit Post")),
              Wrap(
                children: selectedFiles
                    .map((e) => Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(e.path),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedFiles.remove(e);
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  size: 15,
                                  color: Colors.red,
                                )),
                          ],
                        ))
                    .toList(),
              ),
              Container(
                child: isUploading ? CircularProgressIndicator() : SizedBox(),
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       // getData();
              //       print("vsdvvvsvdssvdvsddvssdvdvssdvsdvsdvsdv");
              //     },
              //     child: Text("Check")),
              // _dropDownButton()
              _categoryDropDown()
            ],
          ),
        ),
      ),
    );
  }

  void uploadFunction(List<XFile> images) async {
    FirebaseService _service = FirebaseService();
    setState(() {
      isUploading = true;
    });
    List<String> arrImageUrls = [];
    for (int i = 0; i < images.length; i++) {
      var imageUrl = await uploadFile(images[i]);
      arrImageUrls.add(imageUrl.toString());
    }
    String title = titlecontroller.text;
    String subtitle = subtitlecontroller.text;
    String description = descriptioncontroller.text;
    String price = pricecontroller.text;
    FirebaseFirestore db = FirebaseFirestore.instance;
    await _service.categories.doc(selectedCategory).collection(selectedCategory!).add({
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "price": price,
      "img": arrImageUrls,
    });

    setState(() {
      selectedFiles.clear();
      isUploading = false;
    });
  }

  Future<String> uploadFile(XFile _image) async {
    Reference reference = _storageRef.ref().child(_image.name);
    File file = File(_image.path);
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    print('$downloadUrl');
    return downloadUrl;
  }

  Future<void> selectImage() async {
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        selectedFiles.addAll(imgs);
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

//   void getData()  async{
// // CollectionReference checking=FirebaseFirestore.instance.collection('collection');
// // var fireData=await checking.docs.
//   print('checking');
//    var value= await FirebaseFirestore.instance
//         .collection('collection')
//         .doc('gwZwjaBJSkpo3DTVEJKq').collection('toys').doc('jD79BqKlB0xuJAX9avb2').get();
//    print(value.data());
//     .then((QuerySnapshot querySnapshot) {
//       print(querySnapshot.docs);
//   querySnapshot.docs.forEach((doc) {
//     print(doc);
//   });
// });
// checking.map((event) => print(event));
//  for (var messages in checking )
// {
//   for (var message in messages.docs.toList()) {
//     print(message.data());
//   }
// }
}
