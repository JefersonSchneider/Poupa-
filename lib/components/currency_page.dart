import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  Map<String, dynamic>? _exchangeRates;
  bool _loading = false;

  Future<void> _getExchangeRates() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _exchangeRates = data["rates"];
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  void initState() {
    super.initState();
    _getExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taxas de Câmbio'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _exchangeRates != null
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Conversão de Moedas (Base: USD)',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DataTable(
                                columnSpacing: 20,
                                horizontalMargin: 15,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Moeda',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Taxa de Câmbio',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: _buildCurrencyRows(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Erro ao carregar dados')),
    );
  }

  List<DataRow> _buildCurrencyRows() {
    final currencies = ['BRL', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CNY', 'INR'];
    return currencies.map((currency) {
      return DataRow(cells: [
        DataCell(Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.deepPurple),
            const SizedBox(width: 8),
            Text(currency, style: const TextStyle(fontSize: 16)),
          ],
        )),
        DataCell(Text(
          _exchangeRates![currency]?.toStringAsFixed(2) ?? 'N/A',
          style: const TextStyle(fontSize: 16),
        )),
      ]);
    }).toList();
  }
}
