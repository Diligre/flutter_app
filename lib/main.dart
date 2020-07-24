import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'dart:convert';

import 'Project.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      drawer: DrawerMain(selected: "Main"),
      body: Center(
        child: Text(
          'Main',
        ),
      ),
    );
  }
}

class DrawerMain extends StatefulWidget {
  DrawerMain({Key key, this.selected}) : super(key: key);

  final String selected;

  @override
  DrawerMainState createState() {
    return DrawerMainState();
  }
}

class DrawerMainState extends State<DrawerMain> {
  @override
  Widget build (BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Flutter demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                selected: widget.selected == 'main',
                leading: Icon(Icons.info),
                title: Text('Main'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
              ),
              ListTile(
                selected: widget.selected == 'projects',
                leading: Icon(Icons.list),
                title: Text('projects'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectsPage()),
                  );
                },
              ),
            ]
        )
    );
  }
}

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Project> list = List();
  bool flag = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future _fetchData() async {

//  list.sort();
//  list.retainWhere();
    var response = await http.get(
        "https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0",
        headers: {
          HttpHeaders.authorizationHeader:
          "896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043"
        });
    if (response.statusCode == 200) {
      setState(() {
        list = (json.decode(response.body) as List)
            .map((data) => new Project.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load projects');
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){  _refreshIndicatorKey.currentState?.show(); });
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('projects'),
      ),
      drawer: DrawerMain(selected: "projects"),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _fetchData,
          child: Column(
            children: <Widget>[


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              Expanded(

                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {

                    return Card(
                      child: new InkWell(
                      child: Container(

                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[

                            Image.network(
                              list[index].small,
                              fit: BoxFit.fitHeight,
                              width: 500.0,
                              height: 240.0,
                            ),
                            Text(
                              list[index].name,
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),

                            ),
                            Text(
                              list[index].description,
                              style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                        onTap: (){
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) => DetailPage(list[index]))
                          );
                      },
                      )
                    );
                  },
                ),
              )

            ],
          )
      ),

    );

  }
}

class DetailPage extends StatelessWidget {

  final Project project;

  DetailPage(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(project.name),
        ),body:
        SizedBox.expand(
          child:
    Image.network(
      project.full,
      fit: BoxFit.fill,
    ) ,
        ),
    );
  }
}