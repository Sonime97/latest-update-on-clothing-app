import 'package:flutter/material.dart';
class BorderContainerPage extends StatefulWidget {
  BorderContainerPage({required this.info});
  final info;
  @override
  _BorderContainerPageState createState() => _BorderContainerPageState();
}

class _BorderContainerPageState extends State<BorderContainerPage> {
  int selectedContainer = 1;

  void changeBorder(int containerNum) {
    setState(() {
      selectedContainer = containerNum;
    });
  }

  Widget buildContainer(int containerNum) {
    return GestureDetector(
        onTap: () => changeBorder(containerNum),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selectedContainer == containerNum ? Colors.black : Colors.grey,
              width: 2.0,
            ),
          ),
          child: 
            Center(
              
              child: Text('$containerNum'),
            ),
          
        ),
      );
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height /4.6,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildContainer(43),
                Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContainer(44),
                  buildContainer(45),
                  buildContainer(46),
                ],
              ),
            ),
                
           //     buildContainer(44),
           //     buildContainer(45),
           //     buildContainer(46),
              ],
            ),
            SizedBox(height: 20),
              Container(
                         padding: EdgeInsets.all(2),
                         child: SingleChildScrollView(
                          padding: EdgeInsets.all(0),
                child: Text(
                    '${widget.info}',
                  ),
                
                         ),
                       ),
             

            ],
      ),
    );
      
    
  }
}






