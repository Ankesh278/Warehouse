import 'package:Lisofy/Transportation/User/payment_screen.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/custom_button.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/cutom_app_bar.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  final String goodsType;
  final String vehicleType;
  final String dateOfTransportation;
  final String startingPoint;
  final String destination;
  final String totalDistance;
  final String paymentMethod;
  final String weight;
  final String selectedQuantityType;
  const SummaryScreen({super.key, required this.goodsType, required this.vehicleType, required this.dateOfTransportation, required this.startingPoint, required this.destination, required this.totalDistance, required this.paymentMethod, required this.weight, required this.selectedQuantityType});
  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return  SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Summary", onBackPressed: (){Navigator.pop(context);}),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth*0.07,vertical: screenHeight*0.02),
                width: double.infinity,
                height: screenHeight*0.54,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Goods Type",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 4),
                      child: Text(widget.goodsType,style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                    ),
                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Vehicle Type",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 4),
                      child: Text(widget.vehicleType,style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                    ),
                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Date of Transportation",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 4),
                      child: Text(widget.dateOfTransportation,style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                    ),
                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Starting point",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.startingPoint,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Destination",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.destination,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Total Distance",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 4),
                      child: Text("${widget.totalDistance} Km",style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                    ),
                    const Divider(thickness: 2,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Weight",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 4),
                      child: Text("${widget.weight} ${widget.selectedQuantityType}",style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth*0.07,vertical: screenHeight*0.02),
                height: screenHeight*0.07,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth*0.05),
                  border: Border.all(color: Colors.grey,width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Estimated Fare"),
                    Text("₹ 16000-18000"),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.04,),
              CustomButton(text: "Confirm", color: Colors.blue, onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaymentScreen()));
              }),
              SizedBox(height: screenHeight*0.04,),
            ],
          ),
        ),
      ),
    );
  }
}
