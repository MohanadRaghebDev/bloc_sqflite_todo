import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TodoCubit cubit = TodoCubit.get(context);

        return ListView.separated(
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(cubit.newTasks[index]['id'].toString()),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).errorColor,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                // direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  cubit.deleteData(cubit.newTasks[index]['id']);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(cubit.newTasks[index]['time']),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cubit.newTasks[index]['title'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(cubit.newTasks[index]['date']),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.updateData(
                                'done', cubit.newTasks[index]['id']);
                          },
                          icon: const Icon(
                            Icons.check_box_sharp,
                            color: Colors.green,
                          )),
                      IconButton(
                        onPressed: () {
                          cubit.updateData(
                              'archive', cubit.newTasks[index]['id']);
                        },
                        icon: const Icon(Icons.archive),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                color: Colors.grey[300],
              );
            },
            itemCount: cubit.newTasks.length);
      },
    );
  }
}
