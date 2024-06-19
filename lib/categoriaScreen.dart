import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mercado/addCategoriaScreen.dart';
import 'package:mercado/modelCategoria.dart';
import 'package:mercado/produtoScreen.dart';
import 'package:mercado/sharedPreferencesHelper.dart';

class CategoriaScreen extends StatefulWidget {
  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _refreshCategorias();
  }

  Future<void> _refreshCategorias() async {
    final categorias = await _prefsHelper.getCategorias();
    setState(() {
      _categorias = categorias;
    });
  }

  void _addCategoria() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategoriaScreen(onSave: _refreshCategorias),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: false, // Adicione essa linha
  backgroundColor: Color.fromARGB(255, 227, 227, 227),
  appBar: AppBar(
    backgroundColor: Color.fromARGB(255, 227, 227, 227),
    title: Text('Todos os produtos'),
    centerTitle: true,
  ),
  body: ListView.builder(
        itemCount:
            (_categorias.length / 2).ceil(), // Calcula o número de linhas
        itemBuilder: (context, index) {
          final int firstIndex = index * 2;
          final int secondIndex = firstIndex + 1;
          return Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 180,
                child: Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProdutoScreen(
                            categoriaNome: _categorias[firstIndex].nome,
                              categoriaId: _categorias[firstIndex].id),
                        ),
                      );
                    },
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: _categorias[firstIndex].imagem.isNotEmpty
                                  ? Image.file(
                                      File(_categorias[firstIndex].imagem))
                                  : SizedBox(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_categorias[firstIndex].nome),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10), // Espaço entre os itens
              SizedBox(
                width: 180,
                child: Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (secondIndex < _categorias.length) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProdutoScreen(
                              categoriaNome: _categorias[secondIndex].nome,
                                categoriaId: _categorias[secondIndex].id),
                          ),
                        );
                      }
                    },
                    child: secondIndex < _categorias.length
                        ? Card(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: _categorias[secondIndex]
                                            .imagem
                                            .isNotEmpty
                                        ? Image.file(File(
                                            _categorias[secondIndex].imagem))
                                        : SizedBox(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_categorias[secondIndex].nome),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(), // Se não houver segundo item, exiba um SizedBox
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
