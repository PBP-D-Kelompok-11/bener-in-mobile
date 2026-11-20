import 'package:flutter/material.dart';

import '../data/benerin_api.dart';

class ApiPanel<T> extends StatefulWidget {
  const ApiPanel({super.key, required this.load, required this.builder});

  final Future<T> Function() load;
  final Widget Function(T) builder;

  @override
  State<ApiPanel<T>> createState() => _ApiPanelState<T>();
}

class _ApiPanelState<T> extends State<ApiPanel<T>> {
  late Future<T> _result = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _result,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LinearProgressIndicator();
        }

        final error = snapshot.error;
        if (error != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                error is ApiException
                    ? error.message
                    : 'Data dari backend belum bisa dimuat.',
              ),
              TextButton(
                onPressed: () => setState(() => _result = widget.load()),
                child: const Text('Coba lagi'),
              ),
            ],
          );
        }
        return widget.builder(snapshot.data as T);
      },
    );
  }
}
