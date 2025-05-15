import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/bloc/bloc/daytim_bloc.dart';
import 'package:todo/bloc/cuit/date_cubit.dart';
import 'package:todo/bloc/cuit/theme_cubit.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/bloc/todo/todo_cubit.dart';

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
  List<MapEntry<String, dynamic>> sortedList = [];
  int listCount = 0;
  String? selectedPriorityFilter;
  bool? filterCompleted;
  bool iscompledfilter = false;
  String dateClick = date;
  bool selected = false;
  bool checkboxSelected = false;
  List<String> priorty = [
    'tinggi',
    'sedang',
    'rendah',
  ];
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

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
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
              onPressed: () {
                // print(dateW);
              },
              icon: Icon(Icons.abc)),
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
              if (value == "profile") {
                // Navigasi
              } else if (value == "logout") {
                context.read<AuthBloc>().add(LogOut(context));
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
            BlocBuilder<DateCubit, List<String>>(builder: (context, dates) {
              return Container(
                height: 50,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: Row(
                  children: [
                    BlocBuilder<DateCubit, List<String>>(
                      builder: (context, state) {
                        if (state
                            .where((element) => element == date)
                            .isNotEmpty) {
                          print('ada');
                          return Container();
                        } else {
                          print('tidak ada');
                        }
                        return Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dateClick = date;
                                  });
                                  print(dateClick);
                                  print(state);
                                  print(state.where(
                                    (element) => element == date,
                                  ));
                                },
                                child: AnimatedContainer(
                                  duration: Durations.long3,

                                  // width: ,
                                  height: 45,
                                  // color: Colors.blue,
                                  child: Center(
                                    child: Icon(Icons.edit_calendar_outlined,
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            }),
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
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  return StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color:
                                    Theme.of(context).colorScheme.onPrimary));
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
                              .compareTo(a.value['priorty'].toString()));
                        List<MapEntry<String, dynamic>> filteredList =
                            sortedList;

                        if (state is FilterState) {
                          if (state.fileterPriorty != null) {
                            filteredList = filteredList
                                .where((element) =>
                                    element.value['priorty'] ==
                                    state.fileterPriorty)
                                .toList();
                          } else {
                            // print('empty');
                          }

                          if (state.iscompledfilter == true) {
                            filteredList = filteredList
                                .where((element) =>
                                    element.value['isCompleted'] != false)
                                .toList();
                          }
                        }
                        listCount = sortedList.length;
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final tod = Map<String, dynamic>.from(
                                filteredList[index].value);
                            final key = filteredList[index].key;
                            tod['key'] = key;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: BlocBuilder<DateCubit, List<String>>(
                                builder: (context, state) {
                                  if (dateClick != date) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(
                                          tod['title'],
                                          style: TextStyle(
                                              decoration: (tod['isCompleted'] ==
                                                      true)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        subtitle: Text(
                                          tod['desc'],
                                          style: TextStyle(
                                              decoration: (tod['isCompleted'] ==
                                                      true)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildPriorityWidget(tod['priorty']),
                                            Text(tod['datetime']),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Dismissible(
                                    key: Key(key),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Hapus Item ini?'),
                                          content: const Text(
                                              'Apakah Kamu Yakin Ingin Menghapus Item Ini?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Tidak')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  context
                                                      .read<TodoBloc>()
                                                      .add(DeleteTodo(key));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error,
                                                          duration: Durations
                                                              .extralong2,
                                                          content: Text(
                                                            'Berhasil Menghapus Todo',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onError),
                                                          )));
                                                },
                                                child: const Text('Ya, Hapus')),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: ListTile(
                                        onTap: () {
                                          context
                                              .read<TodoCubit>()
                                              .changetod(key);
                                        },
                                        onLongPress: () {
                                          titleC.text = tod['title'];
                                          desC.text = tod['desc'];
                                          rty.text = tod['priorty'];
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  MyText(text: "Update Todo"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MyTextField(
                                                      controller: titleC,
                                                      hint: 'Judul'),
                                                  const SizedBox(height: 10),
                                                  MyTextField(
                                                      controller: desC,
                                                      hint: 'Deskripsi'),
                                                  DropdownButtonFormField(
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary),
                                                    decoration: InputDecoration(
                                                        enabledBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary)),
                                                        focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary))),
                                                    hint: const Text(
                                                        'Pilih Priorty'),
                                                    isExpanded: true,
                                                    value: tod['priorty'],
                                                    items: priorty
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e)))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      rty.text =
                                                          value.toString();
                                                    },
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      titleC.clear();
                                                      desC.clear();
                                                    },
                                                    child: MyText(
                                                      text: 'No',
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<TodoBloc>()
                                                          .add(UpdateTodo(
                                                              title:
                                                                  titleC.text,
                                                              desc: desC.text,
                                                              rty: rty.text,
                                                              key: key));
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (titleC.text ==
                                                              tod['title'] &&
                                                          desC.text ==
                                                              tod['desc'] &&
                                                          rty.text ==
                                                              tod['priorty']) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          content: Text(
                                                              'Tidak Ada Yang Berubah'),
                                                          duration: Durations
                                                              .extralong3,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ));
                                                      }
                                                      titleC.clear();
                                                      desC.clear();
                                                    },
                                                    child: MyText(text: 'Yes')),
                                              ],
                                            ),
                                          );
                                        },
                                        leading: selected
                                            ? Checkbox(
                                                value: checkboxSelected,
                                                onChanged: (value) {},
                                              )
                                            : null,
                                        title: Text(
                                          tod['title'],
                                          style: TextStyle(
                                              decoration: (tod['isCompleted'] ==
                                                      true)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        subtitle: Text(
                                          tod['desc'],
                                          style: TextStyle(
                                              decoration: (tod['isCompleted'] ==
                                                      true)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildPriorityWidget(tod['priorty']),
                                            Text(tod['datetime']),
                                          ],
                                        ),
                                      ),
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
                },
              ),
            ),
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
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                      onPressed: () {}, child: Icon(Icons.search)),
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          title: Text(
                            'Tambahkan Todo Baru',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyTextField(controller: titleC, hint: 'Judul'),
                              const SizedBox(height: 15),
                              MyTextField(controller: desC, hint: 'Deskripsi'),
                              DropdownButtonFormField(
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))),
                                hint: const Text('Pilih Priorty'),
                                isExpanded: true,
                                value: iselected,
                                items: priorty
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (value) {
                                  rty.text = value.toString();
                                },
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  titleC.clear();
                                  desC.clear();
                                  Navigator.of(context).pop();
                                },
                                child: MyText(
                                  text: "No",
                                )),
                            BlocConsumer<TodoBloc, TodoState>(
                              builder: (context, state) => TextButton(
                                  onPressed: () {
                                    context.read<TodoBloc>().add(PostTodo(
                                        title: titleC.text,
                                        desc: desC.text,
                                        rty: rty.text));
                                    Navigator.of(context).pop();
                                    titleC.clear();
                                    desC.clear();
                                  },
                                  child: MyText(text: 'Yes')),
                              listener: (context, state) {
                                if (state is TodoErorr) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: MyText(text: 'Terjadi Kesalahan'),
                                      content: MyText(text: state.e),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: MyText(text: "Ya, Mengerti"))
                                      ],
                                    ),
                                  );
                                } else if (state is Todoloaded) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Durations.long2,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text('Berhasil Menambahkan Data')));
                                }
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      size: 28,
                      weight: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  FloatingActionButton(
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
  Color color;
  Color borderColor;
  String label;
  ContainerPriorty(
      {super.key,
      required this.borderColor,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 40,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: borderColor),
        ),
      ),
    );
  }
}

Color red = Colors.red;
bool s = false;
String? iselected;

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  MyTextField({super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
        hintText: 'Masukan $hint',
      ),
    );
  }
}

Widget buildPriorityWidget(String priority) {
  switch (priority.toLowerCase()) {
    case 'rendah':
      return ContainerPriorty(
          borderColor: Colors.green.shade800,
          color: Colors.greenAccent.shade200,
          label: 'RND');
    case 'tinggi':
      return ContainerPriorty(
          borderColor: Colors.red.shade900,
          color: Colors.red.shade300,
          label: 'TNG');
    case 'sedang':
      return ContainerPriorty(
          borderColor: Colors.orangeAccent.shade700,
          color: Colors.orangeAccent.shade200,
          label: 'SDG');
    default:
      return ContainerPriorty(
          borderColor: Colors.transparent,
          color: Colors.transparent,
          label: '');
  }
}
