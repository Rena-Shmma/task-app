

import 'package:ddd/cubit/cubit.dart';
import 'package:ddd/cubit/states.dart';
import 'package:ddd/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../screens/archieve screen.dart';
import '../../screens/done_screen.dart';


class LayoutScreen extends StatelessWidget {

  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var scaffoldKey= GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubits()..initSql()..getDataFromDatabase(),
      child: BlocConsumer<AppCubits, AppState>(
       listener: (BuildContext context,AppState state){

          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }


        },
        builder: (BuildContext context , AppState state){

          AppCubits cubit =AppCubits.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('${cubit.titles[cubit.currentIndex]}'),
            ),
            body: state is! AppGetDatabaseLoadingState?
            cubit.screens[cubit.currentIndex]
          : Center(child: CircularProgressIndicator(),),

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.edit),label:'Tasks' ),
                BottomNavigationBarItem(icon: Icon(Icons.done),label:'Done' ),
                BottomNavigationBarItem(icon: Icon(Icons.archive),label:'Archieve' ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()async{
                if (cubit.isBottomSheetShown ){
                  if(_formKey.currentState!.validate()){
                    cubit.insertToDatabese(
                        title: "${taskController.text}",
                        date:  "${dateController.text} "
                    );
                    cubit.changeBottomNavbarShow(
                        icon: Icons.add, shown: false);
                    cubit.list=[];

                  }
                }
                else {
                  scaffoldKey.currentState
                      ?.showBottomSheet<void>(
                        (BuildContext context) =>
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 400,
                          color: Colors.grey[300],
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: taskController,
                                  keyboardType: TextInputType.text,
                              validator: (value) {
                                if ( value!.isEmpty) {
                                  return 'Please enter task name';
                                }
                                return null;
                              },
                                  decoration: InputDecoration(
                                      labelText: 'Task name',
                                      icon: Icon(Icons.edit)
                                  ),
                                ),
                                TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select task time';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.watch_later),
                                        labelText: 'Task time'
                                    ),
                                    onTap: () async {
                                      TimeOfDay? pickedTime = await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      if (pickedTime != null) {
                                        dateController.text =
                                            pickedTime.format(context);
                                      }
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20,
                  ).closed
                      .then((value) {
                        taskController.text='';
                        dateController.text='';
                        cubit.changeBottomNavbarShow(
                            icon: Icons.edit,
                            shown: false);
                  });
                  cubit.changeBottomNavbarShow(
                      icon: Icons.add,
                      shown: true);
                  cubit.getDataFromDatabase();
                }
              },
              child: Icon(cubit.fabIcon),
            ),
          );
        },
      ),
    );
  }

 }


