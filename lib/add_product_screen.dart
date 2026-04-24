import 'package:flutter/material.dart';
import 'product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  String category = "Food";
  DateTime? selectedDate;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveProduct() {
    if (nameController.text.isEmpty || selectedDate == null) return;

    final product = Product(
      name: nameController.text,
      category: category,
      expiryDate: selectedDate.toString().split(" ")[0],
    );

    Navigator.pop(context, product);
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
            inputField(nameController, "Product Name"),

            const SizedBox(height: 15),

            // Category Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                value: category,
                dropdownColor: Colors.black,
                isExpanded: true,
                underline: const SizedBox(),
                items: ["Food", "Medicine", "Cosmetics", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 15),

            // Date Picker
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(selectedDate == null
                        ? "Select Expiry Date"
                        : selectedDate.toString().split(" ")[0]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Save Product"),
            )
          ],
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}