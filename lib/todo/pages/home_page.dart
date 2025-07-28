import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/bloc/bloc/daytim_bloc.dart';
import 'package:todo/bloc/cuit/date_cubit.dart';
import 'package:todo/bloc/cuit/search_cubit.dart';
import 'package:todo/bloc/cuit/theme_cubit.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/bloc/todo/todo_cubit.dart';
import 'package:todo/login/pages/login.dart';
import 'package:todo/todo/pages/add_page.dart';

late DatabaseReference dbref;
FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleC = TextEditingController();
  TextEditingController desC = TextEditingController();
  TextEditingController rty = TextEditingController();
  TextEditingController searching = TextEditingController();

  List<MapEntry<String, dynamic>> sortedList = [];
  int listCount = 0;
  String? selectedPriorityFilter;
  bool? filterCompleted;
  bool iscompledfilter = false;
  String dateClick = date;
  bool selected = false;
  String searchText = '';
  bool checkboxSelected = false;
  // List<String> priorty = [
  //   'tinggi',
  //   'sedang',
  //   'rendah',
  // ];
  bool imagetrue = false;
  @override
  void initState() {
    super.initState();
    context.read<DateCubit>().getDate();
    context.read<DaytimBloc>().add(ChangeDay());
    Timer.periodic(const Duration(hours: 1), (timer) {
      if (mounted) {
        context.read<DaytimBloc>().add(ChangeDay());
      }
    });
  }

  StreamSubscription? _authSubscription;
  StreamSubscription? _dbSubscription;
  void stream() {}

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print('build');
    Query dbref =
        FirebaseDatabase.instance.ref().child('todos/$uid/$dateClick');
    // String dateW = DateFormat('EEEE').format();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: context.read<ThemeCubit>().changeTheme,
              icon: BlocBuilder<ThemeCubit, bool>(
                  builder: (context, state) => Icon(
                        state ? Icons.sunny : Icons.dark_mode,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ))),
          PopupMenuButton<String>(
            shadowColor: Colors.black,
            tooltip: 'On Tap For Menu',
            padding: const EdgeInsets.all(100),
            onSelected: (value) {
              if (value == "logout") {
                context.read<AuthBloc>().add(LogOut());
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.login_outlined),
                    title: Text('Log Out'),
                  )),
            ],
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
        automaticallyImplyLeading: false,
        // centerTitle: true,

        title: BlocBuilder<DaytimBloc, DaytimState>(builder: (context, state) {
          if (state is StateChanegeDay) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600),
                      children: [
                        const TextSpan(text: 'Hello'),
                        const TextSpan(text: ' '),
                        TextSpan(
                            text: auth.currentUser?.displayName ?? 'Guest'),
                      ]),
                ),
                Text(
                  'Good ${state.e}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            );
          }
          return Text(
            'Good Bye',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600),
          );
        }),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<SearchCubit, bool>(
              builder: (context, state) {
                if (state == true) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20.0),
                    child: BlocBuilder<TextSearchCubit, String>(
                      builder: (context, state) => TextField(
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        autocorrect: false,
                        controller: searching,
                        onChanged: (value) {
                          context.read<TextSearchCubit>().hello(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Mau Cari Sesuatu?",
                          labelText: "Pencarian",
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  );
                }
                return BlocBuilder<DateCubit, List<String>>(
                    builder: (context, dates) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: Row(
                      children: [
                        BlocBuilder<DateCubit, List<String>>(
                          builder: (context, state) {
                            if (state
                                .where((element) => element == date)
                                .isNotEmpty) {
                              return Container();
                            }
                            return Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        dateClick = date;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Durations.long3,
                                      height: 45,
                                      // color: Colors.blue,
                                      child: Center(
                                        child: Icon(
                                            Icons.edit_calendar_outlined,
                                            color: dateClick == date
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                      ),
                                    )),
                              ],
                            );
                          },
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: dates.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dateClick = dates[index];
                                  });
                                  print(dateClick);
                                },
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    // color: dateClick == dates[index] ? Theme.of(context).colorScheme.secondary :Theme.of(context).colorScheme.primary ,
                                  ),
                                  child: Center(
                                      child: Text(
                                    dates[index].substring(0, 6),
                                    textAlign: TextAlign.center,
                                    style: dateClick == dates[index]
                                        ? TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)
                                        : TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("$dateClick",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary))),
                    ),
                    const SizedBox(),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: 350,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Filter Data',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 16),

                                      // Filter Priority
                                      Text(
                                        "Priority:",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          ChoiceChip(
                                            checkmarkColor: Colors.green,
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                            label: Text("Tinggi"),
                                            selected: selectedPriorityFilter ==
                                                'tinggi',
                                            onSelected: (selected) {
                                              setState(() {
                                                selectedPriorityFilter =
                                                    selected ? 'tinggi' : null;
                                              });
                                            },
                                          ),
                                          ChoiceChip(
                                            checkmarkColor: Colors.green,
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                            label: Text("Sedang"),
                                            selected: selectedPriorityFilter ==
                                                'sedang',
                                            onSelected: (selected) {
                                              setState(() {
                                                selectedPriorityFilter =
                                                    selected ? 'sedang' : null;
                                              });
                                            },
                                          ),
                                          ChoiceChip(
                                            checkmarkColor: Colors.green,
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                            label: Text("Rendah"),
                                            selected: selectedPriorityFilter ==
                                                'rendah',
                                            onSelected: (selected) {
                                              setState(() {
                                                selectedPriorityFilter =
                                                    selected ? 'rendah' : null;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      // Filter Status
                                      CheckboxListTile(
                                        title: Text(iscompledfilter
                                            ? "Sudah Selesai"
                                            : "Hanya yang belum selesai"),
                                        value: filterCompleted ?? false,
                                        onChanged: (value) {
                                          setState(() {
                                            filterCompleted = value;
                                            iscompledfilter = !iscompledfilter;
                                            print(filterCompleted);
                                          });
                                        },
                                      ),

                                      Spacer(),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade100),
                                            onPressed: () {
                                              iscompledfilter = false;
                                              context.read<TodoBloc>().add(Filter(
                                                  fileterPriorty:
                                                      selectedPriorityFilter =
                                                          null,
                                                  isCompleted: filterCompleted =
                                                      false));
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Reset Filter",
                                                style: TextStyle(
                                                    color:
                                                        Colors.red.shade900)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                            onPressed: () {
                                              print(filterCompleted);
                                              context.read<TodoBloc>().add(Filter(
                                                  fileterPriorty:
                                                      selectedPriorityFilter,
                                                  isCompleted:
                                                      filterCompleted)); // Trigger rebuild di HomePage
                                              Navigator.pop(
                                                  context); // Tutup bottom sheet
                                            },
                                            child: Text("Apply Filter",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary)),
                                          ),
                                        ],
                                      ),
                                      // button
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.filter_list),
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                )),

            // fetch data
            Container(
                height: 700,
                child: auth.currentUser != null
                    ? BlocBuilder<TodoBloc, TodoState>(
                        builder: (context, state) {
                          return BlocBuilder<TextSearchCubit, String>(
                              builder: (context, searchTextState) {
                            return StreamBuilder(
                              stream: auth.currentUser != null
                                  ? dbref.onValue
                                  : null,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary));
                                }
                                if (snapshot.hasData &&
                                    snapshot.data!.snapshot.value != null) {
                                  final data = Map<String, dynamic>.from(
                                      snapshot.data!.snapshot.value as Map);
                                  final sortedList = data.entries.toList()
                                    ..sort((a, b) => b.value['datetime']
                                        .toString()
                                        .compareTo(a.value['datetime']))
                                    ..sort((a, b) => b.value['priorty']
                                        .toString()
                                        .compareTo(
                                            a.value['priorty'].toString()));
                                  List<MapEntry<String, dynamic>> filteredList =
                                      sortedList;
                                  if (filteredList
                                      .where((element) => element.value['title']
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              searchTextState.toLowerCase()))
                                      .isEmpty) {
                                    return Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: BlocBuilder<ThemeCubit, bool>(
                                            builder: (context, state) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    height: 220.0,
                                                    width: 220.0,
                                                    state
                                                        ? 'assets/svg/no_white.svg'
                                                        : 'assets/svg/no_dark.svg'),
                                                Text(
                                                  'Tidak Ada Pencarian Yang Cocok',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary),
                                                ),
                                                Text(
                                                  'pastikan kamu mengetik keyword dengan benar',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 100,
                                        )
                                      ],
                                    ));
                                  }
                                  filteredList = filteredList
                                      .where((element) => element.value['title']
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              searchTextState.toLowerCase()))
                                      .toList();
                                  // gabisa return

                                  if (state is FilterState) {
                                    if (state.fileterPriorty != null) {
                                      filteredList = filteredList
                                          .where((element) =>
                                              element.value['priorty'] ==
                                              state.fileterPriorty)
                                          .toList();
                                    }

                                    if (state.iscompledfilter == true) {
                                      filteredList = filteredList
                                          .where((element) =>
                                              element.value['isCompleted'] !=
                                              false)
                                          .toList();
                                    }
                                  }
                                  listCount = sortedList.length;

                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final tod = Map<String, dynamic>.from(
                                          filteredList[index].value);
                                      final key = filteredList[index].key;
                                      tod['key'] = key;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: BlocBuilder<DateCubit,
                                            List<String>>(
                                          builder: (context, state) {
                                            return Dismissible(
                                              key: Key(key),
                                              direction:
                                                  DismissDirection.endToStart,
                                              confirmDismiss: (direction) {
                                                return showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        'Hapus Item ini?'),
                                                    content: const Text(
                                                        'Apakah Kamu Yakin Ingin Menghapus Item Ini?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child: const Text(
                                                              'Tidak')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                            context
                                                                .read<
                                                                    TodoBloc>()
                                                                .add(DeleteTodo(
                                                                    key));
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error,
                                                                    duration:
                                                                        Durations
                                                                            .extralong2,
                                                                    content:
                                                                        Text(
                                                                      'Berhasil Menghapus Todo',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onError),
                                                                    )));
                                                          },
                                                          child: const Text(
                                                              'Ya, Hapus')),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Card(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer
                                                        .withOpacity(1),
                                                    child: Container(
                                                      width: width * 0.90,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${tod['title']}:",
                                                                    style: TextStyle(
                                                                        color: tod['isCompleted'] !=
                                                                                false
                                                                            ? Theme.of(context)
                                                                                .colorScheme
                                                                                .onPrimary
                                                                            : Theme.of(context)
                                                                                .colorScheme
                                                                                .onSecondary,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    tod['desc'],
                                                                    style: TextStyle(
                                                                        color: tod['isCompleted'] !=
                                                                                false
                                                                            ? Theme.of(context)
                                                                                .colorScheme
                                                                                .onPrimary
                                                                            : Theme.of(context)
                                                                                .colorScheme
                                                                                .onSecondary,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: buildPriorityWidget(
                                                                  tod['priorty'],
                                                                  tod['datetime'],
                                                                  tod['isCompleted']),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  context
                                                      .read<TodoCubit>()
                                                      .changetod(key);
                                                },
                                                onLongPress: () {
                                                  titleC.text = tod['title'];
                                                  desC.text = tod['desc'];
                                                  rty.text = tod['priorty'];
                                                  showModalBottomSheet(
                                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          SingleChildScrollView(
                                                            child: SizedBox(
                                                              height:
                                                                  height * 0.55,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Text(
                                                                      'Edit Somthing?',
                                                                      style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              19),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  MyTextField(
                                                                      controller:
                                                                          titleC,
                                                                      input:
                                                                          'Title',
                                                                      maxlines:
                                                                          2,
                                                                      desc:
                                                                          'Bakso'),
                                                                  MyTextField(
                                                                      controller:
                                                                          desC,
                                                                      input:
                                                                          'Title',
                                                                      maxlines:
                                                                          2,
                                                                      desc:
                                                                          'Bakso'),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20.0),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          DropdownButtonFormField(
                                                                        menuMaxHeight:
                                                                            200,
                                                                        dropdownColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.onPrimary),
                                                                        decoration: InputDecoration(
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                                                        hint: Text(
                                                                            rty.text),
                                                                        isExpanded:
                                                                            true,
                                                                        value:
                                                                            isSelected,
                                                                        items: priorty
                                                                            .map((e) =>
                                                                                DropdownMenuItem(value: e, child: Text(e)))
                                                                            .toList(),
                                                                        onChanged:
                                                                            (value) {
                                                                          rty.text =
                                                                              value.toString();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(15.0),
                                                                      child: ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (titleC.text.isNotEmpty ||
                                                                                desC.text.isNotEmpty ||
                                                                                rty.text.isNotEmpty) {
                                                                                  context.read<TodoBloc>().add(
                                                                                    UpdateTodo(title: titleC.text, desc: desC.text, key: key,
                                                                                     rty: rty.text)
                                                                                    );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                  behavior: SnackBarBehavior.floating,
                                                                                  duration: Durations.long3,
                                                                                  content: Text('Please fill all Empty Fields')));
                                                                            }
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Theme.of(context)
                                                                                  .colorScheme
                                                                                  .onPrimary),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets
                                                                                .symmetric(
                                                                                horizontal:
                                                                                    10.0),
                                                                            child:
                                                                                Text(
                                                                              'Done',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Theme.of(context).colorScheme.primary),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: BlocBuilder<ThemeCubit, bool>(
                                          builder: (context, state) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                  height: 220.0,
                                                  width: 220.0,
                                                  state
                                                      ? 'assets/svg/add_white.svg'
                                                      : 'assets/svg/add_dark.svg'),
                                              Text(
                                                'The Todo Is Empty \n Please  Add Some Work To do',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      )
                                    ],
                                  ));
                                }
                              },
                            );
                          });
                        },
                      )
                    : Center(
                        child: Text('Login Untuk Melihat Data'),
                      )),
          ],
        ),
      ),

      // tambah data
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<DateCubit, List<String>>(
        builder: (context, state) {
          if (dateClick != date) {
            return Container();
          }
          return Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      heroTag: "fab-search",
                      onPressed: () {
                        context.read<SearchCubit>().changeState();
                      },
                      child: const Icon(Icons.search)),
                  FloatingActionButton(
                    heroTag: "fab-add",
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddPage(),
                      ));
                    },
                    child: Icon(
                      Icons.add,
                      size: 28,
                      weight: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "fab-list",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Durations.long2,
                          behavior: SnackBarBehavior.floating,
                          content: Text("Were Update This Feature ASAP")));
                    },
                    child: Icon(Icons.checklist_rtl_rounded),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

List<String> priorty = [
  'High',
  'Mid',
  'Low',
];

class MyText extends StatelessWidget {
  String text;
  MyText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

class ContainerPriorty extends StatelessWidget {
  String label;
  String time;
  bool status;
  ContainerPriorty({
    super.key,
    required this.label,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
              color: status != false
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 20,
          width: 40,
          decoration: BoxDecoration(
              border: Border.all(
                  color: status != false
                      ? Theme.of(context).colorScheme.onSurface
                      :  Colors.transparent),
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: status != false
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

Color red = Colors.red;
bool s = false;
String? iselected;
Widget buildPriorityWidget(String priority, String date, bool status) {
  switch (priority.toLowerCase()) {
    case 'low':
      return ContainerPriorty(status: status, time: date, label: 'Low');
    case 'mid':
      return ContainerPriorty(status: status, time: date, label: 'Mid');
    case 'high':
      return ContainerPriorty(status: status, time: date, label: 'High');
    default:
      return ContainerPriorty(status: status, time: '', label: '');
  }
}
