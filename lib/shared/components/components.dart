import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.white,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      color: background,
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

TextFormField defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required Function? validate,
  required String label,
  required IconData prefix,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      validator: (s) {
        var res = validate!(s);
        return res;
      },
      keyboardType: type,
      onChanged: (s) => onChanged?.call(s),
      onFieldSubmitted: (s) => onSubmit?.call(s),
      onTap: () => onTap?.call(),
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
      ),
    );

Widget buildTaskItem(Map model,context)=>Dismissible(
  key:(model['id']),
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
         CircleAvatar(
          radius: 35.0,
          child: Text(
            '${model['time']}',
          ),
        ),
        const SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:CrossAxisAlignment.start,
            children:   [
  
              Text(
                '${model['title']}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
  
              ),
              Text(
                '${model['date']}',
                style: const TextStyle(color: Colors.grey),
  
  
              ),
            ],
          ),
        ),
        const SizedBox(width: 20.0,),
        IconButton(
            onPressed: (){
              AppCubit.get(context).upData(status: 'done', id: model['id']);
  
            },
            icon:const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
  
        ),
        IconButton(
          onPressed: (){
            AppCubit.get(context).upData(status: 'archive', id: model['id']);
          },
          icon:const Icon(
            Icons.archive,
            color: Colors.black45,
          ),
  
        )
  
      ],
  
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id:model['id']);

  },
);

Widget tasksBuilder({
  required List<Map>tasks,

})=>ConditionalBuilder(
  condition:tasks.isNotEmpty,
  builder:(context)=> ListView.separated(

    itemBuilder: (context,index) =>buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index) =>Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount:tasks.length,
  ),
  fallback: (context)=>Center(

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,

        ),
        Text(
          'No Tasks Yet,Please Add Some Tasks ',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),

);
