import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class todo_tile extends StatelessWidget {
  final String text;
  final Function(BuildContext?)? deletetask;
  // final void Function()? hidden;
  final int index;
  // int cnt = 0;

  const todo_tile({
    super.key,
    required this.text,
    required this.deletetask,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, right: 15, left: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deletetask,
              icon: Icons.delete,
              backgroundColor: Colors.green,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: InkWell(
          // onDoubleTap: hidden,
          child: Container(
            height: 160,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                  child: Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.grey[300]),
              )),
            ),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(5, 5),
                      spreadRadius: 1.0,
                      blurRadius: 2),
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 3,
                    offset: Offset(-3, -3),
                    spreadRadius: 1.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(7)),
          ),
        ),
      ),
    );
  }
}
