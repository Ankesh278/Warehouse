
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class searchLocationUser extends StatefulWidget {
  @override
  State<searchLocationUser> createState() => _searchLocationUserState();
}

class _searchLocationUserState extends State<searchLocationUser> {

  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  List<String> _allSuggestions = ['Delhi', 'Delhi 1', 'Delhi 2']; // Your autocomplete data

  void _updateSuggestions(String query) {
    setState(() {
      _suggestions = _allSuggestions.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
                                      onChanged: _updateSuggestions,
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
                                  if (_suggestions.isNotEmpty) ...[
                                    SizedBox(height: 8),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: _suggestions.map((suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                            onTap: () {
                                              _controller.text = suggestion;
                                              setState(() {
                                                _suggestions.clear(); // Hide suggestions
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
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

























