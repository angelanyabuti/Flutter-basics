import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//main() function it tells Flutter to run the app defined in MyApp
void main() {
  runApp(MyApp());
}

// This code in MyApp sets up the whole app.  creates the app-wide state, names the app, defines the visual theme and sets the "home" widget - the starting of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//defines the app's well state
//defines the data the app needs to function
//the state can notify others about its own changes eg if the current word pair changes, some widgets in the app need to know
//The state is provided to the whole app using a ChangeNotifierProvider(in MyApp) This allows any widget to get hold of the state
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  //Added
  //reassigns current a new random wordpair
  //calls notifyListeners, a method of ChangeNotifier that anyone watching MyAppState is notified
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //every widget defines a build methodthat is automatically called every time the widget's circumstances change so that it is always up to date
    var appState = context.watch<MyAppState>(); //MyHomePage tracks changes to the apps current state using the watch method

    return Scaffold(// every build method must return a widget or a nested tree of widgets
      body: Column(//flutter widget, takes a number of children and puts them in a column from top to bottom. The column places the children at the top by default but that can be changed
        children: [
          Text('A random AWESOME idea:'),//random text 
          Text(appState.current.asCamelCase),//takes appstate, and accesses the only member of that class, current(which is a wordpair)

          //Adding a button
          ElevatedButton(
            onPressed: (){
              appState.getNext(); //calling the getnext function
            }, child: Text('Next'),),
        ],
      ),
    );
  }
}