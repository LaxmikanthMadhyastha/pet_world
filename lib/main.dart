import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pet_world/classes/pet.dart';
import 'package:pet_world/constants.dart';
import 'package:pet_world/services/pet_world_service.dart';
import 'package:pet_world/widgets/pet_tile.dart';

void main() {
  runApp(const PetWorldApp());
}

class PetWorldApp extends StatelessWidget {
  const PetWorldApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PetWorldPage(),
    );
  }
}

class PetWorldPage extends StatefulWidget {
  const PetWorldPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PetWorldPage> createState() => _PetWorldPageState();
}

class _PetWorldPageState extends State<PetWorldPage> {
  PetWorldService petWorldService = PetWorldService();
  bool isLoading = true;
  List<Pet> petList = [];
  int page = 1;
  final int limit = 10;
  bool filterAll = true;
  bool filterlessThanThree = false;
  bool filtermoreThanSeven = false;
  bool desc = true;
  double? offset;
  ScrollController? controller;
  List<Pet> items = [];
  String searchParam = '';

  @override
  void initState() {
    executeInitFunctions();
    controller = ScrollController();
    super.initState();
  }

  executeInitFunctions() async {
    //On opening the app load the data
    petList = await petWorldService.getAllAnimals(limit: limit, page: page, sort: desc ? Strings.DESC : Strings.ASC);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          //On reaching end of the list load more items
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              offset = scrollInfo.metrics.maxScrollExtent;
              loadMore();
            }
            return true;
          },
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    Strings.MY_PETS,
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (val) async {
                              searchParam = val;
                              if (val.length >= 3) {
                                petList = await petWorldService.getAllAnimals(limit: limit, page: page, searchParam: val, sort: desc ? Strings.DESC : Strings.ASC);
                                setState(() {});
                              } else if (val.isEmpty) {
                                petList = await petWorldService.getAllAnimals(limit: limit, page: page, sort: desc ? Strings.DESC : Strings.ASC);
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: Strings.SEARCH_HINT,
                                fillColor: Colors.white70),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showBottomSheet();
                            },
                            child: const SizedBox(
                              height: 60,
                              width: 50,
                              child: Card(
                                child: Icon(Icons.sort),
                                elevation: 3,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterAll = !filterAll;
                                filterlessThanThree = false;
                                filtermoreThanSeven = false;
                              });
                            },
                            child: SizedBox(
                              width: 80,
                              height: 20,
                              child: Card(
                                  color: filterAll ? Colors.blueAccent : Colors.white,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Strings.ALL,
                                      style: TextStyle(color: filterAll ? Colors.white : Colors.black),
                                    ),
                                  ))),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterlessThanThree = !filterlessThanThree;
                                filterAll = false;
                                filtermoreThanSeven = false;
                              });
                            },
                            child: SizedBox(
                              height: 20,
                              child: Card(
                                  color: filterlessThanThree ? Colors.blueAccent : Colors.white,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Strings.LESS,
                                      style: TextStyle(color: filterlessThanThree ? Colors.white : Colors.black),
                                    ),
                                  ))),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filtermoreThanSeven = !filtermoreThanSeven;
                                filterAll = false;
                                filterlessThanThree = false;
                              });
                            },
                            child: SizedBox(
                              height: 20,
                              child: Card(
                                  color: filtermoreThanSeven ? Colors.blueAccent : Colors.white,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Strings.MORE,
                                      style: TextStyle(color: filtermoreThanSeven ? Colors.white : Colors.black),
                                    ),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  petList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              controller: controller,
                              itemCount: getItemCount(),
                              itemBuilder: (context, index) {
                                return PetTile(
                                  index: index,
                                  petList: getItems(),
                                );
                              }),
                        )
                      : Expanded(child: Center(child: Container(child: searchParam.length >= 3 && petList.isEmpty ? const Center(child: Text(Strings.NO_DATA)) : Container())))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadMore() async {
    if (petList.length < 57) {
      setState(() {
        isLoading = true;
      });
      List<Pet> morePets = await petWorldService.getAllAnimals(limit: limit, page: page + 1, sort: desc ? Strings.DESC : Strings.ASC);
      petList.addAll(morePets);
      setState(() {
        isLoading = false;
      });
      if (offset != null) WidgetsBinding.instance!.addPostFrameCallback((_) => controller!.animateTo(offset!, duration: const Duration(microseconds: 1), curve: Curves.easeInSine));
    }
  }

//get Listview count
  getItemCount() {
    if (filterAll) {
      items = petList;
    } else if (filterlessThanThree) {
      items = petList.where((element) => element.month! < 3).toList();
    } else if (filtermoreThanSeven) {
      items = petList.where((element) => element.month! > 7).toList();
    }
    return items.length;
  }

//get items based on filter
  getItems() {
    if (filterAll) {
      items = petList;
    } else if (filterlessThanThree) {
      items = petList.where((element) => element.month! < 3).toList();
    } else if (filtermoreThanSeven) {
      items = petList.where((element) => element.month! > 7).toList();
    }
    return items;
  }

//show bottom sheet for sort
  showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  desc = !desc;
                  sState(() {});
                  setState(() {
                    isLoading = true;
                  });
                  petList = await petWorldService.getAllAnimals(limit: limit, page: page, sort: desc ? Strings.DESC : Strings.ASC);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: desc
                                ? const Icon(
                                    Icons.arrow_upward,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.arrow_downward,
                                    size: 30,
                                  ),
                          ),
                          const Text(
                            Strings.AGE,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
