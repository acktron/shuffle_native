import 'package:flutter/material.dart';
import 'package:shuffle_native/constants.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/services/api_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Item item;
  const ProductDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final ApiService _apiService = ApiService(); // Initialize ApiService

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image Carousel
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ProductImageCarousel(
                imageUrls: "$baseUrl${widget.item.image}",
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Owner info
                  Text(
                    'Owner: ${widget.item.owner_name}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Price info
                  Row(
                    children: [
                      Text(
                        'Rs ${widget.item.pricePerDay}/day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Deposit: Rs ${widget.item.depositAmount}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Rent Now button
                  ElevatedButton(
                    onPressed: () {
                      _showBottomModalSheet(context);
                    },
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
                    widget.item.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomModalSheet(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text(
                    'Select Dates',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                startDate = selectedDate;
                                if (endDate != null &&
                                    endDate!.isBefore(startDate!)) {
                                  endDate = null;
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            startDate == null
                                ? 'Start Date'
                                : '${startDate!.toLocal().toString().split(' ')[0]}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(0, 50),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // End Date
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              startDate == null
                                  ? null
                                  : () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? startDate!,
                                      firstDate: startDate!,
                                      lastDate: DateTime(2100),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        endDate = selectedDate;
                                      });
                                    }
                                  },
                          icon: Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            endDate == null
                                ? 'End Date'
                                : '${endDate!.toLocal().toString().split(' ')[0]}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(0, 50),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: () async {
                      if (startDate != null && endDate != null) {
                        // Call the booking API
                        final success = await _apiService.bookItem(
                          widget.item.id,
                          startDate!,
                          endDate!,
                        );
                        if (success) {
                          print('Booked item with ID: ${widget.item.id} from $startDate to $endDate');
                          Navigator.pop(context);
                        }
                      } else {
                        // Show Toast
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select both dates.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF087272),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ProductImageCarousel extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final String imageUrls;

  const ProductImageCarousel({
    Key? key,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.imageUrls
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            Image.network(imageUrls,
              fit: BoxFit.cover,
            ),
            // Image.asset(
            //   'assesets/images/SigninVector.png',
            //   fit: BoxFit.contain,
            // ),
            // Image.asset(
            //   'assesets/images/SignupVector.png',
            //   fit: BoxFit.contain,
            // ),
          ],
        ),
        // Positioned(
        //   bottom: 10,
        //   left: 0,
        //   right: 0,
        //   child: DotIndicator(currentPage: currentPage, totalDots: 3),
        // ),
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
