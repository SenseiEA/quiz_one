import 'package:flutter/material.dart';

class page_free extends StatelessWidget {
  const page_free({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Free Page Module",
        home: Scaffold(
          appBar: AppBar(
            title:Text("Take care of your Pokemon!"),

          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
              children: [

                SizedBox(
                  height :720,
                  child: CarouselView(
                    itemExtent: MediaQuery.sizeOf(context).width - 0,
                    itemSnapping: true,
                    elevation:4,
                    padding: const EdgeInsets.all(10),
                    children: List.generate(5,(int index){
                      return Container(
                          color: Colors.grey,
                        child:Image.network('https://picsum.photos/400?random=$index',
                        fit: BoxFit.cover,
                        ),
                      );

                    }),
                )

                ),
              ]

            ),

          ),
        ),
    );
  }
}
