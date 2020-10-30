// ignore: slash_for_doc_comments
/**
 * ISIS-3510 Mobile App Development
 * Universidad de Los Andes
 * @author pa-suarezm
 */

import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'MyViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multithreading Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Multithreading Example'),
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Multithreading Example')),
        body: BodyWidget(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MyViewModel>.withConsumer(
        viewModel: MyViewModel(),
        builder: (context, model, child) => Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //-----------------------SEQUENTIAL---------------------------
                  ElevatedButton(
                      onPressed: () {
                        model.executeSeq();
                      },
                      child: Text(
                          'SEQUENTIAL'
                      )
                  ),
                  SizedBox(
                      height: 10
                  ),
                  SizedBox(
                    height: 10,
                    width: 200,
                    child:
                    LinearProgressIndicator(
                        value: model.getCnt('_cntSeq1')
                    ),
                  ),
                  SizedBox(
                      height: 15
                  ),
                  SizedBox(
                    height: 10,
                    width: 200,
                    child:
                    LinearProgressIndicator(
                        value: model.getCnt('_cntSeq2')
                    ),
                  ),
                  SizedBox(
                      height: 10
                  ),
                  Text(
                    'Sequential time completed in: ${model.getTime('_timeSeq')} ms',
                  ),
                  SizedBox(
                      height: 50
                  ),
                  //-----------------------CONCURRENT---------------------------
                  ElevatedButton(
                      onPressed: (){
                        model.executeCon();
                      },
                      child: Text(
                          'CONCURRENT'
                      )
                  ),
                  SizedBox(
                      height: 10
                  ),
                  SizedBox(
                    height: 10,
                    width: 200,
                    child:
                    LinearProgressIndicator(
                        value: model.getCnt('_cntCon1')
                    ),
                  ),
                  SizedBox(
                      height: 15
                  ),
                  SizedBox(
                    height: 10,
                    width: 200,
                    child:
                    LinearProgressIndicator(
                        value: model.getCnt('_cntCon2')
                    ),
                  ),
                  SizedBox(
                      height: 10
                  ),
                  Text(
                    'Concurrent time completed in: ${model.getTime('_timeCon')} ms',
                  ),
                  //------------------------------------------------------------------
                ],
              ),
            ),
          ],
        )
    );
  }
}