
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/User/userHomePage.dart';


class Expressinterestdatetime extends StatefulWidget {
  final name;
  final email;
  final phone;
  final companyName;
  final designation;
  final dateOfPossession;
  final msg;
  final id;
  const Expressinterestdatetime({super.key,required this.id,required this.name,required this.email,required this.phone,required this.companyName,required this.designation,required this.msg, this.dateOfPossession});
  @override
  State<Expressinterestdatetime> createState() => _ExpressinterestdatetimeState();
}

class _ExpressinterestdatetimeState extends State<Expressinterestdatetime> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  ///Post intrest data of the user

  Future<void> postWarehouseData() async {

    // The data you want to send
    Map<String, dynamic> data = {
      "warehouse_Id": widget.id,
      "Name": widget.name.toString(),
      "Email": widget.email.toString(),
      "Company_Name": widget.companyName.toString(),
      "Designation": widget.designation.toString(),
      "Possession_date": widget.dateOfPossession,
      "Message": widget.msg,
      "MDate": _selectedDate.toString(),
      "MTime": _selectedTime.toString(),
      "Contact": widget.phone.toString()
    };

    // The API endpoint
    String url = "https://xpacesphere.com/api/Wherehousedt/Intrest_warehouse";

    try {
      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Set the content-type to JSON
        },
        body: jsonEncode(data),  // Convert your data to JSON format
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Request was successful
        if (kDebugMode) {
          print('Data posted successfully!');
        }
        if (kDebugMode) {
          print('Response: ${response.body}');
        }
        showCongratulationsDialog(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Interest Showed',style: TextStyle(fontSize: 12,color: Colors.white),),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => userHomePage(latitude:latitude ,longitude: longitude,)),
        //       (Route<dynamic> route) => false,
        // );

      } else {
        // Request failed
        if (kDebugMode) {
          print('Response: ${response.body}');
        }
      }
    } catch (error) {
      // Catch any errors that occur during the request
      if (kDebugMode) {
        print('Error occurred: $error');
      }
    }
  }



  void showCongratulationsDialog(BuildContext context)async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    double? latitude=pref.getDouble("latitude");
    double? longitude=pref.getDouble("longitude");
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40), // Green checkmark
              SizedBox(width: 5),
              Text('Congratulations!', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your warehouse has been added. Our team will connect with you shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => userHomePage(latitude:latitude! ,longitude: longitude!,)),
                        (Route<dynamic> route) => false,
                  );// Navigate to home page
                },
                child: const Text('Continue Browsing'),
              ),
            ],
          ),
        );
      },
    );
  }




  void _selectDate(BuildContext context) async {
    DateTime initialDate = _selectedDate ?? DateTime.now();

    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime? tempPickedDate = initialDate; // Local variable for date selection

        return Dialog(
          child: Stack(
            clipBehavior: Clip.none, // Allows the "Cancel" button to appear outside the dialog
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Picker with only top border-radius
                  Container(
                    height: 150,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      border: Border.all(color: Colors.grey), // Grey border only
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime newDate) {
                        tempPickedDate = newDate; // Update the local variable
                      },
                      backgroundColor: Colors.transparent, // No background color
                    ),
                  ),

                  // Divider between the picker and OK button
                  Container(width: 300, height: 3, color: Colors.grey),

                  // OK button inside the dialog with no border-radius
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25)// No border radius on the dialog itself
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, tempPickedDate); // Pass the selected date back
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),

              // "Cancel" button below the dialog, placed outside the dialog itself
              Positioned(
                bottom: -70, // Positioning the button outside the dialog
                left: 0,
                right: 0,
                child: Container(
                  width: 300, // Same width as the dialog
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners for the Cancel button
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4), // Shadow effect for floating look
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog without selecting a date
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ],
          ),
        );



      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }


  final TextEditingController _timeController = TextEditingController();
  DateTime? _selectedTime;

  void _selectTime(BuildContext context) async {
    DateTime initialTime = _selectedTime ?? DateTime.now();

    DateTime? pickedTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime? tempPickedTime = initialTime;
        int selectedHour =
        initialTime.hour > 12 ? initialTime.hour - 12 : initialTime.hour;
        int selectedMinute = initialTime.minute;
        bool isAm = initialTime.hour < 12;

        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time Picker with top border-radius
                  Container(
                    height: 160, // Increased to fit arrows and picker
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Hour picker with arrows
                        _buildTimeColumnWithArrows(
                          context,
                          1,
                          12,
                          selectedHour,
                              (newHour) {
                            selectedHour = newHour;
                          },
                        ),
                        // Minute picker with arrows
                        _buildTimeColumnWithArrows(
                          context,
                          0,
                          59,
                          selectedMinute,
                              (newMinute) {
                            selectedMinute = newMinute;
                          },
                        ),
                        // AM/PM picker with arrows and blue text
                        _buildAmPmColumnWithArrows(
                          isAm ? 'AM' : 'PM',
                              (newAmPm) {
                            isAm = (newAmPm == 'AM');
                          },
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(width: 300, height: 3, color: Colors.grey),
                  // OK button
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      onPressed: () {
                        // Adjusting time for AM/PM
                        int hour = isAm
                            ? selectedHour % 12
                            : (selectedHour % 12) + 12;
                        tempPickedTime = DateTime(
                          initialTime.year,
                          initialTime.month,
                          initialTime.day,
                          hour,
                          selectedMinute,
                        );
                        Navigator.pop(context, tempPickedTime);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              // "Cancel" button below the dialog
              Positioned(
                bottom: -70,
                left: 0,
                right: 0,
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = DateFormat('hh:mm a').format(_selectedTime!);
      });
    }
  }

  Widget _buildTimeColumnWithArrows(BuildContext context, int min, int max,
      int selectedValue, ValueChanged<int> onSelectedItemChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          const Icon(Icons.arrow_drop_up, size: 30, color: Colors.grey), // Up arrow
          SizedBox(
            width: 60,
            height: 80, // Reduced height to fit the arrows
            child: CupertinoPicker(
              scrollController:
              FixedExtentScrollController(initialItem: selectedValue - min),
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                onSelectedItemChanged(index + min);
              },
              magnification: 1.2,
              useMagnifier: true,
              backgroundColor: Colors.transparent,
              children: List<Widget>.generate(max - min + 1, (int index) {
                return Center(
                  child: Text(
                    (index + min).toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }),
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 30, color: Colors.grey), // Down arrow
        ],
      ),
    );
  }

  Widget _buildAmPmColumnWithArrows(
      String selectedAmPm, ValueChanged<String> onSelectedItemChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          const Icon(Icons.arrow_drop_up, size: 30, color: Colors.grey), // Up arrow
          SizedBox(
            width: 60,
            height: 80,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                  initialItem: selectedAmPm == 'AM' ? 0 : 1),
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                onSelectedItemChanged(index == 0 ? 'AM' : 'PM');
              },
              magnification: 1.2,
              useMagnifier: true,
              backgroundColor: Colors.transparent,
              children: const <Widget>[
                Center(
                  child: Text(
                    'AM',
                    style: TextStyle(fontSize: 22, color: Colors.blue),
                  ),
                ),
                Center(
                  child: Text(
                    'PM',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 30, color: Colors.grey), // Down arrow
        ],
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                }, icon: const Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,)),
                                const SizedBox(width: 0,),
                                const Text("Express Interest",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.white),)
                              ],
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
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: screenHeight*0.18,
                                    width: screenWidth*0.95,

                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 18.0,top: 15),
                                              child: Text("SELECT DATE",style: TextStyle(fontWeight: FontWeight.w700),),
                                            )),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15),
                                          child: TextField(
                                            onTap: (){_selectDate(context);},
                                            readOnly: true,
                                            controller: _dateController,
                                            decoration: InputDecoration(
                                              labelText: 'Date',
                                              labelStyle: const TextStyle(color: Colors.black), // Label text in blue color
                                              hintText: 'dd/mm/yyyy',
                                              hintStyle: const TextStyle(color: Colors.grey), // Optional hint color customization
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.calendar_today),
                                                onPressed: () => _selectDate(context),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Blue color for the border
                                              ),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: screenHeight*0.18,
                                    width: screenWidth*0.95,

                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 18.0,top: 15),
                                              child: Text("SELECT TIME",style: TextStyle(fontWeight: FontWeight.w700),),
                                            )),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15),
                                          child: TextField(

                                            controller: _timeController,
                                            readOnly: true,
                                            onTap: () => _selectTime(context),
                                            decoration: InputDecoration(
                                              labelText: 'Time',
                                              labelStyle: const TextStyle(color: Colors.black), // Label text in blue color
                                              // Optional hint color customization
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.more_time_rounded),
                                                onPressed: () { _selectTime(context);},
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Blue color for the border
                                              ),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                          postWarehouseData();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                          minimumSize: Size(double.infinity, screenHeight * 0.06), // Responsive button size
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(21), // Match the container's border radius
                                          ),
                                        ),
                                        child: const Text('Submit'),
                                      ),
                                    ),
                                  ),
                                ],
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

























