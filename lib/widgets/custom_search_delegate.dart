import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear_rounded))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankiListeElemani = filteredList[index];
              return Dismissible(
                  background: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      // margin: const EdgeInsets.symmetric(
                      //     horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.red.shade400, Colors.red],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          // ignore: prefer_const_constructors
                          Text(
                            'remove_task',
                            // ignore: prefer_const_constructors
                            style: TextStyle(color: Colors.white),
                          ).tr()
                        ],
                      ),
                    ),
                  ),
                  key: Key(oankiListeElemani.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>()
                        .deleteTask(task: oankiListeElemani);
                  },
                  child: TaskItem(task: oankiListeElemani));
            },
            itemCount: filteredList.length)
        // ignore: prefer_const_constructors
        : Center(child: Text('search_not_found').tr());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
