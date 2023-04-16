import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/data/network/local/data.dart';
import 'package:todo_app/presentation/home/cubit/home_cubit.dart';
import 'package:todo_app/presentation/home/cubit/home_states.dart';
import 'package:todo_app/shared/constants/components.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        var tasks = allTaskModels.where((element) => element.status == 'still').toList();
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0).r,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
                child: defaultDivider(),
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.title,
                          size: 40.r,
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          width: 8.0.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 2,
                              child: Text(
                                tasks[index].title ?? '',
                                style: TextStyle(
                                  fontSize: 20.0.sp,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  tasks[index].date ?? '',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '  .  ',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  tasks[index].time ?? '',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                                onPressed: ()
                                {
                                  // Move task to done screen
                                  cubit.updateTask(id: tasks[index].id, status: 'done');
                                },
                                icon: Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                  size: 30.0.r,
                                )),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            IconButton(
                                onPressed: () {
                                  // Move task to archive screen
                                  cubit.updateTask(id: tasks[index].id, status: 'archive');
                                },
                                icon: Icon(
                                  Icons.archive,
                                  color: Colors.red,
                                  size: 30.0.r,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
