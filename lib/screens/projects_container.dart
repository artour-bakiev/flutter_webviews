import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectsContainer extends StatefulWidget {
  final String _baseUrl;
  final String _cookie;

  ProjectsContainer(this._baseUrl, this._cookie);

  @override
  State<StatefulWidget> createState() =>
      ProjectsContainerState(_baseUrl, _cookie);
}

class ProjectsContainerState extends State<ProjectsContainer> {
  final String _baseUrl;
  final String _cookie;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Future<List<Project>> _futureAlbums;

  ProjectsContainerState(this._baseUrl, this._cookie);

  @override
  void initState() {
    super.initState();
    _futureAlbums = _fetchAlbum(_baseUrl, _cookie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jira Flutter App'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List<Project>>(
      future: _futureAlbums,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length * 2,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                return _buildRow(snapshot.data[index]);
              });
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }

  Widget _buildRow(Project project) {
    return ListTile(
      title: Text(
        project.name,
        style: _biggerFont,
      ),
    );
  }

  Future<List<Project>> _fetchAlbum(String baseUrl, String cookie) async {
    final response = await http.get(
      baseUrl + 'rest/nativemobile/1.0/project/search',
      headers: {HttpHeaders.cookieHeader: cookie},
    );
    final responseJson = json.decode(response.body);

//    final result = List<Project>();
    final projects = ProjectsList.fromJson(responseJson);
    final List<Project> dd = projects.results;
    return dd;
//    return projects.results)
//    return result;
  }
}

class ProjectsList {
  final List<Project> results;

  ProjectsList(this.results);

  factory ProjectsList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> result = json['results'];
    final List<Project> projects = List<Project>();
    for (int n = 0; n != result.length; ++n) {
      final project = result[n];
      projects.add(Project.fromJson(project));
    }

    return ProjectsList(projects);
  }
}

class Project {
  final String name;

  Project({this.name});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(name: json['name']);
  }
}

//class Album {
//  final int userId;
//  final int id;
//  final String title;
//
//  Album({this.userId, this.id, this.title});
//
//  factory Album.fromJson(Map<String, dynamic> json) {
//    return Album(
//      userId: json['userId'],
//      id: json['id'],
//      title: json['title'],
//    );
//  }
//}
