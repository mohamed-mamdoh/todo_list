import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/components/components.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget {

  bool loading = true;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);



 // void initState() {
   // super.initState();
    //Future.delayed(Duration.zero).then((_) async {
      //await createDataBase();
      //setState(() {
        //loading = false;
      //});
    //});
 // }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
     create: (BuildContext context)=>AppCubit()..createDataBase(),

      child: BlocConsumer<AppCubit,AppStates>(

        listener: (BuildContext context, AppStates state)=>{
          if(state is AppInsertDataBaseState){
          Navigator.pop(context)
          }
        },
        builder: (BuildContext context, AppStates state){
         AppCubit cubit=AppCubit.get(context);
         return Scaffold(
            key: scaffoldKey,
             appBar: AppBar(
               title: Text(
                cubit.titles[cubit.currentIndex],
            ),
           ),
             body:ConditionalBuilder(
              condition:state is! AppGetDataBaseLoadingState,
              builder: (context)=>cubit.screens[cubit.currentIndex],
              fallback: (context)=> const Center(child:CircularProgressIndicator()),

          ),
                 floatingActionButton: FloatingActionButton(
                    onPressed: () {
                   if (cubit.isBottomSheetShown) {
                  final FormState formState = formKey.currentState!;
                   bool val = formState.validate();
                   if (val) {
                    cubit.insertToDataBase(
                    title: titleController.text,
                    date: dateController.text,
                      time: timeController.text,
                    ).then((value) {
        cubit.getDataFromDataBase(cubit.database);
    });
    }
                   else {
                  scaffoldKey.currentState!.showBottomSheet(
                  (context) =>
                       Container(
                         color: Colors.grey[100],
                        padding: const EdgeInsets.all(20.0),
                         child: Form(
                           key: formKey,
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                              defaultFormField(
                            controller: titleController,
                                type: TextInputType.text,
                                validate: (String value) {
                                print(value);
                                if (value.isEmpty) {
                                  return 'Title Must Be Not Empty';
                                    }
                              },
                             label: 'Task Title',
                              prefix: Icons.title,
                                ),
                                 const SizedBox(
                                 height: 15.0,
                               ),
                                 defaultFormField(
                              controller: timeController,
                               type: TextInputType.datetime,
                                 onTap: () {
                                   showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                    value!.format(context).toString();
                                      print(value.format(context));
                                      });
                                       },
                                    validate: (String value) {
                                    print(value);
                                   if (value.isEmpty) {
                                   return 'Time Must Be Not Empty';
                                   }
                                     },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                     ),
                                   const SizedBox(
                                height: 15.0,
                                    ),
                                   defaultFormField(
                                    controller: dateController,
                                   type: TextInputType.datetime,
                                   onTap: () {
                                 showDatePicker(
                                 context: context,
                                 initialDate: DateTime.now(),
                                 firstDate: DateTime.now(),
                                   lastDate: DateTime.parse(
                                     '2023-08-12'),
                                     ).then((value) {
                               dateController.text =
                              DateFormat.yMMMd().format(value!);
                                 });
                               },
                             validate: (String value) {
                              print(value);
                             if (value.isEmpty) {
                             return 'Date Must Be Not Empty';
                                }
                                },
                                label: 'Task Date',
                               prefix: Icons.calendar_today,
                              ),
                                  ],
                               ),
                         ),
                             ),
                      elevation: 20.0,
                      ).closed.then((value) {
                          cubit.changeBottomSheetsState(
                       isShow: false, icon: Icons.edit,);
                         });
                              cubit.changeBottomSheetsState(
                            isShow: true, icon: Icons.add,);
                          }

                          }

                           },


                      child: Icon(
                      cubit.fabIcon,
                     )

                    ),


                bottomNavigationBar: BottomNavigationBar(
                   type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                       onTap: (index) {

                       cubit.changeIndex(index);

                       },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                    Icons.menu,
                    ),
                   label: 'Tasks',
                        ),
                    BottomNavigationBarItem(
                     icon: Icon(
                    Icons.check_circle_outline,
                    ),
                        label: 'Done',
                   ),
                    BottomNavigationBarItem(
                      icon: Icon(
                         Icons.archive_outlined,
                        ),
                      label: 'Archived',
                     ),
                     ],
                       ),
         );





        })

    );

  }




}
