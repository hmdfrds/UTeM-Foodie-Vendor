import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:utem_foodir_vendor/providers/product_provider.dart';
import 'package:utem_foodir_vendor/services/firebase_services.dart';
import 'package:utem_foodir_vendor/widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  const EditViewProduct({required this.productId, Key? key}) : super(key: key);

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  var _productNameText = TextEditingController();

  var _priceText = TextEditingController();

  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  DocumentSnapshot? doc;
  double discount = 0.0;
  String? image;
  File? _image;
  bool _visibility = false;
  String? categoryImage;
  bool? _editing = false;

  final List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added',
  ];
  String? dropdownValue;
  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.product
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;

          _productNameText.text = document['productName'];

          _priceText.text = document['price'].toString();

          image = document['productImage'];
          _descriptionText.text = document['description'];
          _categoryTextController.text = document['category']['mainCategory'];
          _subCategoryTextController.text = document['category']['subCategory'];
          dropdownValue = document['collection'];
          _stockTextController.text = document['stockQuantity'].toString();
          _lowStockTextController.text =
              document['stockLowQuantity'].toString();
          categoryImage = document['category']['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  _editing = false;
                });
              },
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Saving...');
                  }
                  if (_image != null) {
                    _provider
                        .uploadProductImage(_image, _productNameText.text)
                        .then((url) {
                      if (url != null) {
                        EasyLoading.dismiss();
                        _provider.updateProduct(
                            _productNameText.text,
                            _descriptionText.text,
                            _priceText.text,
                            dropdownValue,
                            _stockTextController.text,
                            _lowStockTextController.text,
                            context,
                            widget.productId,
                            url,
                            _categoryTextController.text,
                            _subCategoryTextController.text,
                            categoryImage);
                      }
                    });
                  } else {
                    _provider.updateProduct(
                        _productNameText.text,
                        _descriptionText.text,
                        _priceText.text,
                        dropdownValue,
                        _stockTextController.text,
                        _lowStockTextController.text,
                        context,
                        widget.productId,
                        image,
                        _categoryTextController.text,
                        _subCategoryTextController.text,
                        categoryImage);
                    EasyLoading.dismiss();
                  }
                  _provider.resetProvider();
                },
                child: Container(
                  child: Container(
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none),
                              controller: _productNameText,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      prefixText: 'RM',
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.red),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    ' ${discount.toStringAsFixed(0)}% OFF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all Taxes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                _image = image;
                                print(image!.path);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null
                                  ? Image.file(_image!)
                                  : Image.network(image!),
                            ),
                          ),
                          Text(
                            'About this product',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Select Category ';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'not selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey))),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editing! ? false : true,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CategoryList();
                                          }).whenComplete(() {
                                        setState(() {
                                          _categoryTextController.text =
                                              _provider.selectedCategory!;
                                          _visibility = true;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visibility,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Sub Category',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        controller: _subCategoryTextController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Select Sub Category';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'not selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SubCategoryList();
                                          }).whenComplete(() {
                                        setState(() {
                                          _subCategoryTextController.text =
                                              _provider.selectedSubCategory!;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValue = value;
                                    });
                                  },
                                  items: _collections
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock :'),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _stockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock :'),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none),
                                  controller: _lowStockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
