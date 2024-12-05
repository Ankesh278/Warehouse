
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/User/ExpressInterestDateTime.dart';


class ExpressInterestScreen extends StatefulWidget {
  final id;
  const ExpressInterestScreen({super.key, required this.id});
  @override
  State<ExpressInterestScreen> createState() => _ExpressInterestScreenState();
}

class _ExpressInterestScreenState extends State<ExpressInterestScreen> {
  String _selectedPossession = 'Select date of possession'; // Default value
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController =TextEditingController();
  final TextEditingController emailController=TextEditingController();
  late TextEditingController phoneController;
  final TextEditingController companyController=TextEditingController();
  final TextEditingController designationController=TextEditingController();
  final TextEditingController messengerController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController = TextEditingController();
    _loadPrefilledValue();

  }
  Future<void> _loadPrefilledValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prefilledValue = prefs.getString('phone'); // Replace 'myKey' with your key
    phoneController.text=prefilledValue!;
    print("Dataa"+prefilledValue.toString());

      if (prefilledValue!.startsWith("+91")) {
        prefilledValue = prefilledValue.replaceFirst("+91", "");
        print("Prefilleeeed>>>>>>>>"+prefilledValue);
        phoneController.text = prefilledValue;
      }// Set the controller's text


  }



  List<String> possessions = [
    'Immediate',
    'Within 15 days',
    'Within 30 days',
    'Within 60 days',
  ];
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    designationController.dispose();
    messengerController.dispose();
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
                      height: screenHeight * 0.13,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.05,
                          left: screenWidth * 0.04,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,)),
                                SizedBox(width: 0,),
                                Text("Express Interest",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.white),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.005),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.07,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextFormField(
                                        controller: nameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your name';
                                          } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                            return 'Name can only contain letters';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Name', // Label Text
                                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14), // Label Text color
                                          hintText: 'Ankesh Yadav', // Hint Text
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint Text color
                                          filled: true, // Enables background fill color
                                          fillColor: Colors.white, // Background color
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Grey border
                                              width: 1.5, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border when enabled
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border color when focused
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 13,),
                                    Container(
                                      height: screenHeight*0.07,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Email', // Label Text
                                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14), // Label Text color
                                          hintText: 'Please enter your email', // Hint Text
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint Text color
                                          filled: true, // Enables background fill color
                                          fillColor: Colors.white, // Background color
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Grey border
                                              width: 1.5, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border when enabled
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border color when focused
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 13,),
                                    Container(
                                      height: screenHeight*0.07,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextFormField(
                                        controller: phoneController,
                                        readOnly: true,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelText: 'Phone', // Label Text
                                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14), // Label Text color
                                          hintText: 'Please enter your phone number', // Hint Text
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint Text color
                                          filled: true, // Enables background fill color
                                          fillColor: Colors.white, // Background color
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Grey border
                                              width: 1.5, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border when enabled
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border color when focused
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 13,),
                                    Container(
                                      height: screenHeight*0.07,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextFormField(
                                        controller: companyController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your company name';
                                          } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                            return 'Company name  can only contain letters';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Company name ', // Label Text
                                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14), // Label Text color
                                          hintText: 'Please enter your company name ', // Hint Text
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint Text color
                                          filled: true, // Enables background fill color
                                          fillColor: Colors.white, // Background color
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Grey border
                                              width: 1.5, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border when enabled
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border color when focused
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 13,),
                                    Container(
                                      height: screenHeight*0.07,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your designation';
                                          } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                            return 'Designation can only contain letters';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        controller: designationController,
                                        decoration: InputDecoration(
                                          labelText: 'Designation ', // Label Text
                                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14), // Label Text color
                                          hintText: 'e.g. CEO / MD / VP / Ops Manager / Employee', // Hint Text
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 11), // Hint Text color
                                          filled: true, // Enables background fill color
                                          fillColor: Colors.white, // Background color
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Grey border
                                              width: 1.5, // Border width
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border when enabled
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey, // Border color when focused
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(padding: EdgeInsets.only(left: screenWidth*0.055),child:
                                        Text("Date of Possession",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)
                                        ,),
                                    ),
                                    SizedBox(height: 3,),
                                    Container(
                                      height: screenHeight * 0.07,
                                      padding: EdgeInsets.only(left: 10),
                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey, width: 1.5), // Grey border for the dropdown container
                                      ),
                                      child: PopupMenuButton<String>(
                                        onSelected: (String value) {
                                          setState(() {
                                            FocusScope.of(context).unfocus();
                                            _selectedPossession = value;


                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedPossession ?? 'Select date of possession',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth * 0.15,
                                              height: double.infinity,
                                              color: Colors.blue,
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        itemBuilder: (BuildContext context) {
                                          return possessions.map<PopupMenuEntry<String>>((String value) {
                                            return PopupMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                height: 30,
                                                margin: EdgeInsets.only(top: 10),
                                                width: screenWidth * 0.3,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey), // Grey border for items
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                child: Text(value, style: TextStyle(fontSize: 10,color: Colors.grey,fontWeight: FontWeight.w600)),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        color: Colors.white, // Background color for the dropdown menu
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.grey), // Grey border color for the dropdown menu
                                        ),
                                        offset: Offset(0, 50), // Offset to make sure the menu opens below the dropdown box
                                      ),
                                    ),
                                    SizedBox(height: screenHeight*0.05,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(padding: EdgeInsets.only(left: screenWidth*0.055),child:
                                      Text("Messenger",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),)
                                        ,),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey, width: 1.5), // Grey border
                                        color: Colors.white, // Background color of the box
                                      ),
                                      child: TextFormField(
                                        controller: messengerController,
                                        validator: (value) {
                                          if (value == null || value.split(' ').length < 1) {
                                            return 'Message must contain at least some words';
                                          }
                                          return null;
                                        },
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                          border: InputBorder.none, // Removes the default border
                                          contentPadding: EdgeInsets.zero, // Removes the default padding
                                        ),
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight*0.1,),
                                    Container(
                                      height: screenHeight * 0.06,
                                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 2),
                                        borderRadius: BorderRadius.circular(21),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(21), // Apply the same border radius to the clip
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              print("Phonee"+phoneController.text);
                                              // All validations passed
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => Expressinterestdatetime(
                                                name:nameController.text.toString(),
                                                email:emailController.text.toString(),
                                                companyName:companyController.text.toString(),
                                                designation:designationController.text.toString(),
                                                phone:phoneController.text.toString(),
                                                msg:messengerController.text.toString(),
                                                dateOfPossession:_selectedPossession.toString(),
                                                id:widget.id

                                              )));
                                            }
                                          },
                                          child: Text('Submit'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            minimumSize: Size(double.infinity, screenHeight * 0.06), // Responsive button size
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(21), // Match the container's border radius
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),












                                  ],
                                ),
                              )
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

























