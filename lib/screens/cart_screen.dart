import 'package:flutter/material.dart';
import '../models/item.dart';

class CartScreen extends StatefulWidget {
  final List<Item> cartItems;
  final Function(Item) onRemove;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Item> localCart;

  @override
  void initState() {
    super.initState();
    localCart = List.from(widget.cartItems);
  }

  double get total => localCart.fold(0, (sum, item) => sum + item.price);

  void handleRemove(Item item) {
    setState(() {
      localCart.remove(item);
    });
    widget.onRemove(item);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWide = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: localCart.isEmpty
            ? const Center(
          child: Text(
            "Your cart is empty.",
            style: TextStyle(fontSize: 16),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: localCart.length,
                itemBuilder: (context, index) {
                  final item = localCart[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.imagePath,
                                width: isWide ? 100 : screenWidth * 0.2,
                                height: isWide ? 100 : screenWidth * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: isWide ? 20 : screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${item.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: isWide ? 18 : screenWidth * 0.04,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => handleRemove(item),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.teal.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
