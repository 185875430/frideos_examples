import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/streamed_map_bloc.dart';

import '../blocs/streamed_map_clean_bloc.dart';
import '../screens/streamed_map_clean_page.dart';
import '../styles.dart';

class StreamedMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: const Text('StreamedMap'),
        ),
        body: StreamedMapWidget(),
      ),
    );
  }
}

class StreamedMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedMapBloc bloc = BlocProvider.of(context);

    return Column(
      children: <Widget>[
        Container(height: 16),
        RaisedButton(
          child: const Text('Classic BLoC'),
          onPressed: () {
            final bloc = StreamedMapCleanBloc();

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        bloc: bloc,
                        child: StreamedMapCleanPage(),
                      ),
                ));
          },
        ),
        StreamBuilder<String>(
            stream: bloc.streamedText.outTransformed,
            builder: (context, snapshot) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Text:',
                        hintText: 'Insert a text...',
                        errorText: snapshot.error,
                      ),
                      onChanged: bloc.streamedText.inStream,
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<int>(
            stream: bloc.streamedKey.outTransformed,
            builder: (context, snapshot) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Key:',
                        hintText: 'Insert an integer...',
                        errorText: snapshot.error,
                      ),
                      // To avoid the user could insert text use the
                      // TextInputType.number. Here is commented to
                      // show the error msg.
                      // keyboardType: TextInputType.number,
                      onChanged: bloc.streamedKey.inStream,
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<bool>(
            stream: bloc.isFilled,
            builder: (context, snapshot) {
              return RaisedButton(
                color: buttonColor,
                child: const Text('Add text'),
                onPressed: snapshot.hasData ? bloc.addText : null,
              );
            }),
        Container(height: 20),
        Expanded(
          child: ValueBuilder<Map<int, String>>(
            streamed: bloc.streamedMap,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final key = snapshot.data.keys.elementAt(index);
                    return Center(
                      child: Text('Key $key: ${snapshot.data[key]}',
                          style: styleValue),
                    );
                  });
            },
            noDataChild: const Text('NO DATA'),
          ),
        ),
      ],
    );
  }
}
