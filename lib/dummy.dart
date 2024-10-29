// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Container(
// height: screenHeight*0.25,
// width: screenWidth*0.45,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.9),
// spreadRadius: 0.5, // How much the shadow spreads
// blurRadius: 0.5, // The blur effect
// offset: const Offset(0, 2), // Only shift the shadow downwards
// ),
// ],
// ),
// child: Stack(
// children: [Column(
// children: [
// ClipRRect(
// borderRadius: BorderRadius.circular(15), // Set this value to half the width/height to make it circular
// child: Image.asset(
// 'assets/images/slider2.jpg',
// width: double.infinity, // Define width
// height: 110, // Define height
// fit: BoxFit.cover, // Ensures the image covers the whole container
// ),
// ),
// const SizedBox(height: 5,),
// const Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Row(children: [
// Text("₹ 15.00-18.000",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
// Text("  per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),
//
// ],),
// Row(children: [
// Text("Type: ",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.grey),),
// Text("Shed",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w600,color: Colors.black),),
//
// ],)
//
// ],
// ),
// const SizedBox(height: 5,),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Row(children: [
// const SizedBox(width: 5,),
// Image.asset("assets/images/Scaleup.png",height: 20,width: 20,),
// const Text("₹45000.00",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
// const Text(" per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),
//
// ],),
//
//
// ],
// ),
// const SizedBox(height: 5,),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// const Row(children: [
// Icon(Icons.location_on,size: 12,),
// Text("6.0 kms away",style: TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: Colors.grey),),
//
// ],),
// Row(children: [
// Image.asset("assets/images/people.png",height: 20,width: 17,),
// const SizedBox(width: 5,),
// Container(
// height: 20,
// width: 20,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(4),
// border: Border.all(color: Colors.black,width: 2)
// ),
// child: const Center(child: Text("P",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 13),)),
// )
//
// ],)
//
// ],
// ),
//
//
// ],
// ),
// Padding(
// padding: const EdgeInsets.all(4.0),
// child: Align(
// alignment: Alignment.topRight,
// child: Container(
// color: Colors.white,
// child: const Icon(Icons.file_download_outlined,color: Colors.blue,),
// )
// ),
// )
// ],
// )
// ),
// InkWell(
// child: Container(
// height: screenHeight*0.25,
// width: screenWidth*0.45,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.9),
// spreadRadius: 0.5, // How much the shadow spreads
// blurRadius: 0.5, // The blur effect
// offset: const Offset(0, 2), // Only shift the shadow downwards
// ),
// ],
// ),
// child: Stack(
// children: [Column(
// children: [
// ClipRRect(
// borderRadius: BorderRadius.circular(15), // Set this value to half the width/height to make it circular
// child: Image.asset(
// 'assets/images/slider2.jpg',
// width: double.infinity, // Define width
// height: 110, // Define height
// fit: BoxFit.cover, // Ensures the image covers the whole container
// ),
// ),
// const SizedBox(height: 5,),
// const Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Row(children: [
// Text("₹ 15.00-18.000",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
// Text("  per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),
//
// ],),
// Row(children: [
// Text("Type: ",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.grey),),
// Text("Shed",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w600,color: Colors.black),),
//
// ],)
//
// ],
// ),
// const SizedBox(height: 5,),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Row(children: [
// const SizedBox(width: 5,),
// Image.asset("assets/images/Scaleup.png",height: 20,width: 20,),
// const Text("₹45000.00",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
// const Text(" per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),
//
// ],),
//
//
// ],
// ),
// const SizedBox(height: 5,),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// const Row(children: [
// Icon(Icons.location_on,size: 12,),
// Text("6.0 kms away",style: TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: Colors.grey),),
//
// ],),
// Row(children: [
// Image.asset("assets/images/people.png",height: 20,width: 17,),
// const SizedBox(width: 5,),
// Container(
// height: 20,
// width: 20,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(4),
// border: Border.all(color: Colors.black,width: 2)
// ),
// child: const Center(child: Text("P",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 13),)),
// )
//
// ],)
//
// ],
// ),
//
//
// ],
// ),
// Padding(
// padding: const EdgeInsets.all(4.0),
// child: Align(
// alignment: Alignment.topRight,
// child: Container(
// color: Colors.white,
// child: const Icon(Icons.file_download_outlined,color: Colors.blue,),
// )
// ),
// )
// ],
// )
// ),
// onTap: (){
// Navigator.push(context, MaterialPageRoute(builder: (context)=>wareHouseDetails()));
// },
// ),
// ],
// )