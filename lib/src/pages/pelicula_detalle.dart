import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';


class DetallePeliculaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                _posterTitulo(pelicula, context),
                _descripcion(pelicula, context),
                _crearCasting(pelicula)
              ]
            )
          )
        ],
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(pelicula.getBackdropImg()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Hero(
            transitionOnUserGestures: true,
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 10.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6,),
                SizedBox(height: 10.0,),
                Text('Nombre Original: ${pelicula.originalTitle}', style: Theme.of(context).textTheme.subtitle2,),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Text('Puntuación: '),
                    Icon(Icons.star, color: Colors.yellow, size: 24.0,),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1,)
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula, context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sinopsis',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 10.0),
          Text(
            pelicula.overview,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20.0,),
          Text(
            'Reparto',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculaProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliculaProvider.getCasting(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemBuilder: (context, i) {
          return _actorCard(actores[i], context);
        },
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
      ),
    );
  }

  Widget _actorCard(Actor actor, context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/loading.gif'), 
              image: NetworkImage(actor.getActorPhoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            actor.name,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }


}