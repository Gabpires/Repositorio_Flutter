import 'package:geolocator/geolocator.dart';

class ServicoGps {
  static Future<Position> obterPosicaoAtual() async {
    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      throw Exception('Ative o GPS do dispositivo');
    }

    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.medium, //precisão
      ),
    );
  }
}
