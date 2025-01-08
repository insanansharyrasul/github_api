import 'package:flutter/material.dart';
import 'package:github_api/src/github_login.dart';
import 'package:github_api/src/github_summary.dart';
import 'github_oatuh_credential.dart';
import 'package:github/github.dart';
import 'package:window_to_front/window_to_front.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Github Client'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      builder: (context, httpClient) {
        WindowToFront.activate();
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            elevation: 2,
          ),
          body: GithubSummary(
            gitHub: _getGitHub(httpClient.credentials.accessToken),
          ),
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}

GitHub _getGitHub(String accessToken) {
  return GitHub(auth: Authentication.withToken(accessToken));
}
