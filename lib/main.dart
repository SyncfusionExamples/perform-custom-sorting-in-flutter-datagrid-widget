import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SortingDataGridSource sortingDataGridSource;
  @override
  void initState() {
    super.initState();
    sortingDataGridSource = SortingDataGridSource();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      Container(
          height: 645,
          child: SfDataGrid(
            source: sortingDataGridSource,
            columns: getColumns(),
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            allowSorting: true,
            allowTriStateSorting: true,
            allowMultiColumnSorting: true,
            showSortNumbers: true,
            sortingGestureType: SortingGestureType.doubleTap,
          )),
      // Padding(
      //   padding: EdgeInsets.only(top: 10.0),
      //   child: ElevatedButton(
      //       onPressed: () {
      //         sortingDataGridSource.sortedColumns.add(SortColumnDetails(
      //             name: 'customerId',
      //             sortDirection: DataGridSortDirection.descending));
      //         sortingDataGridSource.sort();
      //       },
      //       child: Text('Apply Sort')),
      // )
    ])));
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          width: 90.0,
          allowSorting: false,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text('Order ID', overflow: TextOverflow.ellipsis))),
      GridColumn(
          columnName: 'customerId',
          width: 100.0,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child:
                  const Text('Customer ID', overflow: TextOverflow.ellipsis))),
      GridColumn(
          columnName: 'name',
          width: 97.0,
          label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text('Name', overflow: TextOverflow.ellipsis)),
          allowSorting: true),
      GridColumn(
          columnName: 'freight',
          width: 103.0,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text('Freight', overflow: TextOverflow.ellipsis))),
      GridColumn(
          columnName: 'city',
          width: 90.0,
          label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text('City', overflow: TextOverflow.ellipsis))),
      GridColumn(
          columnName: 'price',
          width: 75.0,
          columnWidthMode: ColumnWidthMode.fill,
          label: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: const Text('Price', overflow: TextOverflow.ellipsis)))
    ];
  }
}

class Employee {
  Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class SortingDataGridSource extends DataGridSource {
  SortingDataGridSource() {
    employees = getEmployees();
    buildDataGridRows();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if (sortColumn.name == 'name') {
      final String? value1 = a
          ?.getCells()
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
          ?.value
          .toString();
      final String? value2 = b
          ?.getCells()
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
          ?.value
          .toString();

      if (value1 == null || value2 == null) {
        return 0;
      }

      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
        return value1.toLowerCase().compareTo(value2.toLowerCase());
      } else {
        return value2.toLowerCase().compareTo(value1.toLowerCase());
      }
    }
    return super.compare(a, b, sortColumn);
  }

  List<Employee> employees = <Employee>[];

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((Employee employee) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'id', value: employee.id),
        DataGridCell<int>(columnName: 'customerId', value: employee.customerId),
        DataGridCell<String>(columnName: 'name', value: employee.name),
        DataGridCell<double>(columnName: 'freight', value: employee.freight),
        DataGridCell<String>(columnName: 'city', value: employee.city),
        DataGridCell<double>(columnName: 'price', value: employee.price)
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis),
      ),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[2].value.toString(),
              overflow: TextOverflow.ellipsis)),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
              NumberFormat.currency(locale: 'en_US', symbol: r'$')
                  .format(row.getCells()[3].value)
                  .toString(),
              overflow: TextOverflow.ellipsis)),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[4].value.toString(),
              overflow: TextOverflow.ellipsis)),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
              NumberFormat.currency(
                      locale: 'en_US', symbol: r'$', decimalDigits: 0)
                  .format(row.getCells()[5].value)
                  .toString(),
              overflow: TextOverflow.ellipsis))
    ]);
  }

  Random random = Random();

  final List<String> names = <String>[
    'Welli',
    'blonp',
    'folko',
    'Furip',
    'Folig',
    'Picco',
    'frans',
    'Warth',
    'Linod',
    'Simop',
    'Merep',
    'Riscu',
    'Seves',
    'Vaffe',
    'Alfki'
  ];

  final List<String> cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende'
  ];

  List<Employee> getEmployees() {
    final List<Employee> employeeData = <Employee>[];
    for (int i = 0; i < 30; i++) {
      employeeData.add(Employee(
          1000 + i,
          1700 + i,
          names[i < names.length ? i : random.nextInt(names.length - 1)],
          random.nextInt(1000) + random.nextDouble(),
          cities[random.nextInt(cities.length - 1)],
          1500.0 + random.nextInt(100)));
    }
    return employeeData;
  }
}
