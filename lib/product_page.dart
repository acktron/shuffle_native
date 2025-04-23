import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shuffle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF26C6DA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset('assesets/images/MainLogo.png', height: 25),

            // Text(
            //   'X',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24,
            //   ),
            // ),
            Text(
              'Shuffle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image Carousel
          Expanded(
            flex: 3,
            child: ProductImageCarousel(
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),

          // Product Info
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Three dots menu
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Icon(
                  //     Icons.more_horiz,
                  //     color: Color(0xFF26C6DA),
                  //     size: 30,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),

                  // Product title
                  const Text(
                    'Casio FX-991ES',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Scientific Calculator',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  // Owner info
                  Text(
                    'Owner: Rehman Bhaijan',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Price info
                  Row(
                    children: [
                      Text(
                        'Rs 10/day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Deposit: Rs 500',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Rent Now button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF087272),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Rent Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description section
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cheez badiya hai, bas isme kharcha itna hai na but lena hai to le le, lekin agar kuch hua to to maa chod dunga teri badkismat sab ahar me gake paisa chadunga sab',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: NavBarItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: true,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/homepage'),
                ),
                NavBarItem(icon: Icons.inventory_2, label: 'Rented'),
                NavBarItem(icon: Icons.add_box, label: 'Upload Item'),
                NavBarItem(icon: Icons.person, label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductImageCarousel extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const ProductImageCarousel({
    Key? key,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            Image.asset('assesets/images/test_img.png', fit: BoxFit.contain),
            Image.asset(
              'assesets/images/SigninVector.png',
              fit: BoxFit.contain,
            ),
            Image.asset(
              'assesets/images/SignupVector.png',
              fit: BoxFit.contain,
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: DotIndicator(currentPage: currentPage, totalDots: 3),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalDots;

  const DotIndicator({
    Key? key,
    required this.currentPage,
    required this.totalDots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 12 : 8,
          height: currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: currentPage == index ? const Color(0xFF26C6DA) : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? Color(0xFF26C6DA) : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Color(0xFF26C6DA) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
