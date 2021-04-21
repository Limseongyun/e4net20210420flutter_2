import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState{unknown, supported, unsupported}
enum _LocalAuthState {not, ing, err, pass}
enum _FirebaseAuthState {not, ing, err, pass}

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
  final LocalAuthentication auth = LocalAuthentication();
  _LocalAuthState _localAuthState = _LocalAuthState.not;
  _FirebaseAuthState _firebaseAuthState = _FirebaseAuthState.not;
  int ignoreLocalAuth = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, 0.8),
            child: InkWell(
              onLongPress: () {
                print('local - Auth - Start');
              },
              child: Icon(
                Icons.fingerprint,
                size:  100,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(_localAuthState == _LocalAuthState.pass)
                Text('로컬 인증 성공!')
                else if(_localAuthState == _LocalAuthState.not)
                Text('인증을 진행해 주세요')
                else if(_localAuthState == _LocalAuthState.err)
                Text('LocalAuthErr.')
                else if(_localAuthState == _LocalAuthState.ing)
                Text('로컬 인증 중...'),

                if(_firebaseAuthState == _FirebaseAuthState.pass)
                Text('파이어 베이스 인증 성공!')
                else if(_firebaseAuthState == _FirebaseAuthState.ing)
                Text('파이어 베이스 인증 중!')
              ],
            ),
          )
        ],
      ),
    );
  }
}
