
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Expressinterestdatetime extends StatefulWidget {
  @override
  State<Expressinterestdatetime> createState() => _ExpressinterestdatetimeState();
}

class _ExpressinterestdatetimeState extends State<Expressinterestdatetime> {
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                      child: Text(
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
                    boxShadow: [
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
                    child: Text('Cancel', style: TextStyle(color: Colors.blue)),
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


  TextEditingController _timeController = TextEditingController();
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
                      borderRadius: BorderRadius.only(
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
                  Container(
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
                      child: Text(
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
                    boxShadow: [
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
                    child: Text('Cancel', style: TextStyle(color: Colors.blue)),
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
          Icon(Icons.arrow_drop_up, size: 30, color: Colors.grey), // Up arrow
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
                    style: TextStyle(fontSize: 22),
                  ),
                );
              }),
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 30, color: Colors.grey), // Down arrow
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
          Icon(Icons.arrow_drop_up, size: 30, color: Colors.grey), // Up arrow
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
              children: <Widget>[
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
          Icon(Icons.arrow_drop_down, size: 30, color: Colors.grey), // Down arrow
        ],
      ),
    );
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
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18.0,top: 15),
                                              child: Text("SELECT DATE",style: TextStyle(fontWeight: FontWeight.w700),),
                                            )),
                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15),
                                          child: TextField(

                                            controller: _dateController,
                                            decoration: InputDecoration(
                                              labelText: 'Date',
                                              labelStyle: TextStyle(color: Colors.black), // Label text in blue color
                                              hintText: 'dd/mm/yyyy',
                                              hintStyle: TextStyle(color: Colors.grey), // Optional hint color customization
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.calendar_today),
                                                onPressed: () => _selectDate(context),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Blue color for the border
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: screenHeight*0.18,
                                    width: screenWidth*0.95,

                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18.0,top: 15),
                                              child: Text("SELECT TIME",style: TextStyle(fontWeight: FontWeight.w700),),
                                            )),
                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15),
                                          child: TextField(

                                            controller: _timeController,
                                            readOnly: true,
                                            onTap: () => _selectTime(context),
                                            decoration: InputDecoration(
                                              labelText: 'Time',
                                              labelStyle: TextStyle(color: Colors.black), // Label text in blue color
                                              // Optional hint color customization
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.more_time_rounded),
                                                onPressed: () {},
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey, width: 2.0), // Blue color for the border
                                              ),
                                              focusedBorder: OutlineInputBorder(
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
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Expressinterestdatetime()));
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

























