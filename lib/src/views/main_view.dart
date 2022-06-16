import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_handler/network_handler.dart';
import 'package:network_handler/network_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_service.dart';
import '../models/locations_model.dart';
import '../widgets/info.dart';
import '../widgets/offline.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<LocationsModel>> _savedLocationsModel;
  late List<LocationsModel>? _locationsModel = [];
  var _startPointController = TextEditingController();

  var choosedIndex = -1;

  @override
  void initState() {
    super.initState();
    _savedLocationsModel = _prefs.then(
      (SharedPreferences prefs) {
        return LocationsModelFromJson(prefs.getString('locations') ?? "");
      },
    );
  }

  /*String dropdownValue = 'name a-z';
  final items = [
    'name a-z',
    'name z-a',
  ];*/
  String inputText = "";

  NetworkStatus _status = NetworkStatus.unknown;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _status == NetworkStatus.disconnected
                ? Offline()
                : Center(
                    child: Container(),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _startPointController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                      onPressed: () => setState(
                            () {
                              _startPointController.clear();
                              inputText = "";
                            },
                          ),
                      icon: const Icon(Icons.clear)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(155, 33, 149, 243),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  hintText: 'Type your start point...',
                ),
                onChanged: (inputData) {
                  _locationsModel = null;
                  inputData.isEmpty ? inputText = "" : inputText = inputData;
                  setState(() {});
                  getData(inputData);
                  if (kDebugMode) {
                    print("t::$inputData");
                  }
                },
              ),
            ),
            //sort dropdown
            /*DropdownButton<String>(
              hint: const Text("choisir votre domaine"),
              value: dropdownValue,
              iconSize: 36,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: items.map(buildMenuItem).toList(),
              onChanged: (String? newValue) {
                setState(
                  () {
                    dropdownValue = newValue!;
                  },
                );
              },
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),*/
            NetworkHandler(
              onChanged: (NetworkStatus status) {
                setState(() {
                  _status = status;
                });
              },
              child: _status == NetworkStatus.connected
                  ? Expanded(
                      child: inputText.isEmpty
                          ? Info()
                          : _locationsModel == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _locationsModel!.isEmpty
                                  ? Center(
                                      child: Image.asset(
                                          "assets/Location_not_found.png"),
                                    )
                                  : Scrollbar(
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        itemCount: _locationsModel?.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: InkWell(
                                              onTap: () {
                                                choosedIndex = index;
                                                setState(() {});
                                              },
                                              child: Card(
                                                color: index == choosedIndex
                                                    ? const Color.fromARGB(
                                                        202, 204, 204, 204)
                                                    : Colors.transparent,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        child: Text(
                                                          "Name : ${_locationsModel?[index].name}",
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        "Type : ${_locationsModel?[index].type}",
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                          "Possibly the locality of the match : ${_locationsModel?[index].isBest}"),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 20),
                                                        child: Text(
                                                            " parent name : ${_locationsModel?[index].parent?.name}"),
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<List<LocationsModel>>(
                              future: _savedLocationsModel,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<LocationsModel>>
                                      snapshot) {
                                return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    if (kDebugMode) {
                                      print("snapshot::$snapshot");
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Text(
                                                  "Name : ${snapshot.data?[index].name}",
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                "Type : ${snapshot.data?[index].type}",
                                                overflow: TextOverflow.fade,
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                  "Possibly the locality of the match : ${snapshot.data?[index].isBest}"),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Text(
                                                    " parent name : ${snapshot.data?[index].parent?.name}"),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // DropdownMenuItem

  void getData(String startPoint) async {
    final SharedPreferences prefs = await _prefs;
    _locationsModel = (await ApiService().getLocations(startPoint));
    _locationsModel?.sort(((a, b) => a.name!.compareTo(b.name!)));

    if (_locationsModel != null && _locationsModel!.isNotEmpty) {
      _savedLocationsModel = _prefs.then((SharedPreferences prefs) {
        return LocationsModelFromJson(prefs.getString('locations') ?? "");
      });
    }
    if (kDebugMode) {
      print("_locationsModel:::$_locationsModel");
    }
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  /*DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ), // Text
      );*/
}
