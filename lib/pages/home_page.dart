import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/helper/translations.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/custom_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          // ignore: prefer_const_constructors
          child: Text(
            'title',
            // ignore: prefer_const_constructors
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oankiListeElemani = _allTasks[index];
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
                              style: const TextStyle(color: Colors.white),
                            ).tr()
                          ],
                        ),
                      ),
                    ),
                    key: Key(oankiListeElemani.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: oankiListeElemani);
                      setState(() {});
                    },
                    child: TaskItem(task: oankiListeElemani));
              },
              itemCount: _allTasks.length)
          // ignore: prefer_const_constructors
          : Center(child: Text('empty_task_list').tr()),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.isNotEmpty) {
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationsHelper.getDeviceLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev = Task.create(value, time);

                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    getAllTaskFromDb();
  }
}
