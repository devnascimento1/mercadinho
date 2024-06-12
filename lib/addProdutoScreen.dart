import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercado/SharedPreferencesHelper.dart';
import 'package:mercado/modelProduto.dart';

class AddProdutoScreen extends StatefulWidget {
  final int categoriaId;
  final VoidCallback onSave;

  AddProdutoScreen({required this.categoriaId, required this.onSave});

  @override
  _AddProdutoScreenState createState() => _AddProdutoScreenState();
}

class _AddProdutoScreenState extends State<AddProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  File? _image;
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduto() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final produtos =
          await _prefsHelper.getProdutosByCategoria(widget.categoriaId);
      final novoId = produtos.isNotEmpty
          ? produtos.map((p) => p.id).reduce((a, b) => a > b ? a : b) +
              1 +
              widget.categoriaId
          : 1;
      final novoProduto = Produto(
        id: novoId,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        preco: double.parse(_precoController.text),
        imagem: _image!.path,
        categoriaId: widget.categoriaId,
      );

      produtos.add(novoProduto);
      await _prefsHelper.saveProdutos(produtos);

      widget.onSave();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        title: const Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _image == null
                  ? const Text('Nenhuma imagem selecionada.')
                  : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Selecionar Imagem'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveProduto,
                child: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
