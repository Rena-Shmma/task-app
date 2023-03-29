import 'package:flutter/material.dart';

import '../cubit/cubit.dart';



Widget buildTaskItem (Map model, context) =>
        Dismissible(
          key: Key(model['id'].toString()),
          onDismissed: (direction){
             AppCubits.get(context).deleteData(id: model['id']);
             AppCubits.get(context).getDataFromDatabase();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Text(
                      '${model["task"]}'
                  ),
                ),
                SizedBox(width: 6,),
                Expanded(
                    child: Column(
                      children: [
                        Text('${model["date"]}'),
                        Text('${model["task"]}'),
                      ],
                    )),
                SizedBox(width: 6,),
                IconButton(
                    onPressed: (){
                      AppCubits.get(context).updateData(
                          id: model['id'],
                          status: 'done' );
                    },
                    icon: Icon(Icons.check_box),
                  color: Colors.green,),
                IconButton(
                    onPressed: (){
                      AppCubits.get(context).updateData(
                          id: model['id'],
                          status: 'archieve' );
                   },
                   icon: Icon(Icons.archive),
                color: Colors.black45,),
              ],
            ),
          ),
        );


Widget tasksBuilder ({required List<Map> tasks})=>
    tasks.length >0 ?
    ListView.builder(
        itemBuilder: (context ,index )=> buildTaskItem(tasks[index], context),
        itemCount: tasks.length)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu,
                  size: 100,
                  color: Colors.grey,),
                Text('No tasks yet,'
                    'please add some tasks',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),)
        ],
      ),
    );





