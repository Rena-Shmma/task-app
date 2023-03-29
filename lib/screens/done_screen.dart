import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/components.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AppCubits, AppState>(
        listener: (context , state){},
        builder:  (context , state){
          return tasksBuilder(tasks: AppCubits.get(context).doneTasks);
        }
    );
  }
}