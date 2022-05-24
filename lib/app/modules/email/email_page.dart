import 'package:biketrilhas_modular/app/modules/email/email_user.dart';
import 'package:biketrilhas_modular/app/modules/login/login_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  final String title;
  
  const EmailPage({Key key, this.title = 'Login'}) : super(key: key);
  
  @override
  EmailPageState createState() => EmailPageState();
}
class EmailPageState extends State<EmailPage> {
  final loading = ValueNotifier<bool>(false);
  //final EmailoginStore store = Modular.get();
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthController auth;
  final logcontroller = Modular.get<LoginController>();
  //AuthService authserv;
  final authenticator = Modular.get<AuthController>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController(); 
  String email;
  AuthRepository authRep;

  bool isLogin = true;
  
  Widget userInput(TextEditingController userInput, String hintTitle, TextInputType keyboardType, bool check) {
    return Container(
      
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25),
        child: TextField(
          
          autofocus: true,
          obscureText: check,
          controller: userInput,
          decoration: InputDecoration(
            hintText: hintTitle,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.normal),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

login(EmailUser usuario)async {
  try{
    await authenticator.loginWithEmail(usuario);
    Navigator.pop(context);
    await logcontroller.loginWithEmail(context, usuario);
     loading.value = false;
  }on AuthException catch (e){
      _Warnings(e.message);
      Navigator.pop(context);
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      loading.value = false;
  }
}

showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

Future<void> _Warnings(String mensagem) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Ocorreu um erro"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(mensagem)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Senha Inválida'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('A senha deve conter no mínimo 6 caracteres.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: true,
      body: Center(
        child:SingleChildScrollView(
        //color: Colors.blue[700],    
        padding: EdgeInsets.all(32.0),   
        child: Column(        
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 100),
            Image.asset('images/icon.png'),
            SizedBox(height: 30),
            Image.asset('images/bike_logo_actionbar.png'),
            SizedBox(height: 0),
        Container(
          
          height: 510,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 45),
                //userInput(nameController, 'Nome', TextInputType.name, false),
                userInput(emailController, 'Email', TextInputType.emailAddress, false),
                userInput(senhaController, 'Senha',TextInputType.visiblePassword, true),
            Container(
              height: 55,
              // for an exact replicate, remove the padding.
              // pour une réplique exact, enlever le padding.
              padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                color: Colors.indigo.shade800,
                onPressed: () async { 
                  showLoaderDialog(context);
                  EmailUser user = new EmailUser(1, emailController.text, nameController.text, senhaController.text);
                  login(user); 
                },
                child: AnimatedBuilder(
                  animation: loading,
                  builder: (context, _) {
                     return loading.value
                    ? const SizedBox(width: 21,height: 20,child: CircularProgressIndicator(),)
                    :Text('Entrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),);
                  }
                ),
                ),
                
              ),
              Container(
              height: 55,
              // for an exact replicate, remove the padding.
              // pour une réplique exact, enlever le padding.
              padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                color: Colors.indigo.shade800,
                onPressed: () async {                 
                  Modular.to.pushNamed('/emailregister');
                },
                child: Text('Cadastre-se', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
                ),
                
              ),
                SizedBox(height: 20),

                Divider(thickness: 0, color: Colors.white),

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