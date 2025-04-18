import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/bloc/todo/todo_cubit.dart';
import 'package:todo/login/pages/login.dart';

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

  List<String> priorty = [
    'tinggi',
    'sedang',
    'rendah',
  ];
  

  @override
  Widget build(BuildContext context) {
FirebaseAuth auth = FirebaseAuth.instance;
var uid =  auth.currentUser?.uid;
    Query dbref = FirebaseDatabase.instance.ref().child('todos/$uid').orderByChild('priorty');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
             
             Text('Login Sebagai ${auth.currentUser?.email}'),
              behavior: SnackBarBehavior.fixed,
            elevation: 10.0,
            ));
            }, 
            icon:const Icon(Icons.person,color: Colors.white,)),
          IconButton(onPressed: (){
            auth.signOut().then((value){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
            });
          }, icon: const Icon(Icons.logout,color: Colors.white ,)),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'TodoUkk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SizedBox(
        height: double.infinity,
        child: FirebaseAnimatedList(
          defaultChild:const Center(child: CircularProgressIndicator(),),
          query: dbref,
          itemBuilder: (context, snapshot, animation, index) {
            Map tod = snapshot.value as Map;
            tod['key'] = snapshot.key;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Dismissible(
                key: Key(snapshot.key.toString()),
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
                              Navigator.of(context).pop(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text('Undo Item')));
                            },
                            child: const Text('Tidak')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              context
                                  .read<TodoBloc>()
                                  .add(DeleteTodo(tod['key']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      duration: Durations.extralong2,
                                      content:
                                          Text('Berhasil Menghapus Todo')));
                            },
                            child: const Text('Ya, Hapus')),
                      ],
                    ),
                  );
                },
                child: Card(
                    child: ListTile(
                        // Penanda Tugas Selesai
                        onTap: () {
                          context.read<TodoCubit>().changetod(tod['key']);
                        },

                        // Update Todo //
                        onLongPress: () {
                          titleC.text = tod['title'];
                          desC.text = tod['desc'];
                          rty.text = tod['priorty'];
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Update Todo'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyTextField(
                                      controller: titleC, hint: 'Judul'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MyTextField(
                                      controller: desC, hint: 'Deskripsi'),
                                  DropdownButtonFormField(
                                    hint: const Text('Pilih Priorty'),
                                    isExpanded: true,
                                    value: tod['priorty'],
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
                                      Navigator.of(context).pop();
                                      titleC.clear();
                                      desC.clear();
                                    },
                                    child: const Text('No')),
                                TextButton(
                                    onPressed: () {
                                      context.read<TodoBloc>().add(UpdateTodo(
                                          title: titleC.text,
                                          desc: desC.text,
                                          rty: rty.text,
                                          key: tod['key']));
                                      Navigator.of(context).pop();
                                      if (titleC.text == tod['title'] &&
                                          desC.text == tod['desc'] &&
                                          rty.text == tod['priorty']) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('Tidak Ada Yang Berubah'),
                                          duration: Durations.extralong3,
                                          backgroundColor: Colors.orange,
                                        ));
                                      }
                                      titleC.clear();
                                      desC.clear();
                                    },
                                    child: const Text('Yes')),
                              ],
                            ),
                          );
                        },


                        title: Text(
                          tod['title'],
                          style: TextStyle(
                              decoration: (tod['isCompleted'] == true)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        subtitle: Text(
                          tod['desc'],
                          style: TextStyle(
                              decoration: (tod['isCompleted'] == true)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildPriorityWidget(tod['priorty']),
                            Text(tod['datetime'])
                          ],
                        ))),
              ),
            );
          },
        ),
      ),

      // --- Tambahkan Data --- //
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Tambahkan Todo Baru'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(controller: titleC, hint: 'Judul'),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(controller: desC, hint: 'Deskripsi'),
                DropdownButtonFormField(
                  hint: const Text('Pilih Priorty'),
                  isExpanded: true,
                  value: iselected,
                  items: priorty
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                  child: const Text('No')),
              BlocConsumer<TodoBloc, TodoState>(
                builder: (context, state) => TextButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(PostTodo(
                          title: titleC.text, desc: desC.text, rty: rty.text));
                      Navigator.of(context).pop();
                      titleC.clear();
                      desC.clear();
                    },
                    child: const Text('Ya')),
                listener: (context, state) {
                  if (state is Todoloaded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Berhasil Menambahkan Data'),
                      duration: Durations.extralong2,
                      backgroundColor: Colors.green,
                    ));
                  } else if (state is TodoErorr) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Terjadi Kesalahan'),
                        content: Text(state.e),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ya, Mengerti'))
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        );
        
      } ,child: const Icon(Icons.add),),
    );
  }
}

class ContainerPriorty extends StatelessWidget {
  Color color;
  String label;
  ContainerPriorty({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 30,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
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
  MyTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Masukan $hint',
      ),
    );
  }
}

Widget buildPriorityWidget(String priority) {
  switch (priority.toLowerCase()) {
    case 'rendah':
      return ContainerPriorty(color: Colors.greenAccent, label: 'RND');
    case 'tinggi':
      return ContainerPriorty(color: Colors.red, label: 'TNG');
    case 'sedang':
      return ContainerPriorty(color: Colors.orangeAccent, label: 'SDG');
    default:
      return ContainerPriorty(color: Colors.transparent, label: '');
  }
}
