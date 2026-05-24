import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'servico_gps.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  LatLng? _minhaPosicao;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPosicao();
  }

  Future<void> _carregarPosicao() async {
    try {
      final posicao = await ServicoGps.obterPosicaoAtual();
      setState(() {
        _minhaPosicao = LatLng(posicao.latitude, posicao.longitude);
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mapa')),
        body: Center(child: Text(_erro!)),
      );
    }

    if (_minhaPosicao == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Minha Localização')),
      body: FlutterMap(
        options: MapOptions(initialCenter: _minhaPosicao!, initialZoom: 16),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.exemplo.localizacao',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _minhaPosicao!,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_pin, 
                  size: 40, 
                  color: Colors.red
                  ),
              ),
            ],
          ),
          RichAttributionWidget(attributions: [
            TextSourceAttribution('OpenStreetMap contributors'),
          ])
        ],
      ),
    );
  }
}
