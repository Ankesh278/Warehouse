import 'package:Lisofy/Transportation/User/summary_screen.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/custom_button.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/custom_textfield.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/cutom_app_bar.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});



  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}
class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _advancePaymentController=TextEditingController();
  final TextEditingController _remainingPaymentController=TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Payment", onBackPressed: (){Navigator.pop(context);}
        ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth*0.07,top: screenHeight*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Advance Payment",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
              const Text("Minimum 30% of the payment",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 12),),
              Padding(
                padding:  EdgeInsets.only(right: screenWidth*0.07),
                child: CustomTextField(hintText: "₹", height: screenHeight*0.05, width: double.infinity,controller: _advancePaymentController,keyboardType: TextInputType.number,),
              ),
              SizedBox(height: screenHeight*0.05,),
              const Text("Balance Payment",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
              const Text("Will be payed after the Delivery",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 12),),
              Padding(
                padding:  EdgeInsets.only(right: screenWidth*0.07),
                child: CustomTextField(hintText: "₹", height: screenHeight*0.05, width: double.infinity,controller: _remainingPaymentController,keyboardType: TextInputType.number),
              ),
              SizedBox(height: screenHeight*0.1,),
              Center(child: CustomButton(text: "Confirm", color: Colors.blue, onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>const SummaryScreen()));
              }))
            ],
          ),
        ),
      ),
      ),
    );
  }
}
