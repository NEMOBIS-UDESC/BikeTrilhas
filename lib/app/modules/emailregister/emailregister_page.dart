import 'package:biketrilhas_modular/app/modules/email/email_user.dart';
import 'package:biketrilhas_modular/app/modules/login/login_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class EmailregisterPage extends StatefulWidget {
  final String title;
  
  const EmailregisterPage({Key key, this.title = 'Login'}) : super(key: key);
  
  @override
  EmailregisterPageState createState() => EmailregisterPageState();
}
class EmailregisterPageState extends State<EmailregisterPage> {
  final loading = ValueNotifier<bool>(false);
  final buttonController = true;
  //final EmailoginStore store = Modular.get();
  AuthController auth;
  final logcontroller = Modular.get<LoginController>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController(); 
  final authenticator = Modular.get<AuthController>();
  String email;
  AuthRepository authRep;
  bool isLogin = true;
  
  login(EmailUser usuario)async {
  try{
    await authenticator.loginWithEmail(usuario);
    loading.value = false;
    Navigator.pop(context);
    _showMyDialog();
  }on AuthException catch (e){
    loading.value = false;
    Navigator.pop(context);
    _Warnings(e.message);
     //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
  }
}

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
        title: const Text('Usuário cadastrado'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Retorne para a Pagina de Login.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(Modular.to.pushNamed('/email'));
            },
          ),
        ],
      );
    },
  );
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

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20),
            Image.asset('images/icon.png'),
            SizedBox(height: 10),
            Image.asset('images/bike_logo_actionbar.png'),
            SizedBox(height: 50),
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
                userInput(nameController, 'Nome', TextInputType.name, false),
                userInput(emailController, 'Email', TextInputType.emailAddress, false),
                userInput(senhaController, 'Senha',TextInputType.visiblePassword, true),
            Container(
              // for an exact replicate, remove the padding.
              // pour une réplique exact, enlever le padding.
              padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
              // child: RaisedButton(
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              //   color: Colors.indigo.shade800,
              //   onPressed: () async {
                  
              //     EmailUser user = new EmailUser(1, emailController.text, nameController.text, senhaController.text);
              //     logcontroller.user = user;
              //     print(user.email);
              //     logcontroller.loginWithEmail(context);
                  
              //   },
              //   child: Text('Entrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
              //   ),
                
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
                  showLoaderDialog(context);
                  loading.value = !loading.value;
                  EmailUser user = new EmailUser(0, emailController.text, nameController.text, senhaController.text);
                  logcontroller.user = user;
                  login(user);
                },
                child: AnimatedBuilder(    
                  animation: loading,     
                  builder: (context,_ ) {
                    return loading.value
                    ? const SizedBox(width: 21,height: 20,child: CircularProgressIndicator(),)
                    :const Text('Cadastrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),);
                  }
                ),
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