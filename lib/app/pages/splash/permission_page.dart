import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

import '../../shared/utils/breakpoints.dart';

class PermissionPage extends StatefulWidget {
  final String title;
  const PermissionPage({Key key, this.title = "Permission"}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    disposer = autorun((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Configurações',
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isTablet = shortestSide > MOBILE_BREAKPOINT;
    return Center(
      child: Container(
        padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
        margin: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 3), blurRadius: 5)
          ],
        ),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: isTablet ? 650 : 600, maxHeight: isTablet ? 1000 : 630),
          child: Column(
            children: [
              Image.asset(
                "images/about_logo.png",
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Condições de Permissão',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'BikeTrilhas utiliza o serviço de localização para acompanhar em tempo real a geolocalização do usuário com o objetivo de localiza-lo na trilha.',
                //s, facilitando a compreensão.\nOs dados de geolocalização só serão armazenados caso o usuário crie um novo waypoint ou uma nova trilha, ciclovia e cicloturismo
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 0,
                  side: BorderSide(color: Colors.black),
                ),
                onPressed: () async {
                  LocationPermission _permissionGranted =
                      await Geolocator.requestPermission();
                  if (_permissionGranted != LocationPermission.denied &&
                      _permissionGranted != LocationPermission.deniedForever) {
                    functionPermisionEnables(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Ativar Permissão',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
