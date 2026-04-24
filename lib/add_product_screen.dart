import 'package:flutter/material.dart';
import 'product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void saveProduct() {
    final product = Product(
      name: nameController.text,
      category: categoryController.text,
      expiryDate: dateController.text,
    );

    Navigator.pop(context, product); // 🔥 send data back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: inputStyle("Product Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: categoryController,
              decoration: inputStyle("Category"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: dateController,
              decoration: inputStyle("Expiry Date"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: saveProduct,
              child: const Text("Add Product"),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}