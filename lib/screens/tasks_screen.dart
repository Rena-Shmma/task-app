import 'package:ddd/cubit/cubit.dart';
import 'package:ddd/cubit/states.dart';
import 'package:ddd/shared/components.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubits, AppState>(
      listener: (context , state){},
      builder:  (context , state){
        return tasksBuilder(tasks: AppCubits.get(context).newTasks);
      }
    );
  }
}

