import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Verifica se o usuário está online
Future<bool> isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

// Alert caso não tenha permisão de localização
void functionPermisionDisabled(context) {
  alertaComEscolha(
      context,
      'Location Permission',
      Text(
          'Bike Trilhas collects location data to enable map tracking even when the app is closed or not in use.'),
      'CANCEL',
      () async {
        Modular.to.pushReplacementNamed('/map');
      },
      'OK',
      () async {
        Navigator.pop(context);
        LocationPermission _permissionGranted =
            await Geolocator.requestPermission();
        if (_permissionGranted != LocationPermission.denied &&
            _permissionGranted != LocationPermission.deniedForever) {
          functionPermisionEnables(context);
        } else {
          return;
        }
      });
}

// Caso tenha permisão de localização redireciona para o mapa com a posição
void functionPermisionEnables(context) async {
  await Geolocator.getCurrentPosition().then((value) {
    Modular.to.pushReplacementNamed('/map',
        arguments: CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 17));
  });
}

///Barra linear de carregamento
mostrarProgressoLinear(context, text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(text),
          content: LinearProgressIndicator(),
        ),
      );
    },
  );
}

// "true" caso o usuario concedeu algum tipo de permissão e "false" caso não
Future<bool> permissao() async {
  LocationPermission permissao = await Geolocator.checkPermission();
  if (permissao != LocationPermission.denied &&
      permissao != LocationPermission.deniedForever) {
    return true;
  } else {
    return false;
  }
}

enum EditMode { ADD, UPDATE }

///Emite um alerta do tipo snack
snackAlert(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

///Emite um alerta do tipo dialog apenas com botão de OK
alert(BuildContext context, String mensagem, String titulo) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(titulo),
          content: Text(
            mensagem,
          ),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    },
  );
}

// Emite um alerta do tipo dialog com mensagem e título customizado
alertaComEscolha(context, titulo, mensagem, String botao1text,
    Function botao1func, String botao2text, Function botao2func,
    {Color corTitulo = Colors.black}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(color: corTitulo),
          ),
          content: mensagem,
          actions: <Widget>[
            TextButton(
                child: Text(botao1text),
                onPressed: () {
                  botao1func();
                  Navigator.pop(context);
                  return;
                }),
            TextButton(
              child: Text(botao2text),
              onPressed: botao2func,
            ),
          ],
        ),
      );
    },
  );
}
