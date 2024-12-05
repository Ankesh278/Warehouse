
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;


class searchLocationUser extends StatefulWidget {
  @override
  State<searchLocationUser> createState() => _searchLocationUserState();
}

class _searchLocationUserState extends State<searchLocationUser> {

  final TextEditingController _controller = TextEditingController();
  var uuid=Uuid();
  String _sessionToken='12345';
  List<dynamic> placesList=[];


@override
  void initState() {
  _controller.addListener((){
    onChanged();
  });
    super.initState();
  }

  void onChanged(){
  if(_sessionToken!=null){
    setState(() {
      _sessionToken=uuid.v4();
    });

  }
  getSuggestion(_controller.text);
  }
  void getSuggestion(String input) async{
  String PlacesApi="AIzaSyDxbkZhKCXDGPdtOWxTPxFBg_tjAd3jsTk";
  String baseUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json";
  String request = '$baseUrl?input=$input&key=$PlacesApi&sessiontoken=$_sessionToken';

  var response=await http.get(Uri.parse(request));
  print("Placesss>>>>>>"+response.body.toString());
  if(response.statusCode==200){

    setState(() {
      placesList=jsonDecode(response.body.toString())['predictions'];
    });
  }else{
    throw Exception("Exception Occured check the api calling");
  }

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
                          top: screenHeight * 0.070,
                          left: screenWidth * 0.045,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                       IconButton(onPressed: (){
                                         Navigator.pop(context);
                                       }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,))
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(),

                                SizedBox(width: 5),

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
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: 'Delhi',
                                        label: Text("Location",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                        child: Text("Radius in KM",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),)),
                                  ),
                                  SizedBox(height: 0),
                                  // Cards Section
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [5, 10, 20, "KM"].map((value) {
                                      return Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: Container(
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(color: Color(0xffD9D9D9),border: Border.all(color: Color(0xff585858),),borderRadius: BorderRadius.circular(10)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$value',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )


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

























