import 'package:flutter/material.dart';
import 'acceso.dart';
import 'autenticacion.dart';
import 'db_validador.dart';


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


      Color color = Theme
        .of(context)
        .primaryColor;
    const primaryColor = Color.fromARGB(255, 91, 22, 148);


    return MaterialApp(
      title: 'App de Películas',
      home: Scaffold(
          appBar: AppBar(
            title: Text('HOME'),
            backgroundColor: primaryColor,
          ),
          body: new Stack(
            children: [
              new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("images/cinema.png"),
                    fit: BoxFit.cover,),
                ),
              ),
              new Center(
                child: new Text(
                  "Bienvenido a tu App de Películas"),
              )
            ],
          )
      ),
    );
  }
}

class Administracion extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<Administracion> createState() => _AdministracionState();
}

class EliminarPage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<EliminarPage> createState() => _EliminarPage();
}



class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _EliminarPage extends State<EliminarPage>{
  final controller = TextEditingController();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Eliminar Pelicula'),
    ),
    body: StreamBuilder<List<Movie>>(
        stream: readMovies(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Algo salio mal! ${snapshot.error}');
          }else if(snapshot.hasData){
            final movies = snapshot.data!;

            return ListView(
              children: movies.map(buildMovie).toList(),
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }),
  );

  Widget buildMovie(Movie movie) => ListTile(
    //leading: CircleAvatar(child: Text('${movie.year}')),
    leading: ConstrainedBox(
        constraints:
        BoxConstraints(minWidth: 100, minHeight: 100),
        child: Image.network(
          '${movie.imagen}',
          width: 100,
          height: 100,
        )),
    title: Text(movie.titulo),
    trailing: IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 20.0,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          FirebaseFirestore.instance
              .collection("catalogo")
              .doc('${movie.id}')
              .delete()
              .then((_) {
            print("success!");
          });
        }
        catch (e) {
          print("ERROR DURING DELETE");
        }
        //   _onDeleteItemPressed(index);
      },
    ),
  );


  Stream<List<Movie>> readMovies() => FirebaseFirestore.instance.collection('catalogo')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList());
}

class _MainPageState extends State<MainPage>{
  final controller = TextEditingController();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: Drawer(
      child: Container(
        color: Colors.black12,
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: Image.asset("images/Fondo.png"),
            ),
            const Text("Menú", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Inicio"),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Catalago Peliculas"),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Administracion(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Administración Peliculas"),
              ),
            ),
            Expanded(child: Container()),
          InkWell(
            onTap: () async {
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text("Salir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      )
    ),
    appBar: AppBar(
      title: Text('Todas las peliculas'),
    ),
    body: StreamBuilder<List<Movie>>(
      stream: readMovies(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Algo salio mal! ${snapshot.error}');
        }else if(snapshot.hasData){
          final movies = snapshot.data!;

          return ListView(
            children: movies.map(buildMovie).toList(),
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }),
  );

  Widget buildMovie(Movie movie) => ListTile(
    //leading: CircleAvatar(child: Text('${movie.year}')),
    leading: ConstrainedBox(
        constraints:
        BoxConstraints(minWidth: 100, minHeight: 100),
        child: Image.network(
          '${movie.imagen}',
          width: 100,
          height: 100,
        )),
    title: Text(movie.titulo),
    subtitle: Text(movie.descripcion),
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetail(
          movie: movie,
        ),
      ),
    ),
  );


  Stream<List<Movie>> readMovies() => FirebaseFirestore.instance.collection('catalogo')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList());
}

class MovieDetail extends StatelessWidget {
  final Movie movie;

  MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(movie.titulo),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: new Image.network(
                          "${movie.portada}",
                          height: 250.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text("Año"),
                        subtitle: Text("${movie.ano}"),
                      ),
                      ListTile(
                        title: Text("Director"),
                        subtitle: Text("${movie.director}"),
                      ),
                      ListTile(
                        title: Text("Genero"),
                        subtitle: Text(movie.genero),
                      ),
                      ListTile(
                        title: Text("Sinopsis"),
                        subtitle: Text("${movie.descripcion}"),
                      ),
                      ListTile(
                        title: Text("Genero"),
                        subtitle: Text("${movie.genero}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class MoviePage extends StatefulWidget {
  //const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>{
  final controllerTitulo = TextEditingController();
  final controllerYear = TextEditingController();
  final controllerDescripcion = TextEditingController();
  final controllerGenero = TextEditingController();
  final controllerDirector = TextEditingController();
  final controllerImagen = TextEditingController();
@override
Widget build (BuildContext context) => Scaffold(
appBar: AppBar(
title: Text('Agregar Película'),
) ,
body: ListView(
padding: EdgeInsets.all(16),
children: <Widget>[
TextField(
controller: controllerTitulo,
decoration: decoration('Titulo'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerYear,
decoration: decoration('Año'),
keyboardType: TextInputType.number,
),
const SizedBox(height: 24),
TextField(
  controller: controllerDescripcion,
decoration: decoration('Director'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerGenero,
decoration: decoration('Género'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerDirector,
decoration: decoration('Sinopsis'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerImagen,
decoration: decoration('Portada URL'),
),
  const SizedBox(height: 32),
  ElevatedButton(
    child: Text('Añadir'),
    onPressed: (){
      final movie = Movie(
        titulo: controllerTitulo.text,
        ano: int.parse(controllerYear.text),
        direc: controllerDescripcion.text,
        genero: controllerGenero.text,
        sinopsis: controllerDirector.text,
        imagen: controllerImagen.text,
      );

      createMovie(movie);

      Navigator.pop(context);
    },
  )
],
),
);

InputDecoration decoration(String label) => InputDecoration(
labelText: label,
border: OutlineInputBorder(),
);

  Future createMovie(Movie movie) async {
    final docMovie = FirebaseFirestore.instance.collection('catalogo').doc();
    movie.id = docMovie.id;

    final json = movie.toJson();

    await docMovie.set(json);
  }

}
_signOut() async {
  await _firebaseAuth.signOut();
}

class _AdministracionState extends State<Administracion> {

  @override
  Widget build (BuildContext context) => Scaffold(
      body: new Stack(
        children: [
          SizedBox(width: 30),
          Container(
            width: 200,
            height: 35,
            margin: const EdgeInsets.only(top: 300, left: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoviePage(),));
              },
              child: Text(
                'Añadir nueva película',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 50,
            margin: const EdgeInsets.only(top: 300, left: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EliminarPage(),));
              },
              child: Text(
                'Borrar película',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      )
  );
//);
}
  
class Movie {
  String id;
  final String titulo;
  final int ano;
  final String direc;
  final String sinopsis;
  final String genero;
  final String imagen;

  Movie({
    this.id = '',
    required this.titulo,
    required this.ano,
    required this.direc,
    required this.genero,
    required this.sinopsis,
    required this.imagen,
  });

  Map<String, dynamic> toJson() =>
      {
        'ID': id,
        'Título': titulo,
        'Año': ano,
        'Director': direc,
        'Género': genero,
        'Sinopsis': sinopsis,
        'Portada': imagen,
      };

      static Movie fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        titulo: json['titulo'],
        ano: json['year'],
        direc: json['director'],
        genero: json['genero'],
        sinopsis: json['sinopsis'],
        imagen: json['portada'],
      );
}