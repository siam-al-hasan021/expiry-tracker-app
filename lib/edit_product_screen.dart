import 'package:flutter/material.dart';
import 'product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState
    extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController expiryController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.product.name);

    categoryController =
        TextEditingController(text: widget.product.category);

    expiryController =
        TextEditingController(text: widget.product.expiryDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: expiryController,
              decoration: const InputDecoration(
                labelText: "Expiry Date",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final updatedProduct = Product(
                  id: widget.product.id,
                  name: nameController.text,
                  category: categoryController.text,
                  expiryDate: expiryController.text,
                );

                Navigator.pop(context, updatedProduct);
              },
              child: const Text("Update Product"),
            )
          ],
        ),
      ),
    );
  }
}