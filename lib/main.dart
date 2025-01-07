import 'package:flutter/material.dart';
import 'package:github_api/src/github_login.dart';
import 'github_oatuh_credential.dart';
import 'package:github/github.dart';

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
        return FutureBuilder<CurrentUser>(
          future: viewerDetail(httpClient.credentials.accessToken),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                elevation: 2,
              ),
              body: Center(
                child: Text(snapshot.hasData
                    ? 'Hello ${snapshot.data!.login}'
                    : 'Retrieving viewer login details'),
              ),
            );
          },
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}

Future<CurrentUser> viewerDetail(String accessToken) async {
  final github = GitHub(auth: Authentication.withToken(accessToken));
  return github.users.getCurrentUser();
}
