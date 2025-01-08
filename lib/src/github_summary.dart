import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GithubSummary extends StatefulWidget {
  final GitHub gitHub;
  const GithubSummary({super.key, required this.gitHub});

  @override
  State<GithubSummary> createState() => _GithubSummaryState();
}

class _GithubSummaryState extends State<GithubSummary> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          onDestinationSelected: (index) {
            _selectedIndex = index;
          },
          labelType: NavigationRailLabelType.selected,
          selectedIndex: _selectedIndex,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Octicons.repo),
              label: Text('Repositories'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.issue_opened),
              label: Text('Assigned Issues'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.git_pull_request),
              label: Text('Pull Request'),
            ),
          ],
        ),
        VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              RepositoriesList(gitHub: widget.gitHub),
              AssignedIssues(gitHub: widget.gitHub),
            ],
          ),
        )
      ],
    );
  }
}

class RepositoriesList extends StatefulWidget {
  final GitHub gitHub;
  const RepositoriesList({super.key, required this.gitHub});

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  @override
  initState() {
    _repositories = widget.gitHub.repositories.listRepositories().toList();
    super.initState();
  }

  late Future<List<Repository>> _repositories;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Repository>>(
        future: _repositories,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var repositories = snapshot.data;
          return ListView.builder(
            primary: false,
            itemBuilder: (context, index) {
              var repository = repositories[index];
              return ListTile(
                title: Text(
                    '${repository.owner?.login ?? ''}/${repository.name} '),
                subtitle: Text(repository.description),
                onTap: () => _launchUrl(this, repository.htmlUrl),
              );
            },
            itemCount: repositories!.length,
          );
        });
  }
}

Future<void> _launchUrl(State state, String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    if (state.mounted) {
      return showDialog(
        context: state.context,
        builder: (context) => AlertDialog(
          title: const Text('Navigation error'),
          content: Text('Could not launch $url'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
