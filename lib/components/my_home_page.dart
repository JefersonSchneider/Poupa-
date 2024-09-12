import 'package:app_monitoramento/components/transaction_form.dart';
import 'package:app_monitoramento/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'chart.dart';
import '../models/transaction.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) async {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    await _saveTransactions();
    Navigator.of(context).pop();
  }

  _editTransaction(Transaction transaction, String title, double value, DateTime date) async {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == transaction.id);
      _transactions.add(
        Transaction(
          id: transaction.id,
          title: title,
          value: value,
          date: date,
        ),
      );
    });

    await _saveTransactions();
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) async {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });

    await _saveTransactions();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _transactions.map<Map<String, dynamic>>((tr) => tr.toMap()).toList(),
    );
    await prefs.setString('transactions', encodedData);
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('transactions');

    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        _transactions = decodedData
            .map<Transaction>((item) => Transaction.fromMap(item))
            .toList();
      });
    }
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  _openEditTransactionFormModal(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(
          (title, value, date) {
            _editTransaction(transaction, title, value, date);
          },
          transaction: transaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text(
              'Poupa+',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 8,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: const Color(0xFFF5A623),
            onPressed: () => _openTransactionFormModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(
              _transactions,
              _removeTransaction,
              _openEditTransactionFormModal,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF5A623),
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
