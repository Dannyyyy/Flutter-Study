import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

const jokesApi = "https://icanhazdadjoke.com/";

const httpHeaders = const {
  'Accept': 'application/json'
};

class JokesPage extends StatefulWidget {
  JokesPage({Key key}) : super(key: key);

  @override
  createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage>
{
  Future<http.Response> _jokeResponse;

  @override
  initState() {
    super.initState();
    _refreshAction();
  }

  Future<void> _refreshAction() async {
    setState(() {
      _jokeResponse = http.get(jokesApi, headers: httpHeaders);
    });
  }

  FutureBuilder<http.Response> _jokeBody() {
    return FutureBuilder<http.Response>(
      future: _jokeResponse,
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const ListTile(
              leading: Icon(Icons.sync_problem),
              title: Text('No connection'),
            );
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Center(
                child: ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Network error'),
                  subtitle: Text(
                      'Check your network connection and try again.'),
                ),
              );
            } else {
              final decoded = json.decode(snapshot.data.body);
              if (decoded['status'] == 200) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Dismissible(
                      key: const Key("joke"),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        _refreshAction();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: AutoSizeText(decoded['joke'])
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            width: 3.0,
                          ),
                        ),
                      )
                    ));
              } else {
                return ListTile(
                  leading: const Icon(Icons.sync_problem),
                  title: Text('Unexpected error: ${snapshot.data}'),
                );
              }
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jokes"),
      ),
      body: Container(child: Center(child: _jokeBody())),
      floatingActionButton: FloatingActionButton(onPressed: _refreshAction, child: Icon(Icons.refresh),),
    );
  }
}