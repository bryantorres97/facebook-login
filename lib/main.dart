import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loggedIn = false;

  AccessToken? _accessToken;
  UserModel? _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Facebook Login"),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      )),
    );
  }

  Widget _buildWidget() {
    UserModel? user = _currentUser;
    if (user != null) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: user.pictureModel!.width / 6,
                backgroundImage: NetworkImage(user.pictureModel!.url!),
              ),
              title: Text(user.name!),
              subtitle: Text(user.email!),
            ),
            const SizedBox(height: 20),
            const Text('Inicio de sesión correcto',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Cerrar sesión'))
          ]));
    } else {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Aún no has iniciado sesión",
                style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: signIn, child: const Text('Iniciar sesión'))
          ],
        ),
      );
    }
  }

  Future<void> signIn() async {
    final result = await FacebookAuth.i.login();
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final data = await FacebookAuth.i.getUserData();
      UserModel model = UserModel.fromJson(data);

      _currentUser = model;

      setState(() {});
    }
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final PictureModel? pictureModel;

  UserModel(this.id, this.name, this.email, this.pictureModel);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        json['id'] as String,
        json['name'] as String,
        json['email'] as String,
        PictureModel.fromJson(json['picture']['data']));
  }
}

class PictureModel {
  final String? url;
  final int width;
  final int height;

  const PictureModel({required this.width, required this.height, this.url});

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
    );
  }
}
