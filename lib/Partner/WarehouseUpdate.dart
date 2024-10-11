import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Partner/HelpPage.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/Partner/MapScreen.dart';
import 'package:warehouse/Partner/Provider/LocationProvider.dart';
import 'package:warehouse/Partner/WarehouseImageScreen.dart';
import 'package:warehouse/Partner/WarehouseMediaUpdate.dart';
import 'package:warehouse/Partner/models/warehousesModel.dart';
import 'package:http/http.dart' as http;

class Warehouseupdate extends StatefulWidget {
  final Warehouse warehouse;
  const Warehouseupdate({super.key,required this.warehouse});
  @override
  State<Warehouseupdate> createState() => _WarehouseupdateState();
}
class _WarehouseupdateState extends State<Warehouseupdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _carpetAreaController=TextEditingController();
  TextEditingController _totalCarpetArea=TextEditingController();
  TextEditingController _rentPerSqFt=TextEditingController();
  TextEditingController _maintenanceCost=TextEditingController();
  TextEditingController _expectedSecurityDeposit=TextEditingController();
  TextEditingController _tokenAdvance=TextEditingController();
  TextEditingController _expectedLockInPeriod=TextEditingController();
  TextEditingController _warehouseName=TextEditingController();
  final int _maxLength = 29;
  bool _isChecked = false;
  int _number = 0;
  late String _address = "Fetching address...";  // Set a default value


  String? _selectedWarehouseType;
  String? _constructionType;
  String? selectedLocation;
  bool isLoading=false;
  late LatLng finalAddress = const LatLng(0.0, 0.0); // Set default value

  LatLng? _latLng;

  void _increase() {
    setState(() {
      _number++;
    });
  }

  void _decrease() {
    if (_number > 0) {
      setState(() {
        _number--;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
    _selectedWarehouseType=widget.warehouse.whouseType1;
    _constructionType=widget.warehouse.whouseType2;
    _number=widget.warehouse.whouseFloor;
    _isChecked=widget.warehouse.isavilable;
    _carpetAreaController.text=widget.warehouse.whouseCarpetArea.toString();
    _totalCarpetArea.text=widget.warehouse.carpetArea.toString();
    _rentPerSqFt.text=widget.warehouse.whouseRent.toString();
    _maintenanceCost.text=widget.warehouse.whouseMaintenance.toString();
    _expectedSecurityDeposit.text=widget.warehouse.whouseExpected.toString();
    _tokenAdvance.text=widget.warehouse.whouseToken.toString();
    _expectedLockInPeriod.text=widget.warehouse.whouseLockin.toString();
    _warehouseName.text=widget.warehouse.whouseName.toString();

  }



  Future<void> _getAddressFromLatLng() async {
    try {
      // Extract latitude and longitude
      RegExp regExp = RegExp(r'LatLng\(([^,]+), ([^,]+)\)');
      Match? match = regExp.firstMatch(widget.warehouse.whouseAddress);

      if (match != null && match.groupCount == 2) {
        double latitude = double.parse(match.group(1)!.trim());
        double longitude = double.parse(match.group(2)!.trim());

        // Set the LatLng
        _latLng = LatLng(latitude, longitude);


        // Get the address from the latitude and longitude
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        if (placemarks.isNotEmpty) {
          setState(() {
            _address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
           print(_address);
          });
        }
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }


  final List<String> _construction = [
    'Shed',
    'Cold Storage',
    'RCC',
    'PEB',
    'Others',

  ];

  final List<String> warehouseTypes = [
    'Small Warehouse',
    'Warehouse',
    'Building',
    'Bonded',
    'Cold Storage',
    'Dark Store',
    'Commercial Building',
    'Independent House',
    'Multi Store Building',
    'Open Space',
    'RCC Structure',
    'Shed',
    'Industrial Shed',
    'Climate Controlled',
    'Government or Public Warehouse',
    'Others',
  ];

  Future<void> _submitForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone")!;
    if (phone.startsWith("+91")) {
      phone = phone.replaceFirst("+91", "");
    }

    print("Mobile>>>"+phone.toString());
   // print(">>>>>>>>>>>>>>"+finalAddress.toString());

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // If finalAddress is still the default value, check if we can fall back on existing location data
      LatLng addressToSubmit = finalAddress != const LatLng(0.0, 0.0)
          ? finalAddress
          : _latLng ?? const LatLng(0.0, 0.0); // Fallback to _latLng if available

      // Gather all data
      String warehousetype = _selectedWarehouseType!;
      String constructionType = _constructionType!;
      double carpetArea = double.tryParse(_carpetAreaController.text) ?? 0.0;
      double totalcarpetArea = double.tryParse(_totalCarpetArea.text) ?? 0.0;
      double rentPerSqFt = double.tryParse(_rentPerSqFt.text) ?? 0.0;
      String maintenanceCostValue = _maintenanceCost.text.toString() ?? "0.0";
      String expectedSecurityDepositValue = _expectedSecurityDeposit.text.toString() ?? "0.0";
      String tokenAdvanceValue = _tokenAdvance.text.toString() ?? "0.0";
      String expectedLockInPeriodValue = _expectedLockInPeriod.text.toString() ?? "0.0";
      String warehouseNameValue = _warehouseName.text;

      Map<String, dynamic> data = {
        'whouse_type1': warehousetype,
        'whouse_type2': constructionType,
        'whouse_address':  addressToSubmit.toString(),
        'whouse_carperarea': carpetArea,
        'warehouse_carpetarea': totalcarpetArea,
        'whouse_rent': rentPerSqFt,
        'whouse_maintenance': maintenanceCostValue,
        'whouse_expected': expectedSecurityDepositValue,
        'whouse_token': tokenAdvanceValue,
        'whouse_lockin': expectedLockInPeriodValue,
        'whouse_name': warehouseNameValue,
        'isavilable': _isChecked,
        'whouse_floor': _number,
        'Id': widget.warehouse.id,
        'mobile':phone
      };

      print("Alldatass " + data.toString());

      try {
        final response = await http.patch(
          Uri.parse('http://xpacesphere.com/api/Wherehousedt/Updwarehouse'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        print("ApiResponseBody" + response.body.toString());
        print("ApiResponseCode" + response.statusCode.toString());

       // Decode the JSON response body
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Check if the "status" is 201 for success
          if (response.statusCode == 200 && responseData['status'] == 200) {
            print('Data Updated successfully');
            // Navigate to WarehouseImageScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  WarehouseMediaUpdate(warehouse:widget.warehouse)),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Uploaded successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _clearFormFields();
            setState(() {
              isLoading = false;
            });


          } else {
            // Handle failure
            print('Failed to submit data: ${response.statusCode}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload data. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        } catch (e) {
          print('Error parsing response JSON: $e');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Invalid response from the server.'),
          //     backgroundColor: Colors.red,
          //   ),
          // );
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to clear form fields
  void _clearFormFields() {
    _carpetAreaController.clear();
    _totalCarpetArea.clear();
    _rentPerSqFt.clear();
    _maintenanceCost.clear();
    _expectedSecurityDeposit.clear();
    _tokenAdvance.clear();
    _expectedLockInPeriod.clear();
    _warehouseName.clear();
    finalAddress=const LatLng(0.0, 0.0);

    // Reset other form fields
    _isChecked = false; // Reset checkbox
    _number = 1; // Reset number of floors or any other number field
    _selectedWarehouseType = ''; // Reset dropdown
    _constructionType = ''; // Reset dropdown

    // Optionally call setState() to refresh the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      height: screenHeight * 0.18,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.025,
                          left: screenWidth * 0.025,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(child: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Text("Update Warehouse",style: TextStyle(color: Colors.white,fontSize: 14),)
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),

                                const SizedBox(width: 5),
                                InkWell(
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.question_mark,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpPage()));
                                  },
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: screenHeight*0.08,left: 20),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Update your warehouse information!",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.005),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Container(
                                      margin: EdgeInsets.only(top: screenHeight * 0.02,left: screenHeight * 0.035),
                                      child: const Text("Update your Warehouse address",style: TextStyle(color: Colors.grey),)),
                                  InkWell(
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        margin: EdgeInsets.only(top: screenHeight * 0.01),
                                        child: DottedBorder(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset('assets/images/Worldwidelocation.png', width: 40, height: 40), // Replace with your image asset
                                               // const SizedBox(height: 20),
                                                Text(_address.isNotEmpty ? _address : 'Address not available', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                               // const SizedBox(height: 10),
                                                Container(
                                                  height: 100, // Height of the map container
                                                  width: double.infinity, // Width of the map container
                                                  child: _latLng != null // Check if LatLng is available
                                                      ? GoogleMap(
                                                    initialCameraPosition: CameraPosition(
                                                      target: _latLng!,
                                                      zoom: 18.0, // Zoom level
                                                    ),
                                                    markers: {
                                                      Marker(
                                                        markerId: MarkerId('location'),
                                                        position: _latLng!,
                                                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Set marker color to red
                                                      ),
                                                    },
                                                  )
                                                      : Center(child: CircularProgressIndicator()), // Show loading indicator until LatLng is available
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      // Navigate to the LocationSelectionScreen
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LocationSelectionScreen()),
                                      );

                                      // Check if the result is not null and is of type LocationData
                                      if (result != null && result is LocationData) {
                                        setState(() {
                                          finalAddress=result.latLng;
                                        });
                                        // Extract latitude, longitude, and address from the result
                                        LatLng selectedLocation = result.latLng;
                                        String selectedAddress = result.address;


                                        // Update your provider with the new location
                                        final locationProvider = Provider.of<LocationProvider>(context, listen: false);
                                        locationProvider.updateLocation(selectedAddress, selectedLocation);

                                        // Update the display text with the selected location and address
                                        setState(() {
                                          //displayText = 'Selected Location: (${selectedLocation.latitude.toStringAsFixed(4)}, ${selectedLocation.longitude.toStringAsFixed(4)})';
                                          // If you want to show the address as well, you can do it here
                                         // displayText += '\nAddress: $selectedAddress';
                                        });

                                        // Optionally, do something with the result, e.g., update the UI
                                        print("Selected Location: ${selectedLocation.latitude}, ${selectedLocation.longitude}");

                                      } else {
                                        print("No location selected");
                                      }
                                    },



                                  ),
                                  const SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Warehouse Type",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 2.0),
                                        child: Image.asset("assets/images/InfoPopup.png",height: 14,width: 13,),
                                      )

                                    ],
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.blue, width: 1.0),
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: widget.warehouse.whouseType1,
                                      hint: const Text('Select Warehouse Type',style: TextStyle(color: Colors.grey,fontSize: 10),),
                                      items: warehouseTypes.map((String type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type,style: TextStyle(fontSize: 14),),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedWarehouseType = newValue;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Field is required' : null,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none, // Remove default border
                                        // Padding to align text with underline
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 20.0,
                                      isExpanded: true, // Make the dropdown take full width
                                    ),
                                  ),
                                  //WarehouseAnimatedDropDown(warehouseTypes: warehouseTypes,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Construction Type",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 2.0),
                                        child: Image.asset("assets/images/InfoPopup.png",height: 14,width: 13,),
                                      )

                                    ],
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.blue, width: 1.0),
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: widget.warehouse.whouseType2,
                                      hint: const Text('Select Construction Type',style: TextStyle(color: Colors.grey,fontSize: 10),),
                                      items: _construction.map((String type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type,style: TextStyle(fontSize: 14),),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _constructionType = newValue;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Field is required' : null,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none, // Remove default border
                                        // Padding to align text with underline
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 20.0,
                                      isExpanded: true, // Make the dropdown take full width
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Number of floors including Ground floors",style: TextStyle(fontSize: 9,fontWeight: FontWeight.normal),),
                                      Container(
                                        height: 20,
                                        width: 82, // Adjusted width
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1),
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.blue),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: _decrease,
                                              child: Container(
                                                width: 25, // Width for minus button
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  '-',
                                                  style: TextStyle(fontSize: 14, color: Colors.red), // Adjusted font size
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 30, // Width for number display
                                              color: Colors.blue,
                                              alignment: Alignment.center,
                                              child: Text(
                                                _number.toString(),
                                                style: const TextStyle(fontSize: 14, color: Colors.white), // Adjusted font size
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: _increase,
                                              child: Container(
                                                width: 25, // Width for plus button
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  '+',
                                                  style: TextStyle(fontSize: 14, color: Colors.green), // Adjusted font size
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                  const SizedBox(height: 8,),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Carpet Area Ground Floor",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  CarpetAreaTextFormField(controller: _carpetAreaController),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            _isChecked = newValue ?? false;
                                          });
                                        },
                                        checkColor: Colors.blue, // Color of the check mark
                                        fillColor: WidgetStateProperty.all(Colors.white), // Background color when checked
                                        side: WidgetStateBorderSide.resolveWith((states) {
                                          if (states.contains(WidgetState.selected)) {
                                            return const BorderSide(color: Colors.blue, width: 2); // Border color when checked
                                          }
                                          return const BorderSide(color: Colors.grey, width: 2); // Border color when unchecked
                                        }),
                                      ),
                                      const Text("Is the base available for rent?",style: TextStyle(color: Colors.grey,fontSize: 13),)
                                    ],
                                  ),
                                  const Text("Total carpet area",style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w600),),
                                  TotalCarpetArea(totalcarpetArea:_totalCarpetArea),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Rent per Sq.ft",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  rentPerSqFt(controller: _rentPerSqFt,),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Maintenance Cost (per Sq.ft.) ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  maintenanceCost(controller: _maintenanceCost,),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Expected Security Deposit",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  ExpectedSecurityDeposit(controller: _expectedSecurityDeposit,),
                                  const Text("Security deposit: ₹0",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Token Advance",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  TokenAdvance(controller: _tokenAdvance,),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Expected Lock-in Period",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),


                                    ],
                                  ),
                                  ExpectedLockInPeriod(controller: _expectedLockInPeriod,),
                                  Row(
                                    children: [
                                      const Text("Warehouse Name/Owner's name",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 2.0),
                                        child: Image.asset("assets/images/InfoPopup.png",height: 18,width: 17,color: Colors.black,),
                                      )

                                    ],
                                  ),
                                  TextFormField(
                                    validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
                                    controller: _warehouseName,
                                    decoration: const InputDecoration(
                                      hintText: 'ex. Thane Mumbai Warehouse',
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                      ),

                                    ),
                                    style: const TextStyle(fontSize: 14), // Set text size to 29
                                    maxLength: _maxLength, // Limit text length
                                    keyboardType: TextInputType.text, // If you expect numeric input
                                  ),
                                  const SizedBox(height: 30,),
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                      child: DottedBorder(
                                        child: Container(
                                          color: Colors.blue,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              isLoading?SpinKitCircle(
                                                color: Colors.white,
                                                size: 50.0,
                                              )
                                                  :Text(
                                                'Update  & Proceed',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      _submitForm();
                                     //  if (_formKey.currentState!.validate()) {
                                     //    // Process data if the form is valid
                                     //
                                     //   // print("Form Submitted Successfully!");
                                     //    // You can navigate to the next screen or process the data here
                                     //  } else {
                                     //    print("Form is invalid!");
                                     //  }
                                     //  _submitForm;
                                     //  Navigator.push(
                                     //      context, MaterialPageRoute(builder: (context) => WarehouseImageScreen()));
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                                      child: DottedBorder(
                                        child: Container(
                                          color: Colors.blue,
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              isLoading?SpinKitCircle(
                                                color: Colors.white,
                                                size: 50.0,
                                              )
                                                  :Row(
                                                    children: [
                                                      Text(
                                                                                                      'Skip for now',
                                                                                                      style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                                                                      ),
                                                                                                    ),
                                                      Icon(Icons.skip_next_outlined,color: Colors.white,)
                                                    ],
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );

                                      //  if (_formKey.currentState!.validate()) {
                                      //    // Process data if the form is valid
                                      //
                                      //   // print("Form Submitted Successfully!");
                                      //    // You can navigate to the next screen or process the data here
                                      //  } else {
                                      //    print("Form is invalid!");
                                      //  }
                                      //  _submitForm;
                                      //  Navigator.push(
                                      //      context, MaterialPageRoute(builder: (context) => WarehouseImageScreen()));
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


}


class CarpetAreaTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const CarpetAreaTextFormField({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: InputDecoration(
        hintText: 'Enter carpet area',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|sqft',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class TotalCarpetArea extends StatelessWidget {
  final TextEditingController totalcarpetArea;

  const TotalCarpetArea({super.key, required this.totalcarpetArea});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6)
      ),

      child: TextFormField(
        style: TextStyle(fontSize: 14),
        controller: totalcarpetArea,
        keyboardType: TextInputType.number,
        validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
          contentPadding: const EdgeInsets.only(left: 8,bottom: 10), // Adjust vertical padding
          border: InputBorder.none,


          suffix: Container(
            padding: const EdgeInsets.only(left: 8.0,right: 6), // Space between the text and the input
            child: const Text(
              '|sqft',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
class rentPerSqFt extends StatelessWidget {
  final TextEditingController controller;

  const rentPerSqFt({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: InputDecoration(
        hintText: '₹|ex.35',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class maintenanceCost extends StatelessWidget {
  final TextEditingController controller;

  const maintenanceCost({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: InputDecoration(
        hintText: '₹|ex.2',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class ExpectedSecurityDeposit extends StatelessWidget {
  final TextEditingController controller;

  const ExpectedSecurityDeposit({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: const InputDecoration(
        hintText: 'ex.2',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        // suffix: Container(
        //   padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
        //   child: Text(
        //     '|per month',
        //     style: TextStyle(color: Colors.grey, fontSize: 13),
        //   ),
        // ),
      ),
    );
  }
}
class TokenAdvance extends StatelessWidget {
  final TextEditingController controller;

  const TokenAdvance({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: InputDecoration(
        hintText: 'ex.3',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class ExpectedLockInPeriod extends StatelessWidget {
  final TextEditingController controller;

  const ExpectedLockInPeriod({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
      decoration: InputDecoration(
        hintText: 'ex.18',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}



class DottedBorder extends StatelessWidget {
  final Widget child;

  const DottedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double dashWidth = 4.0;
    const double dashSpace = 4.0;
    double startX = 0;


    // Draw dotted border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.height) {
      canvas.drawLine(
        Offset(size.width, startX),
        Offset(size.width, startX + dashWidth),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.width) {
      canvas.drawLine(
        Offset(size.width - startX, size.height),
        Offset(size.width - startX - dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.height) {
      canvas.drawLine(
        Offset(0, size.height - startX),
        Offset(0, size.height - startX - dashWidth),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
