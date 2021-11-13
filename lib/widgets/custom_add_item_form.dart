import 'dart:async';
import 'dart:io';
import 'package:apartment_project/models/address.dart';
import 'package:apartment_project/models/apartments.dart';
import 'package:apartment_project/models/local_api.dart';
import 'package:apartment_project/shares/const.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/shares/vadidator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'custom_form_field.dart';

final CollectionReference _mainCollection =
FirebaseFirestore.instance.collection('data');
final FirebaseAuth _auth = FirebaseAuth.instance;

class AddItemForm extends StatefulWidget {
  //define focus node
  final FocusNode rentalNameFocusNode;
  final FocusNode addressFocusNode;
  final FocusNode furnitureFocusNode;
  final FocusNode cityFocusNode;
  final FocusNode typeFocusNode;
  final FocusNode numBedFocusNode;
  final FocusNode numKitFocusNode;
  final FocusNode numBathFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode noteFocusNode;
  final FocusNode nameReporterFocusNode;

  const AddItemForm({
    required this.rentalNameFocusNode,
    required this.addressFocusNode,
    required this.cityFocusNode,
    required this.furnitureFocusNode,
    required this.typeFocusNode,
    required this.numBedFocusNode,
    required this.numKitFocusNode,
    required this.numBathFocusNode,
    required this.priceFocusNode,
    required this.noteFocusNode,
    required this.nameReporterFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  final _listFurniture = ['Furnished', 'Unfurnished', 'Part Furnished'];
  final _listType = ['Apartment', 'Penthouse', 'House', 'Villa'];

  bool _isProcessing = false;
  final TextEditingController _rentalNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _furnitureController;
  String? _typeController;
  String? _cityController;

  // TextEditingController _typeController = TextEditingController();
  final TextEditingController _numBedController = TextEditingController();
  final TextEditingController _numKitController = TextEditingController();
  final TextEditingController _numBathController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameReporterController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  //Picker Image Controller
  late File _image;
  late PickedFile _imageFile;
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _upload(ImageSource inputSource) async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: inputSource, maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage
            .ref(fileName)
            .putFile(imageFile, SettableMetadata(customMetadata: {}));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    setState(() {});
  }

  @override
  void initState() {
    LocalApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Form(
        key: _addItemFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0),
                  Text(
                    'Your name',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _nameReporterController,
                    focusNode: widget.nameReporterFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Name',
                    hint: 'Enter your name...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Rental Name',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _rentalNameController,
                    focusNode: widget.rentalNameFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Rental Name',
                    hint: 'Enter your rental name...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Address',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _addressController,
                    focusNode: widget.addressFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Address',
                    hint: 'Enter your address...',
                  ),
                  SizedBox(height: 8.0),
                  FutureBuilder<List<City>>(
                    future: LocalApi.getLocal(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseOrange,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("error");
                      } else {
                        var items = snapshot.data as List<City>;
                        return DropdownButtonFormField(
                            onTap: () => FocusScope.of(context).unfocus(),
                            hint: const Text(
                              "Select city",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            iconEnabledColor: Colors.lime,
                            focusNode: widget.cityFocusNode,
                            dropdownColor: Colors.blueAccent,
                            onChanged: (String? val) => setState(() {
                              _cityController = val;
                              print(_cityController);
                            }),
                            value: _cityController,
                            items: items
                                .map((type) => DropdownMenuItem(
                              value: type.name,
                              child: Text(type.name.toString()),
                            ))
                                .toList());
                      }
                    },
                  ),
                  // SizedBox(height: 24.0),
                  // FutureBuilder(
                  //   future: LocalApi.getLocal(),
                  //   builder: (context, snapshot){
                  //     if(!snapshot.hasData){
                  //       return Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: CircularProgressIndicator(
                  //           valueColor: AlwaysStoppedAnimation<Color>(
                  //             CustomColors.firebaseOrange,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     else if(snapshot.hasError){
                  //       return Text("error");
                  //     }
                  //     else{
                  //       var items = snapshot.data as List<City>;
                  //       return DropdownButtonFormField(
                  //           hint: const Text(
                  //             "Select district",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //           style: const TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //           iconEnabledColor: Colors.lime,
                  //           focusNode: widget.furnitureFocusNode,
                  //           dropdownColor: Colors.blueAccent,
                  //           onChanged: (val) => setState(() {
                  //             _district = val as int;
                  //           }),
                  //           value: _district,
                  //           items: items
                  //               .map((type) => DropdownMenuItem(
                  //             value: type.code,
                  //             child: Text(type.name.toString()),
                  //           ))
                  //               .toList());
                  //     }
                  //   },
                  // ),
                  //
                  // SizedBox(height: 24.0),
                  // FutureBuilder(
                  //   future: WardApi.getLocal(),
                  //   builder: (context, snapshot){
                  //     if(!snapshot.hasData){
                  //       return Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: CircularProgressIndicator(
                  //           valueColor: AlwaysStoppedAnimation<Color>(
                  //             CustomColors.firebaseOrange,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     else if(snapshot.hasError){
                  //       return Text("error");
                  //     }
                  //     else{
                  //       var items = snapshot.data as List<Ward>;
                  //       return DropdownButtonFormField(
                  //           hint: const Text(
                  //             "Select ward",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //           style: const TextStyle(
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //           iconEnabledColor: Colors.lime,
                  //           focusNode: widget.furnitureFocusNode,
                  //           dropdownColor: Colors.blueAccent,
                  //           onChanged: (val) => setState(() {
                  //             _furnitureController = val as String?;
                  //           }),
                  //           value: _furnitureController,
                  //           items: items
                  //               .map((type) => DropdownMenuItem(
                  //             value: type.name,
                  //             child: Text(type.name.toString()),
                  //           ))
                  //               .toList());
                  //     }
                  //   },
                  // ),

                  SizedBox(height: 24.0),
                  Text(
                    'Property Furniture',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  DropdownButtonFormField(
                      onTap: () => FocusScope.of(context).unfocus(),
                      hint: const Text(
                        "Select property furniture",
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                      icon: const Icon(Icons.home_filled),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      iconEnabledColor: Colors.lime,
                      focusNode: widget.furnitureFocusNode,
                      dropdownColor: Colors.blueAccent,
                      iconSize: 40,
                      onChanged: (val) => setState(() {
                        _furnitureController = val as String?;
                      }),
                      value: _furnitureController,
                      items: _listFurniture
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList()),
                  SizedBox(height: 24.0),
                  Text(
                    'Property Type',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 24.0),
                  DropdownButtonFormField(
                      onTap: () => FocusScope.of(context).unfocus(),
                      hint: const Text(
                        "Select property type",
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                      icon: const Icon(Icons.home_work),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      iconEnabledColor: Colors.lime,
                      focusNode: widget.typeFocusNode,
                      dropdownColor: Colors.blueAccent,
                      iconSize: 40,
                      onChanged: (val) => setState(() {
                        _typeController = val as String?;
                      }),
                      value: _typeController,
                      items: _listType
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList()),
                  SizedBox(height: 24.0),
                  Text(
                    'Bedroom',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _numBedController,
                    focusNode: widget.numBedFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateNumber(
                      value: value,
                    ),
                    label: 'Number',
                    hint: 'Enter a number of bedroom...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Kitten',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _numKitController,
                    focusNode: widget.numKitFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateNumber(
                      value: value,
                    ),
                    label: 'Number',
                    hint: 'Enter a number of kitten...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Bathroom',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _numBathController,
                    focusNode: widget.numBathFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateNumber(
                      value: value,
                    ),
                    label: 'Number',
                    hint: 'Enter a number of bathroom...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Monthly Price',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _priceController,
                    focusNode: widget.priceFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validatePrice(
                      value: value,
                    ),
                    label: 'Number',
                    hint: 'Enter the monthly price...',
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Note',
                    style: TextStyle(
                      color: CustomColors.firebaseWhite,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 10,
                    isLabelEnabled: false,
                    controller: _noteController,
                    focusNode: widget.noteFocusNode,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateOptional(
                      value: value,
                    ),
                    label: 'Note',
                    hint: 'Enter a note(optional)...',
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () => _upload(ImageSource.camera),
                            icon: Icon(Icons.camera),
                            label: Text('Camera')),
                        ElevatedButton.icon(
                            onPressed: () => _upload(ImageSource.gallery),
                            icon: Icon(Icons.library_add),
                            label: Text('Gallery')),
                        ElevatedButton.icon(
                            onPressed: () => _delete(_image.path),
                            icon: Icon(Icons.delete),
                            label: Text('Delete')),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  _isProcessing
                      ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    ),
                  )
                      : Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomColors.firebaseOrange,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (_context) {
                              return AlertDialog(
                                title: Text("Confirm your information",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                content: Text(
                                  'Name Reporter: ' +
                                      _nameReporterController.text +
                                      '\n\n' +
                                      'Rental name: ' +
                                      _rentalNameController.text +
                                      '\n\n' +
                                      'Address: ' +
                                      _addressController.text +
                                      '\n\n' +
                                      'City: ' +
                                      _cityController.toString() +
                                      '\n\n' +
                                      'Furniture: ' +
                                      _furnitureController.toString() +
                                      '\n\n' +
                                      'Type: ' +
                                      _typeController.toString() +
                                      '\n\n' +
                                      'Number of Bedroom: ' +
                                      _numBedController.text +
                                      '\n\n' +
                                      'Number of Kitten: ' +
                                      _numKitController.text +
                                      '\n\n' +
                                      'Number of Bathroom: ' +
                                      _numBathController.text +
                                      '\n\n' +
                                      'Price: ' +
                                      _priceController.text +
                                      '\n\n' +
                                      'Note: ' +
                                      _noteController.text +
                                      '\n\n'
                                          'Time: ' +
                                      formatDate +
                                      '\n\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        setState(() async {
                                          widget.rentalNameFocusNode
                                              .unfocus();
                                          widget.noteFocusNode.unfocus();
                                          widget.furnitureFocusNode
                                              .unfocus();
                                          widget.typeFocusNode.unfocus();
                                          widget.cityFocusNode.unfocus();

                                          if (_addItemFormKey
                                              .currentState!
                                              .validate()) {
                                            setState(() {
                                              ScaffoldMessenger.of(
                                                  _context)
                                                  .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Create succesfully at $formatDate')));
                                              Navigator.of(_context)
                                                  .pop();
                                              _isProcessing = true;
                                            });
                                            await ApartmentData.addApartment(
                                                rentalName:
                                                _rentalNameController
                                                    .text,
                                                address:
                                                _addressController
                                                    .text,
                                                city: _cityController
                                                    .toString(),
                                                furniture:
                                                _furnitureController
                                                    .toString(),
                                                type: _typeController
                                                    .toString(),
                                                numBath: int.parse(
                                                    _numBathController
                                                        .text),
                                                numBed: int.parse(
                                                    _numBedController
                                                        .text),
                                                numKit: int.parse(
                                                    _numKitController
                                                        .text),
                                                price: int.parse(
                                                    _priceController.text),
                                                note: _noteController.text,
                                                nameOwn: _nameReporterController.text,
                                                createdTime: formatDate);
                                            Navigator.of(_context).pop();
                                          }
                                          ScaffoldMessenger.of(_context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error: Invalid enter fields. Please check the validator on the fields!!')));
                                          Navigator.of(_context).pop();
                                        });
                                        Navigator.of(_context).pop();
                                      },
                                      child: Text(
                                        "Yes",
                                        style: dialogTextStyle,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isProcessing = false;
                                          Navigator.of(_context).pop();
                                        });
                                      },
                                      child: Text(
                                        "No",
                                        style: dialogTextStyle,
                                      )),
                                ],
                                elevation: 24.0,
                                backgroundColor:
                                CustomColors.firebaseWhite,
                              );
                            });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'ADD ITEM',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.firebaseBlack,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('data')
        .doc('rentalZ')
        .collection(_auth.currentUser!.uid)
        .where('nameApm', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
