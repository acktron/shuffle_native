import 'package:flutter/material.dart';

class RentalItem {
  final String title;
  final String description;
  final int pricePerDay;
  final String imagePath;
  final String status;
  final int daysRented;
  final String returnDate;

  RentalItem({
    required this.title,
    required this.description,
    required this.pricePerDay,
    required this.imagePath,
    required this.status,
    required this.daysRented,
    required this.returnDate,
  });
}

class MyRentalsPage extends StatefulWidget {
  const MyRentalsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyRentalsPageState createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  String selectedStatus = "Active";

  final List<RentalItem> allItems = [
    RentalItem(
      title: "Casio FX-991MS",
      description: "Scientific Calculator",
      pricePerDay: 10,
      imagePath: "assesets/images/test_img.png",
      status: "Active",
      daysRented: 3,
      returnDate: "March 10",
    ),
    RentalItem(
      title: "Casio FX-991MS",
      description: "Scientific Calculator",
      pricePerDay: 10,
      imagePath: "assesets/images/test_img.png",
      status: "Pending",
      daysRented: 3,
      returnDate: "March 11",
    ),
    RentalItem(
      title: "Casio FX-991MS",
      description: "Scientific Calculator",
      pricePerDay: 10,
      imagePath: "assesets/images/test_img.png",
      status: "Completed",
      daysRented: 5,
      returnDate: "March 01",
    ),
    RentalItem(
      title: "Casio FX-991MS",
      description: "Scientific Calculator",
      pricePerDay: 10,
      imagePath: "assesets/images/test_img.png",
      status: "Approved",
      daysRented: 5,
      returnDate: "March 01",
    ),
    RentalItem(
      title: "Casio FX-991MS",
      description: "Scientific Calculator",
      pricePerDay: 10,
      imagePath: "assesets/images/test_img.png",
      status: "Rejected",
      daysRented: 5,
      returnDate: "March 01",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<RentalItem> filteredItems =
        allItems.where((item) => item.status == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rented Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: ["Active", "Pending", "Approved", "Rejected", "Completed"]
                  .map(
                    (status) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selectedStatus == status
                              ? Colors.teal.shade100
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.teal),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStatus = status;
                          });
                        },
                        child: Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedStatus == status ? Colors.teal[900] : Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return RentalItemCard(item: filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RentalItemCard extends StatelessWidget {
  final RentalItem item;

  const RentalItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(item.imagePath, height: 80, width: 60, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(item.description),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: "Rs ${item.pricePerDay}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: const [
                        TextSpan(
                          text: "/day",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text("Rented for ${item.daysRented} days"),
                  Text("Return by ${item.returnDate}"),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text("${item.status} !"),
              backgroundColor: item.status == "Rejected"
                  ? Colors.red.shade100
                  : Colors.green.shade100,
              labelStyle: TextStyle(
                color: item.status == "Rejected" ? Colors.red : Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}