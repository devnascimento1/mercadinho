import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mercado/SharedPreferencesHelper.dart';
import 'package:mercado/modelProduto.dart';

class SacolaScreen extends StatefulWidget {
  @override
  _SacolaScreenState createState() => _SacolaScreenState();
}

class _SacolaScreenState extends State<SacolaScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  List<Produto> _sacola = [];

  @override
  void initState() {
    super.initState();
    _refreshSacola();
  }

  Future<void> _refreshSacola() async {
    final sacola = await _prefsHelper.getSacola();
    setState(() {
      _sacola = sacola;
    });
  }

  Future<void> _removeFromSacola(int produtoId) async {
    await _prefsHelper.removeFromSacola(produtoId);
    _refreshSacola();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 300),
      content: Text('Produto removido da sacola'),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        title: const Text('Sacola'),
      ),
      body: _sacola.isNotEmpty ? 
      
      ListView.builder(
        itemCount: _sacola.length,
        itemBuilder: (context, index) {
          final produto = _sacola[index];
          return Card(
            child: ListTile(
              leading: produto.imagem.isNotEmpty
                  ? Image.file(File(produto.imagem))
                  : null,
              title: Text(produto.nome),
              subtitle: Text(
                  'Descrição: ${produto.descricao}\nPreço: R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_shopping_cart),
                onPressed: () => _removeFromSacola(produto.id),
              ),
              onTap: () {
                // Adicionar funcionalidade ao clicar no produto
              },
            ),
          );
        },
      )
      : Center( child: Text("Sacola Vazia"),) 
    );
  }
}
