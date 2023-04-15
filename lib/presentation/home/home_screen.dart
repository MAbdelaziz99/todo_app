import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/constants/components.dart';

import 'cubit/home_cubit.dart';
import 'cubit/home_states.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final taskController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeInsertTaskSuccessState ||
            state is HomeUpdateTaskState) {
          HomeCubit.get(context)
              .getTasks(database: HomeCubit.get(context).database);
        }
      },
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 10.0,
            title: const Text(
              'TODO',
              style: TextStyle(color: Colors.lightBlue, fontSize: 25),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                Navigator.pop(context);
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet((context) {
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0).r,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                    controller: taskController,
                                    hintText: 'Task Title',
                                    keyboardType: TextInputType.text,
                                    errorText: 'Please enter the task title',
                                    prefixIcon: Icons.title),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                defaultTextFormField(
                                    controller: timeController,
                                    hintText: 'Task Time',
                                    keyboardType: TextInputType.none,
                                    errorText: 'Please enter the task time',
                                    onTab: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                  hour: DateTime.now().hour,
                                                  minute:
                                                      DateTime.now().minute))
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    prefixIcon: Icons.access_time),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                defaultTextFormField(
                                    controller: dateController,
                                    hintText: 'Task Date',
                                    keyboardType: TextInputType.none,
                                    errorText: 'Please enter the task date',
                                    onTab: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.parse(
                                                  '${DateTime.now().year + 2}-12-30'))
                                          .then((value) {
                                        dateController.text = DateFormat()
                                            .add_yMMMd()
                                            .format(value!);
                                      });
                                    },
                                    prefixIcon: Icons.date_range),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0)
                                      .r,
                                  child: Container(
                                    height: 40.0.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius:
                                            BorderRadius.circular(10.0).r),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.insertDatabase(
                                              context: context,
                                              title: taskController.text,
                                              time: timeController.text,
                                              date: dateController.text);
                                        }
                                      },
                                      child: Text(
                                        'Add task',
                                        style: TextStyle(
                                            fontSize: 20.0.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetButtonIcon();
                    });

                cubit.changeBottomSheetButtonIcon();
              }
            },
            child: cubit.isBottomSheetShown
                ? const Icon(Icons.arrow_downward)
                : const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 3.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            items: cubit.screenItems,
            onTap: (index) {
              cubit.changeScreen(index: index);
            },
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
