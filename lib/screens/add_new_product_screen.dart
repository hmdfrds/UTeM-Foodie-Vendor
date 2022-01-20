import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:utem_foodir_vendor/providers/product_provider.dart';
import 'package:utem_foodir_vendor/widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);
  static const String id = 'addnewproduct-screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool _visibility = false;
  bool _track = false;

  final List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added',
  ];
  String? dropdownValue;

  final _productNameTextController = TextEditingController();
  final _aboutProductTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _quantityTextController = TextEditingController();
  final _lowStockQuantityTextController = TextEditingController();

  final _categoryTextController = TextEditingController();
  final _subCategoryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_image != null) {
                                EasyLoading.show(status: 'Saving...');
                                _provider
                                    .uploadProductImage(_image!,
                                        _productNameTextController.text)
                                    .then((productImage) {
                                  if (productImage != null) {
                                    EasyLoading.dismiss();
                                    _provider
                                        .saveProductDataToDb(
                                            _productNameTextController.text,
                                            _aboutProductTextController.text,
                                            _priceTextController.text,
                                            dropdownValue,
                                            _quantityTextController.text,
                                            _lowStockQuantityTextController
                                                .text,
                                            context)!
                                        .then((value) {
                                      setState(() {
                                        dropdownValue = null;
                                        _formKey.currentState!.reset();
                                        _productNameTextController.clear();
                                        _aboutProductTextController.clear();
                                        _priceTextController.clear();

                                        _quantityTextController.clear();
                                        _lowStockQuantityTextController.clear();
                                        _visibility = false;
                                        _image = null;
                                        _track = false;
                                      });
                                    });
                                  } else {
                                    _provider.alertDialog(
                                        context: context,
                                        title: 'IMAGE UPLOAD',
                                        content:
                                            'Failed to upload poduct image');
                                  }
                                });
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    content: 'ProductImage not selected',
                                    title: 'PRODUCT IMAGE');
                              }
                            }
                          },
                          color: Colors.orange,
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TabBarView(
                    children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _productNameTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Product Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  maxLength: 500,
                                  controller: _aboutProductTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter About Product';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((value) {
                                        setState(() {
                                          _image = value;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select Image')
                                              : Image.file(_image!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _priceTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Product Price';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
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
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
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
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey))),
                                          ),
                                        ),
                                      ),
                                      IconButton(
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
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
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
                                              controller:
                                                  _subCategoryTextController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Select Sub Category';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'not selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey))),
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
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory!;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: _track,
                              onChanged: (selected) {
                                setState(() {
                                  _track = !_track;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                              title: Text('Track Inventory'),
                              subtitle: Text(
                                'Switch ON to track Inventory',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _quantityTextController,
                                          validator: (value) {
                                            if (_track) {
                                              if (value!.isEmpty) {
                                                return 'Enter Quantity ';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Inventory Quantity*',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                        ),
                                        TextFormField(
                                          controller:
                                              _lowStockQuantityTextController,
                                          validator: (value) {
                                            if (_track) {
                                              if (value!.isEmpty) {
                                                return 'Enter Low Stock Quantity ';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Inventory Low Stock Quantity',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
