import 'dart:io';

// Storage for the products
List<Product> products = [];

// Product class
class Product {
  String name;
  int quantity;
  String color;
  double price;

  // Constructor
  Product(this.name, this.quantity, this.color, this.price);

  @override
  String toString() {
    return 'Name: $name | Amount: $quantity | Color: $color | Price: \$${price.toStringAsFixed(2)}';
  }
}

void addProduct() {
  print('Enter product name:');
  String name = stdin.readLineSync()!;

  print('Enter product quantity:');
  int quantity = int.parse(stdin.readLineSync()!);

  print('Enter product color:');
  String color = stdin.readLineSync()!;

  print('Enter product price:');
  double price = double.parse(stdin.readLineSync()!);

  products.add(Product(name, quantity, color, price));
  print('✅ Product added successfully!\n');
}

void viewProducts() {
  if (products.isEmpty) {
    print('⚠️ No products available.\n');
    return;
  }
  print('📦 Product List:');
  for (int i = 0; i < products.length; i++) {
    print('${i + 1}. ${products[i]}');
  }
}

void editProduct() {
  viewProducts();
  if (products.isEmpty) return;

  print('Enter the number of the product to edit:');
  int index = int.parse(stdin.readLineSync()!) - 1;

  if (index < 0 || index >= products.length) {
    print('❌ Invalid product number.\n');
    return;
  }

  print('Enter new name (leave blank to keep current):');
  String? name = stdin.readLineSync();
  if (name != null && name.isNotEmpty) {
    products[index].name = name;
  }

  print('Enter new quantity (leave blank to keep current):');
  String? qtyInput = stdin.readLineSync();
  if (qtyInput != null && qtyInput.isNotEmpty) {
    products[index].quantity = int.parse(qtyInput);
  }

  print('Enter new color (leave blank to keep current):');
  String? color = stdin.readLineSync();
  if (color != null && color.isNotEmpty) {
    products[index].color = color;
  }

  print('Enter new price (leave blank to keep current):');
  String? priceInput = stdin.readLineSync();
  if (priceInput != null && priceInput.isNotEmpty) {
    products[index].price = double.parse(priceInput);
  }

  print('✅ Product updated successfully!\n');
}

void deleteProduct() {
  viewProducts();
  if (products.isEmpty) return;

  print('Enter the number of the product to delete:');
  int index = int.parse(stdin.readLineSync()!) - 1;

  if (index < 0 || index >= products.length) {
    print('❌ Invalid product number.\n');
    return;
  }

  products.removeAt(index);
  print('🗑 Product deleted successfully!\n');
}

void main() {
  print("--------------Welcome to NewFashion E-Commerce--------------");

  while (true) {
    print(
        '\nWhat would you like to do?\n1. ADD PRODUCT\n2. VIEW PRODUCT\n3. EDIT PRODUCT\n4. DELETE PRODUCT\n5. EXIT');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        addProduct();
        break;
      case '2':
        viewProducts();
        break;
      case '3':
        editProduct();
        break;
      case '4':
        deleteProduct();
        break;
      case '5':
        print('👋 Goodbye!');
        return;
      default:
        print('❌ Invalid choice. Please try again.\n');
    }
  }
}
