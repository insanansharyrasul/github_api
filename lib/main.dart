import 'package:flutter/material.dart';
import 'package:github_api/src/github_login.dart';
import 'github_oatuh_credential.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(title: 'Github Client'));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
        builder: (context, httpClient) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              elevation: 2,
            ),
            body: Center(child: Text('You are logged into Github!'),)
          );
        },
        githubClientId: githubClientId,
        githubClientSecret: githubClientSecret,
        githubScopes: githubScopes);
  }
}
