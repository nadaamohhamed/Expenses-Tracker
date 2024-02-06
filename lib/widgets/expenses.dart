import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpneses = [
    Expense(
      title: 'Flutter Course',
      amount: 100.0,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 25.0,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpneses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpneses.indexOf(expense);

    setState(() {
      _registeredExpneses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted.'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpneses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No Expenses found currently. Start adding some!'),
    );

    if (_registeredExpneses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpneses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Expense Tracker'), actions: [
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
        )
      ]),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpneses),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(
              children: [
                // chart must be wrapped in expanded widget to work
                Expanded(child: Chart(expenses: _registeredExpneses)),
                Expanded(
                  child: mainContent,
                )
              ],
            ),
    );
  }
}
