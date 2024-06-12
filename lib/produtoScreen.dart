import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mercado/SharedPreferencesHelper.dart';
import 'package:mercado/modelProduto.dart';
import 'package:mercado/addProdutoScreen.dart';

class ProdutoScreen extends StatefulWidget {
  final int categoriaId;
  final String categoriaNome;

  ProdutoScreen({required this.categoriaId, required this.categoriaNome});

  @override
  _ProdutoScreenState createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _refreshProdutos();
  }

  Future<void> _refreshProdutos() async {
    final produtos =
        await _prefsHelper.getProdutosByCategoria(widget.categoriaId);
    setState(() {
      _produtos = produtos;
    });
  }

  Future<void> _addProduto() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProdutoScreen(
          categoriaId: widget.categoriaId,
          onSave: _refreshProdutos,
        ),
      ),
    );
  }

  Future<void> _addToSacola(Produto produto) async {
    await _prefsHelper.addToSacola(produto);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 300),
      content: Text('${produto.nome} adicionado à sacola'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        title: Text(widget.categoriaNome),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _addProduto,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7, // Ajuste conforme necessário
        ),
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: produto.imagem.isNotEmpty
                      ? Image.file(File(produto.imagem))
                      : Container(), // Adicione um Container vazio se não houver imagem
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    produto.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    'R\$ ${produto.preco.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _addToSacola(produto),
                    style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 94, 196, 1),
                      ),
                    ),
                    child: const Stack(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Colors.white,
                            Icons.shopping_bag_outlined,
                            size: 20,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add to Bag',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
