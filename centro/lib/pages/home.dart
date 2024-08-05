import 'package:centro/widgets/base_page.dart';
import 'package:centro/widgets/visita_card.dart';
import 'package:flutter/material.dart';
import 'package:centro/services/api_service.dart';
import 'package:centro/sesion.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> futureVisitas;

  @override
  void initState() {
    super.initState();
    futureVisitas = ApiService().getSituaciones(SesionActual.token);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Visitas Realizadas',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: futureVisitas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay visitas registradas.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final visita = snapshot.data![index];
                  return VisitaCard(
                    codigoCentro: visita['codigo_centro'],
                    motivo: visita['motivo'],
                    fecha: visita['fecha'],
                    hora: visita['hora'],
                    onTap: () {
                      // ToDo
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
