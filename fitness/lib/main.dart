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
          //the theme when changed changes globally
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
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
  var favourites = <WordPair>[];//initialized with an empty list []. The list can only contain word pairs: <WordPair>[]

  void toggleFavourite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    }else{
      favourites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) { //every widget defines a build methodthat is automatically called every time the widget's circumstances change so that it is always up to date
    

  Widget page;
  switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
      break;
    case 1:
      page = FavoritesPage(); //placeholder page
      break;
    default:
      throw UnimplementedError('no widget for $selectedIndex');
  }

// ...

    return LayoutBuilder( //helps with responsiveness
      builder: (context, constraints) {
        return Scaffold(// every build method must return a widget or a nested tree of widgets
          body: Row(
            children: [
              SafeArea(//safe area ensures the widget is not obscured by a hardware notch or a status bar
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex, //0 selects the first destination which is home
                  onDestinationSelected: (value) => { //defines what happens when a destination is selected
                    setState(() {
                      selectedIndex = value; //sets active the current page in the navigation
                    })
                  },
                ),
              ),
              Expanded(//expanded widgets take more room than the safearea
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
                ),
        
            ],
            )
            );
      }
    );
  }
}
        class GeneratorPage extends StatelessWidget{
          @override
          Widget build(BuildContext context) { //every widget defines a build methodthat is automatically called every time the widget's circumstances change so that it is always up to date
            var appState = context.watch<MyAppState>(); //MyHomePage tracks changes to the apps current state using the watch method
            var pair = appState.current;

            IconData icon;
            if (appState.favourites.contains(pair)) {
              icon = Icons.favorite;
            }else{
              icon = Icons.favorite_border;
            }
          return Center(
            child: Column(//flutter widget, takes a number of children and puts them in a column from top to bottom. The column places the children at the top by default but that can be changed. Refacto(ctrl + .) to center horizontally
            mainAxisAlignment: MainAxisAlignment.center, //centering the content along the vertical axis
            children: [
              Text('A random AWESOME idea:'),//random text 
              BigCard(pair: pair),//takes appstate, and accesses the only member of that class, current(which is a wordpair)
              SizedBox(height: 10),        
              //Adding a button
              Row(
                mainAxisSize: MainAxisSize.min,//tells the row not to take all available horizontal space
                children: [
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavourite();
                    },
                    icon: Icon(icon),
                    label: Text('Like')),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: (){
                      appState.getNext(); //calling the getnext function
                    }, child: Text('Next'),),
                  
                ],
              ),
            ],
            )
         );
          }
          
        }
      
    

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //requests the apps current theme
    final style = theme.textTheme.displayMedium!.copyWith( //theme.textTheme helps yo access the apps font theme. Copy with returns the copy of the text style with the changes you define
      color: theme.colorScheme.onPrimary, //onPrimary property defines a color that is a good fit for use on the app's primary color
    );
    return Card(
      color: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style, semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    if (appState.favourites.isEmpty){
      return Center(
        child: Text('No favorites yet'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have' '${appState.favourites.length} favorites:'),
          ),
          for (var pair in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          )
      ],
    );
  }
  
}