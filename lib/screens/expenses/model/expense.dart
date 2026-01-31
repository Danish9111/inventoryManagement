class Expense {
  final String id;
  final String name;
  final String category;
  final double amount;
  final String? description;
  final DateTime date;
  final String status;

  const Expense({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.amount,
    required this.date,
    required this.status,
  });

  static List<Expense> expensesList = [
    Expense(
      id: '1',
      name: 'iPhone 14 Purchase',
      category: 'Electronics',
      amount: 15800,
      description: 'Stock purchase of iPhone 14 64GB',
      date: DateTime(2025, 1, 5),
      status: 'Paid',
    ),
    Expense(
      id: '2',
      name: 'MacBook Pro Purchase',
      category: 'Computers',
      amount: 1000,
      description: 'MacBook Pro for office use',
      date: DateTime(2025, 1, 7),
      status: 'Paid',
    ),
    Expense(
      id: '3',
      name: 'Luxury Watch Procurement',
      category: 'Accessories',
      amount: 6800,
      description: 'Rolex Tribute V3 stock purchase',
      date: DateTime(2025, 1, 10),
      status: 'Pending',
    ),
    Expense(
      id: '4',
      name: 'Nike Shoes Inventory',
      category: 'Footwear',
      amount: 398,
      description: 'Nike Air Max for resale',
      date: DateTime(2025, 1, 12),
      status: 'Paid',
    ),
    Expense(
      id: '5',
      name: 'Samsung Galaxy S24 Stock',
      category: 'Electronics',
      amount: 12500,
      description: 'Samsung Galaxy S24 bulk order',
      date: DateTime(2025, 1, 15),
      status: 'Paid',
    ),
    Expense(
      id: '6',
      name: 'Dell XPS 15 Purchase',
      category: 'Computers',
      amount: 850,
      description: 'Dell XPS laptop for staff',
      date: DateTime(2025, 1, 18),
      status: 'Pending',
    ),
    Expense(
      id: '7',
      name: 'Sony Headphones Inventory',
      category: 'Audio',
      amount: 450,
      description: 'Sony WH-1000XM5 bulk purchase',
      date: DateTime(2025, 1, 20),
      status: 'Paid',
    ),
    Expense(
      id: '8',
      name: 'iPad Pro Purchase',
      category: 'Tablets',
      amount: 1200,
      description: 'iPad Pro 12.9" for office use',
      date: DateTime(2025, 1, 22),
      status: 'Paid',
    ),
  ];
}
