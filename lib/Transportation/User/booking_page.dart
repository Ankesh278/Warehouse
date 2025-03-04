import 'package:Lisofy/Transportation/User/booked_page.dart';
import 'package:Lisofy/Transportation/User/transport_page_home.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: [
           const TransportPageHome(),
          _buildPage("Settings Page", Colors.greenAccent),
          const BookedPage(),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: screenHeight * 0.08,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.007),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: screenWidth*0.03,),
                  _buildNavItem(Icons.home_filled, 0),
                  const Spacer(),
                  _buildNavItem(Icons.local_shipping_outlined, 2),
                  SizedBox(width: screenWidth*0.03,),
                ],
              ),
            ),
            Positioned(
              top: -screenHeight * 0.03,
              child: InkWell(
                onTap: () => _onItemTapped(1),
                child: Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration:  BoxDecoration(
                    border: Border.all(color: _selectedIndex==1?Colors.grey:Colors.grey,width: 2),
                    shape: BoxShape.circle,
                    color: _selectedIndex==1?Colors.white:Colors.grey,
                  ),
                  child:  Icon(Icons.settings, color: _selectedIndex==1?Colors.blue:Colors.white, size: screenHeight*0.04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String text, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
      icon: Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.grey,size: screenHeight*0.04,),
      onPressed: () => _onItemTapped(index),
    );
  }
}
