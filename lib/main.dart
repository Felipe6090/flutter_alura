import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ByteBankApp(),
    ),
  );
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransferList(),
    );
  }
}

class TransferList extends StatefulWidget {
  final List<Transfer> _transfers = [];

  TransferList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransfersListState();
  }
}

class TransfersListState extends State<TransferList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget._transfers.length,
        itemBuilder: (context, index) {
          final transfer = widget._transfers[index];

          return TransferCard(transfer);
        },
      ),
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewTransferForm();
          }));
          future.then((value) {
            debugPrint(value.toString());

            widget._transfers.add(value);
          });
        },
      ),
    );
  }
}

class TransferCard extends StatelessWidget {
  final Transfer _transfer;

  TransferCard(this._transfer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transfer.transferValue.toString()),
        subtitle: Text(_transfer.acountNum.toString()),
      ),
    );
  }
}

class Transfer {
  final double transferValue;

  final int acountNum;

  Transfer(this.transferValue, this.acountNum);

  @override
  String toString() {
    return 'Transferencia{valor: $transferValue, numeroConta: $acountNum}';
  }
}

class NewTransferForm extends StatelessWidget {
  final TextEditingController _acountNumberController = TextEditingController();

  final TextEditingController _transferValueController =
      TextEditingController();

  NewTransferForm({Key? key}) : super(key: key);

  void _createNewTransfer(BuildContext context) {
    final int? acountNumber = int.tryParse(_acountNumberController.text);

    final double? transferValue = double.tryParse(_acountNumberController.text);

    if (acountNumber != null && transferValue != null) {
      final newTransfer = Transfer(transferValue, acountNumber);

      Navigator.pop(context, newTransfer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Editor(
              controller: _acountNumberController,
              label: 'Número da Conta',
              type: '0000'),
          Editor(
              controller: _transferValueController,
              label: 'Valor da Transferência',
              type: '00.0',
              icon: Icons.monetization_on),
          ElevatedButton(
            onPressed: () => _createNewTransfer(context),
            child: const Text('Confirmar'),
          )
        ],
      ),
      appBar: AppBar(
        title: const Text('Nova Transferência'),
      ),
    );
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String type;

  final IconData? icon;

  Editor({
    required this.controller,
    required this.label,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon) : null,
          labelText: label,
          hintText: type,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
