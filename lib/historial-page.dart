import 'package:flutter/material.dart';import 'navside.dart';import 'auth.dart';import 'chart.dart';import 'package:cloud_firestore/cloud_firestore.dart';import 'package:flutter/rendering.dart';class GraficoFn {  final num year;  final num sales;  GraficoFn(this.year, this.sales);}class HistorialPage extends StatefulWidget {  HistorialPage({this.auth, this.onCerrarSesion});  final BaseAuth auth;  final VoidCallback onCerrarSesion;  final CollectionReference fs = Firestore.instance      .collection('Piscis')      .document('Historial')      .collection('Sensores');  int ano = null;  String mes = null;  int dia = null;  bool EliminarFiltros = false;  bool anoChart = false;  bool mesChart = false;  bool diaChart = false;  bool eliminarTodoFiltrado = false;  var datos;  QuerySnapshot snapshot;  @override  _HistorialPageState createState() => _HistorialPageState();}class _HistorialPageState extends State<HistorialPage> {  Widget EliminarFiltros() {    if (this.widget.EliminarFiltros) {      return RaisedButton(        color: Colors.redAccent,        child: Text(          'Eliminar Filtros',          style: TextStyle(color: Colors.white),        ),        onPressed: () {          this.widget.ano = null;          this.widget.mes = null;          this.widget.dia = null;          this.widget.EliminarFiltros = false;          this.widget.anoChart = false;          this.widget.mesChart = false;          this.widget.diaChart = false;          setState(() {});        },        elevation: 10.0,      );    }  }  List<DocumentSnapshot> EliminarTodoFn(QuerySnapshot snapshot) {    snapshot.documents.forEach((DocumentSnapshot document) {      document.reference.delete();    });  }  Widget EliminarTodoFiltrado() {    if (this.widget.diaChart || this.widget.anoChart || this.widget.mesChart) {      this.widget.eliminarTodoFiltrado = true;      return StreamBuilder(          stream: this              .widget              .fs              .where('Año', isEqualTo: this.widget.ano)              .where('Mes', isEqualTo: this.widget.mes)              .where('Dia', isEqualTo: this.widget.dia)              .snapshots(),          builder:              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {            if (!snapshot.hasData) return Text('');            if (snapshot.data.documents.length == 0) return new Text('');            return GestureDetector(              child: CircleAvatar(                backgroundColor: Colors.red,                child: Icon(                  Icons.delete,                  color: Colors.white,                ),              ),              onTap: () {                showModalBottomSheet(                    context: context,                    builder: (builder) {                      return new Container(                          color: Colors.redAccent,                          child: Stack(                            children: <Widget>[                              Padding(                                padding: const EdgeInsets.only(top: 10.0),                                child: Text(                                  '¿Esta Seguro que Deseas Eliminar  ${snapshot.data.documents.length} Documentos?',                                  textAlign: TextAlign.center,                                  style: TextStyle(color: Colors.white),                                ),                              ),                              Center(                                  child: Column(                                mainAxisAlignment: MainAxisAlignment.center,                                children: <Widget>[                                  Column(                                    children: <Widget>[                                      GestureDetector(                                        child: CircleAvatar(                                          backgroundColor: Colors.white,                                          radius: 30.0,                                          child: Icon(                                            Icons.delete,                                            color: Colors.red,                                            size: 30.0,                                          ),                                        ),                                        onTap: () {                                          EliminarTodoFn(snapshot.data);                                          Navigator.pop(context);                                        },                                      )                                    ],                                  ),                                  Column(                                    children: <Widget>[                                      Text(                                        'Eliminar',                                        textAlign: TextAlign.center,                                        style: TextStyle(                                            color: Colors.white,                                            fontWeight: FontWeight.bold),                                      )                                    ],                                  )                                ],                              )),                              Center(                                child: Column(                                  mainAxisAlignment: MainAxisAlignment.end,                                  children: <Widget>[                                    Padding(                                      padding: const EdgeInsets.all(8.0),                                      child: RaisedButton(                                        elevation: 10.0,                                        color: Colors.red,                                        child: Text(                                          'Cancelar',                                          style: TextStyle(color: Colors.white),                                        ),                                        onPressed: () => Navigator.pop(context),                                      ),                                    )                                  ],                                ),                              )                            ],                          ));                    });                this.widget.eliminarTodoFiltrado = false;              },            );          });    }  }  Widget MostrarGrafico() {    if (this.widget.diaChart && this.widget.anoChart && this.widget.mesChart) {      return GestureDetector(        child: CircleAvatar(          backgroundColor: Colors.amber,          child: Icon(            Icons.show_chart,            color: Colors.white,          ),        ),        onTap: () {          print('me has tocado');          Navigator.push(              context,              MaterialPageRoute(                  builder: (context) => DocumentChart(                        ano: this.widget.ano,                        mes: this.widget.mes,                        dia: this.widget.dia,                      )));          /*return StreamBuilder(            stream: this                .widget                .fs                .where("Año", isEqualTo: this.widget.ano)                .where('Mes', isEqualTo: this.widget.mes)                .where('Dia', isEqualTo: this.widget.dia)                .snapshots(),            builder:                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {              Navigator.push(                  context,                  MaterialPageRoute(                      builder: (context) => DocumentChart(                            snapshot: snapshot,                          )));            },          );*/        },      );    }  }  /*Widget bodyData() => DataTable(        onSelectAll: (b) {},        sortColumnIndex: 0,        sortAscending: true,        columns: <DataColumn>[          DataColumn(            label: Text("ID"),            numeric: false,            onSort: (i, b) {              print('$i $b');              setState(() {                names.sort((a, b) => a.firstName.compareTo(b.firstName));              });            },            tooltip: "El identificador Unico del dato",          ),          DataColumn(              label: Text("Valor"),              numeric: false,              onSort: (i, b) {},              tooltip: "El valor promedio de la temperatura"),        ],        rows: names            .map((name) => DataRow(cells: [                  DataCell(Text(name.firstName)),                  DataCell(Text(name.lastName)),                ]))            .toList(),      );*/  @override  Widget build(BuildContext context) {    double maxWidth = MediaQuery.of(context).size.width * 0.7;    return Scaffold(        appBar: new AppBar(            elevation: 10.0,            title: Text(              'Historial',              style: new TextStyle(fontFamily: 'Nunito'),            ),            backgroundColor: Colors.deepPurple),        drawer: new SideNav(          auth: this.widget.auth,          onCerrarSesion: this.widget.onCerrarSesion,        ),        body: ListView(          children: <Widget>[            Column(              mainAxisAlignment: MainAxisAlignment.start,              children: <Widget>[                Padding(                  padding: const EdgeInsets.all(20.0),                  child: Card(                    elevation: 5.0,                    child: Padding(                      padding: const EdgeInsets.all(20.0),                      child: ConstrainedBox(                        constraints: BoxConstraints(maxWidth: maxWidth),                        child: Wrap(                          alignment: WrapAlignment.center,                          children: <Widget>[                            Column(                              mainAxisAlignment: MainAxisAlignment.center,                              children: <Widget>[                                Text(                                  'Filtrar Datos por',                                  textAlign: TextAlign.center,                                  style: TextStyle(                                      color: Colors.indigo,                                      fontSize: 30.0,                                      fontFamily: 'Nunito'),                                ),                              ],                            ),                            Padding(                              padding: const EdgeInsets.only(                                  top: 20.0, bottom: 20.0),                              child: Row(                                mainAxisAlignment: MainAxisAlignment.center,                                children: <Widget>[                                  new DropdownButtonHideUnderline(                                    child: new DropdownButton<int>(                                      hint: new Text('Año'),                                      value: this.widget.ano,                                      items: anos                                          .map((ano) => DropdownMenuItem<int>(                                                value: ano.ano,                                                child: Text(ano.ano.toString()),                                              ))                                          .toList(),                                      onChanged: (int value) {                                        this.widget.EliminarFiltros = true;                                        this.widget.anoChart = true;                                        print(value);                                        this.widget.ano = value;                                        setState(() {});                                      },                                    ),                                  ),                                  new DropdownButtonHideUnderline(                                    child: new DropdownButton<String>(                                      hint: new Text('Mes'),                                      value: this.widget.mes,                                      items: meses                                          .map((mes) => DropdownMenuItem(                                                value: mes.mes,                                                child: Text(mes.mes),                                              ))                                          .toList(),                                      onChanged: (String value) {                                        this.widget.EliminarFiltros = true;                                        this.widget.mesChart = true;                                        print(value);                                        this.setState(() {                                          this.widget.mes = value;                                        });                                      },                                    ),                                  ),                                  new DropdownButtonHideUnderline(                                    child: new DropdownButton<int>(                                      hint: new Text('Dia'),                                      value: this.widget.dia,                                      items: dias                                          .map((dia) => DropdownMenuItem<int>(                                                value: dia.dia,                                                child: Text(dia.dia.toString()),                                              ))                                          .toList(),                                      onChanged: (int value) {                                        this.widget.EliminarFiltros = true;                                        this.widget.diaChart = true;                                        print(value);                                        setState(() => this.widget.dia = value);                                      },                                    ),                                  ),                                ],                              ),                            ),                            Row(                              mainAxisAlignment: MainAxisAlignment.center,                              children: <Widget>[                                Padding(                                    padding: const EdgeInsets.all(8.0),                                    child: EliminarFiltros()),                              ],                            ),                            Row(                                mainAxisAlignment: MainAxisAlignment.end,                                crossAxisAlignment: CrossAxisAlignment.end,                                children: <Widget>[                                  Padding(                                    padding: const EdgeInsets.all(8.0),                                    child: MostrarGrafico(),                                  ),                                  Padding(                                    padding: const EdgeInsets.all(8.0),                                    child: EliminarTodoFiltrado(),                                  )                                ])                          ],                        ),                      ),                    ),                  ),                )              ],            ),            /*new Column(          mainAxisAlignment: MainAxisAlignment.start,        children: <Widget>[          new Card(          elevation: 5.0,          margin: EdgeInsets.only(top: 20.0,left:3.0,right:3.0,bottom: 20.0),          child: new Column(            mainAxisSize: MainAxisSize.min,            children: <Widget>[              Text(                  'Filtrar Datos por',                  textAlign: TextAlign.center,                  style: TextStyle(                      color: Colors.indigo,                      fontSize: 30.0,                      fontFamily: 'Nunito'),                ),              Padding(                padding: const EdgeInsets.all(10.0),                child: Row(                  mainAxisSize: MainAxisSize.max,                  children: <Widget>[                    Expanded(                      flex: 1,                        child: new DropdownButtonHideUnderline(                          child: new DropdownButton<int>(                            hint: new Text('Año'),                            value: this.widget.ano,                            items: anos.map((ano)=>DropdownMenuItem<int>(                              value: ano.ano,                              child: Text(ano.ano.toString()),                            )).toList(),                            onChanged: (int value) {                              print(value);                              this.widget.ano = value;                              setState((){});                            },                          ),                        ),                    ),                    Expanded(                      flex: 1,                        child: new DropdownButtonHideUnderline(                          child: new DropdownButton<String>(                            hint: new Text('Mes'),                            value: this.widget.mes,                            items: meses.map((mes)=>DropdownMenuItem(                              value: mes.mes,                              child: Text(mes.mes),                            )).toList(),                            onChanged: (String value) {                              print(value);                              this.setState((){this.widget.mes = value;});                            },                          ),                        ),                    ),                    Expanded(                      flex: 1,                        child: new DropdownButtonHideUnderline(                          child: new DropdownButton<int>(                            hint: new Text('Dia'),                            value: this.widget.dia,                            items: dias.map((dia)=>DropdownMenuItem<int>(                              value: dia.dia,                              child: Text(dia.dia.toString()),                            )).toList(),                            onChanged: (int value) {                              print(value);                              setState(() => this.widget.dia = value);                            },                          ),                        ),                    )                  ],                ),              ),              new Center(              ),              new Center(              )            ],          ),        ),            ],        ),*/            Column(              mainAxisAlignment: MainAxisAlignment.center,              children: <Widget>[                StreamBuilder(                  stream: this.widget.fs.snapshots(),                  builder: (BuildContext context,                      AsyncSnapshot<QuerySnapshot> snapshot) {                    this.widget.snapshot = snapshot.data;                    if (!snapshot.hasData) return CircularProgressIndicator();                    return FirestoreListView(                      documents: snapshot.data.documents,                      ano: this.widget.ano,                      mes: this.widget.mes,                      dia: this.widget.dia,                      fs: this.widget.fs,                      context: context,                    );                  },                ),              ],            ),          ],        ));  }}class Documentos {  // ignore: final_not_initialized_constructor_3  Documentos(this.private_key_id, {this.selected});  final int ano,      dia,      hora,      humedad,      minuto,      nivel_agua,      nivel_purificacion,      oxigeno,      ph,      segundo,      temperatura,      turbidad,      viscosidad;  final String mes, private_key_id, tiempo, fecha;  bool selected = false;}class DocumentosDataSource extends DataTableSource {  List<Documentos> _creardatos(QuerySnapshot snapshot) {    List<Documentos> lista =        snapshot.documents.map((DocumentSnapshot document) {      return Documentos(document.documentID, selected: false);    }).toList();    return lista;  }  DocumentosDataSource({this.snapshot, this.context, this.fs});  QuerySnapshot snapshot;  BuildContext context;  CollectionReference fs;  //List<Documentos> _documentos = <Documentos>[Documentos('Hola Mundo')];  void _sort<T>(Comparable<T> getField(Documentos d), bool ascending) {    _creardatos(snapshot).sort((Documentos a, Documentos b) {      if (!ascending) {        final Documentos c = a;        a = b;        b = c;      }      final Comparable<T> aValue = getField(a);      final Comparable<T> bValue = getField(b);      return Comparable.compare(aValue, bValue);    });    notifyListeners();  }  int _selectedCount = 0;  @override  DataRow getRow(int index) {    assert(index >= 0);    if (index >= _creardatos(snapshot).length) return null;    final Documentos documentos = _creardatos(snapshot)[index];    return new DataRow.byIndex(index: index,        /*selected: documentos.selected,        onSelectChanged: (bool value) {          if (documentos.selected != value) {            _selectedCount += value ? 1 : -1;            assert(_selectedCount >= 0);            documentos.selected = value;            print(documentos.selected.toString());            notifyListeners();          }        },*/        cells: <DataCell>[          DataCell(Text('${documentos.private_key_id}'), onTap: () {            showBottomSheet(                context: context,                builder: (context) => Container(                      color: Colors.white,                      child: new Center(                        child: new Text(documentos.private_key_id),                      ),                    ));            /*showModalBottomSheet(                context: context,                builder: (builder) {                  return new Container(                    color: Colors.blue,                    child: Center(                        child: Text(                      documentos.private_key_id,                      style: TextStyle(color: Colors.white),                    )),                  );                });*/          }),          DataCell(              Center(                  child: CircleAvatar(                radius: 15.0,                backgroundColor: Colors.pink,                child: Icon(                  Icons.delete,                  color: Colors.white,                  size: 20.0,                ),              )), onTap: () {            showModalBottomSheet(                context: context,                builder: (builder) {                  return new Container(                      color: Colors.redAccent,                      child: Stack(                        children: <Widget>[                          Padding(                            padding: const EdgeInsets.only(top: 10.0),                            child: Text(                              '¿Esta Seguro que Desea Eliminar el Documento ${documentos.private_key_id}?',                              textAlign: TextAlign.center,                              style: TextStyle(color: Colors.white),                            ),                          ),                          Center(                              child: Column(                            mainAxisAlignment: MainAxisAlignment.center,                            children: <Widget>[                              Column(                                children: <Widget>[                                  GestureDetector(                                    child: CircleAvatar(                                      backgroundColor: Colors.white,                                      radius: 30.0,                                      child: Icon(                                        Icons.delete,                                        color: Colors.red,                                        size: 30.0,                                      ),                                    ),                                    onTap: () {                                      Navigator.pop(context);                                      fs                                          .document(                                              '${documentos.private_key_id}')                                          .delete();                                      print('Se ha eliminado el documento: ' +                                          documentos.private_key_id);                                    },                                  )                                ],                              ),                              Column(                                children: <Widget>[                                  Text(                                    'Eliminar',                                    textAlign: TextAlign.center,                                    style: TextStyle(                                        color: Colors.white,                                        fontWeight: FontWeight.bold),                                  )                                ],                              )                            ],                          )),                          Center(                            child: Column(                              mainAxisAlignment: MainAxisAlignment.end,                              children: <Widget>[                                Padding(                                  padding: const EdgeInsets.all(8.0),                                  child: RaisedButton(                                    elevation: 10.0,                                    color: Colors.red,                                    child: Text(                                      'Cancelar',                                      style: TextStyle(color: Colors.white),                                    ),                                    onPressed: () => Navigator.pop(context),                                  ),                                )                              ],                            ),                          )                        ],                      ));                });          })        ]);  }  @override  int get rowCount => _creardatos(snapshot).length;  @override  bool get isRowCountApproximate => false;  @override  int get selectedRowCount => _selectedCount;  void _selectAll(bool checked) {    for (Documentos documento in _creardatos(snapshot))      documento.selected = checked;    _selectedCount = checked ? _creardatos(snapshot).length : 0;    notifyListeners();  }}class FirestoreListView extends StatelessWidget {  final List<DocumentSnapshot> documents;  int ano;  String mes;  int dia;  var context;  final CollectionReference fs;  void crearDatos;  FirestoreListView(      {this.documents, this.ano, this.mes, this.dia, this.fs, this.context});  @override  Widget build(BuildContext context) {    return new StreamBuilder(      stream: fs          .where("Año", isEqualTo: ano)          .where('Mes', isEqualTo: mes)          .where('Dia', isEqualTo: dia)          .snapshots(),      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {        if (!snapshot.hasData) return new Text('Cargando...');        if (snapshot.data.documents.length == 0)          return new Text('No hay datos');        int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;        int _sortColumnIndex;        bool _sortAscending = true;        final DocumentosDataSource _documentosDataSource = DocumentosDataSource(            snapshot: snapshot.data, context: context, fs: fs);        void _sort<T>(Comparable<T> getField(Documentos d), int columnIndex,            bool ascending) {          _documentosDataSource._sort<T>(getField, ascending);          _sortColumnIndex = columnIndex;          _sortAscending = ascending;        }        return Column(          children: <Widget>[            PaginatedDataTable(                header: Text('Datos'),                rowsPerPage: _rowsPerPage,                onRowsPerPageChanged: (int value) {                  _rowsPerPage = value;                },                sortColumnIndex: _sortColumnIndex,                sortAscending: _sortAscending,                onSelectAll: _documentosDataSource._selectAll,                columns: <DataColumn>[                  new DataColumn(                      label: Text(                        'ID',                        textAlign: TextAlign.center,                      ),                      onSort: (int columnIndex, bool ascending) =>                          _sort<String>((Documentos d) => d.private_key_id,                              columnIndex, ascending),                      tooltip:                          'ID Unico de cada uno de los documentos de datos.'),                  new DataColumn(                      label: Text('Acciones'),                      tooltip:                          'Acciones a Ejecutar para cada uno de los documentos de datos.'),                ],                source:                    _documentosDataSource //_crearRows(snapshot.data, context, fs),                )          ],        );      },    );  }}/*List<DataRow> _crearRows(    QuerySnapshot snapshot, context, CollectionReference fs) {  List<DataRow> Lista =      snapshot.documents.map((DocumentSnapshot documentSnapshot) {    return new DataRow(cells: [      DataCell(Text(documentSnapshot.documentID), onTap: () {        showModalBottomSheet(            context: context,            builder: (builder) {              return new Container(                color: Colors.blue,                child: Center(                    child: Text(                  documentSnapshot.documentID,                  style: TextStyle(color: Colors.white),                )),              );            });      }, showEditIcon: false),      DataCell(          Center(              child: CircleAvatar(            radius: 15.0,            backgroundColor: Colors.pink,            child: Icon(              Icons.delete,              color: Colors.white,              size: 20.0,            ),          )), onTap: () {        showModalBottomSheet(            context: context,            builder: (builder) {              return new Container(                  color: Colors.redAccent,                  child: Stack(                    children: <Widget>[                      Padding(                        padding: const EdgeInsets.only(top: 10.0),                        child: Text(                          '¿Esta Seguro que Desea Eliminar el Documento ${documentSnapshot.documentID}?',                          textAlign: TextAlign.center,                          style: TextStyle(color: Colors.white),                        ),                      ),                      Center(                          child: Column(                        mainAxisAlignment: MainAxisAlignment.center,                        children: <Widget>[                          Column(                            children: <Widget>[                              GestureDetector(                                child: CircleAvatar(                                  backgroundColor: Colors.white,                                  radius: 30.0,                                  child: Icon(                                    Icons.delete,                                    color: Colors.red,                                    size: 30.0,                                  ),                                ),                                onTap: () {                                  Navigator.pop(context);                                  fs                                      .document(                                          '${documentSnapshot.documentID}')                                      .delete();                                  print('Se ha eliminado el documento: ' +                                      documentSnapshot.documentID);                                },                              )                            ],                          ),                          Column(                            children: <Widget>[                              Text(                                'Eliminar',                                textAlign: TextAlign.center,                                style: TextStyle(                                    color: Colors.white,                                    fontWeight: FontWeight.bold),                              )                            ],                          )                        ],                      )),                      Center(                        child: Column(                          mainAxisAlignment: MainAxisAlignment.end,                          children: <Widget>[                            Padding(                              padding: const EdgeInsets.all(8.0),                              child: RaisedButton(                                elevation: 10.0,                                color: Colors.red,                                child: Text(                                  'Cancelar',                                  style: TextStyle(color: Colors.white),                                ),                                onPressed: () => Navigator.pop(context),                              ),                            )                          ],                        ),                      )                    ],                  ));            });      }),    ]);  }).toList();  return Lista;}*///Clases de los dropdownsclass Anos {  int ano;  Anos({this.ano});}class Meses {  String mes;  Meses({this.mes});}class Dias {  int dia;  Dias({this.dia});}var meses = <Meses>[  Meses(mes: 'Enero'),  Meses(mes: 'Febrero'),  Meses(mes: 'Marzo'),  Meses(mes: 'Abril'),  Meses(mes: 'Mayo'),  Meses(mes: 'Junio'),  Meses(mes: 'Julio'),  Meses(mes: 'Agosto'),  Meses(mes: 'Septiembre'),  Meses(mes: 'Octubre'),  Meses(mes: 'Noviembre'),  Meses(mes: 'Diciembre'),];var anos = <Anos>[  Anos(ano: 2018),  Anos(ano: 2019),  Anos(ano: 2020),  Anos(ano: 2021),  Anos(ano: 2022),  Anos(ano: 2023),  Anos(ano: 2024),  Anos(ano: 2025),  Anos(ano: 2026),  Anos(ano: 2027),  Anos(ano: 2028),  Anos(ano: 2029),  Anos(ano: 2030),  Anos(ano: 2031),  Anos(ano: 2032),  Anos(ano: 2033),  Anos(ano: 2034),  Anos(ano: 2035),  Anos(ano: 2036),  Anos(ano: 2037),  Anos(ano: 2038),];var dias = <Dias>[  Dias(dia: 1),  Dias(dia: 2),  Dias(dia: 3),  Dias(dia: 4),  Dias(dia: 5),  Dias(dia: 6),  Dias(dia: 7),  Dias(dia: 8),  Dias(dia: 9),  Dias(dia: 10),  Dias(dia: 11),  Dias(dia: 12),  Dias(dia: 13),  Dias(dia: 14),  Dias(dia: 15),  Dias(dia: 16),  Dias(dia: 17),  Dias(dia: 18),  Dias(dia: 19),  Dias(dia: 20),  Dias(dia: 21),  Dias(dia: 22),  Dias(dia: 23),  Dias(dia: 24),  Dias(dia: 25),  Dias(dia: 26),  Dias(dia: 27),  Dias(dia: 28),  Dias(dia: 29),  Dias(dia: 30),  Dias(dia: 31)];