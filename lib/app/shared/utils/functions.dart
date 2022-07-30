import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Verifica se o usuário está com internet habilitada
Future<bool> isOnline() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

// Verica se o usuario está com a localização habilitada
Future<bool> isLocationEnabled() async {
  return await Geolocator.isLocationServiceEnabled();
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
        await Modular.to.pushReplacementNamed('/map/');
      },
      'OK',
      () async {
        Navigator.pop(context);
        await Geolocator.requestPermission();
        if (await isPermisionEnabled()) {
          functionPermisionEnabled(context);
        } else {
          return;
        }
      });
}

// Caso tenha permisão de localização redireciona para o mapa com a posição
void functionPermisionEnabled(context) async {
  await Geolocator.getCurrentPosition().then((value) async {
    await Modular.to.pushReplacementNamed('/map/',
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

// Verica se o usuario está permitindo uso da localização
Future<bool> isPermisionEnabled() async {
  LocationPermission location = await Geolocator.checkPermission();
  if (location == LocationPermission.denied ||
      location == LocationPermission.deniedForever) {
    return false;
  } else {
    return true;
  }
}

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

enum EditMode { ADD, UPDATE }
