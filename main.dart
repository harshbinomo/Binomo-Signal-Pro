import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(BinomoSignalApp());

class BinomoSignalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binomo Signal App',
      home: SignalHomePage(),
    );
  }
}

class SignalHomePage extends StatefulWidget {
  @override
  _SignalHomePageState createState() => _SignalHomePageState();
}

class _SignalHomePageState extends State<SignalHomePage> {
  String _selectedAsset = 'EURUSD';
  String _signal = 'Loading...';
  String _explanation = '';

  final List<String> assets = ['EURUSD', 'GBPUSD', 'BTCUSD', 'ETHUSD', 'SPX', 'NAS100'];

  void fetchSignal() async {
    final url = 'http://YOUR_BACKEND_IP_OR_URL/signal/\$_selectedAsset';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _signal = data['signal'];
          _explanation = data['explanation'];
        });
      } else {
        setState(() {
          _signal = 'Error fetching signal';
          _explanation = '';
        });
      }
    } catch (e) {
      setState(() {
        _signal = 'Error connecting to backend';
        _explanation = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSignal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Binomo Signal App')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedAsset,
              items: assets.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedAsset = val!;
                  _signal = 'Loading...';
                  _explanation = '';
                });
                fetchSignal();
              },
            ),
            SizedBox(height: 30),
            Text('Signal: \$_signal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Explanation: \$_explanation'),
          ],
        ),
      ),
    );
  }
}