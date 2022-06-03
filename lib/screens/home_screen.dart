import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/cubit/cubit.dart';
import '../cubit/states.dart';

class HomeTasksScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertIntoDBState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screenTitle[cubit.val]),
            ),
            body: cubit.screenToggle[cubit.val],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetVisible) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDB(
                        time: cubit.time, date: cubit.date, title: cubit.title);
                    cubit.changeBottomSheet(Icons.edit, false);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                    elevation: 25,
                    enableDrag: false,
                    (context) => Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// title form field
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'title Must not be empty';
                                }
                                return null;
                              },
                              onChanged: (values) {
                                cubit.title = values;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Task Title',
                                icon: Icon(Icons.title),
                                border: OutlineInputBorder(),
                              ),
                            ),

                            ///
                            const SizedBox(
                              height: 15,
                            ),

                            /// date form field
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-06-29'),
                                ).then((value) {
                                  print(DateFormat.yMMMd().format(value!));
                                  cubit.date = DateFormat.yMMMd().format(value);
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'date ',
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.date_range),
                              ),
                            ),

                            ///
                            const SizedBox(
                              height: 15,
                            ),

                            ///time form field
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  cubit.time =
                                      value!.format(context).toString();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'time ',
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.watch_later_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  cubit.changeBottomSheet(Icons.add, true);

                  // isBottomSheetVisible = true;
                  // cubit.fabIcon = Icons.add;
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeValue(index);
              },
              elevation: 10,
              currentIndex: cubit.val,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Tasks',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
