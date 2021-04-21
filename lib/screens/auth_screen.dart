import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState{unknown, supported, unsupported}
enum _LocalAuthState {not, ing, err, pass}
enum _FirebaseAuthState {not, int, err, pass}

class AuthScreenBuilder extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<_SupportState> supportHandler() async {
    bool isSupported = await auth.isDeviceSupported();
    if(isSupported){
      return _SupportState.supported;
    } else {
      return _SupportState.unsupported;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: supportHandler(),
        builder: (context,AsyncSnapshot<_SupportState> snapshot) {
          if(snapshot.data == _SupportState.supported){
            return AuthScreen();
          } else if(snapshot.data == _SupportState.unsupported){
            return NoSupport();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class NoSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          child: Text('No Support!'),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Text('AuthScreen')
        ],
      ),
    );
  }
}
