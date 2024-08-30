import 'package:flutter/material.dart';
import 'components/transaction_user.dart';


main() => runApp(const Poupamais());

class Poupamais extends StatelessWidget {
  const Poupamais({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Pesoais'),
        backgroundColor: const Color.fromARGB(255, 86, 100,
            206), // Define uma cor de fundo vermelha para o AppBar
      ),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Card(
              color: Colors.blue,
              child: Text('Gráfico'),
              elevation: 5,
            ),
          ),
          TransactionUser(),
        ],
      ),
    );
  }
}
