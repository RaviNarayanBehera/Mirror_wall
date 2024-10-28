import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../provider/search_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<SearchEngineProvider>(context);
    var providerFalse =
        Provider.of<SearchEngineProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Clear Search History...'),
                      content: const Text(
                          'Are you sure you want to clear all history?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            providerTrue.clearHistory();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Delete browsing data...",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: providerTrue.history.length,
        itemBuilder: (context, index) {
          final url = providerTrue.history[index];
          return ListTile(
            title: Text(url),
            onTap: () {
              providerTrue.webViewController!.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(url),
                ),
              );
              providerFalse.addUrlToController(url);
              Navigator.pop(context);
            },
            trailing: Consumer<SearchEngineProvider>(
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    value.deleteHistory(index);
                  },
                  icon: const Icon(Icons.cancel_outlined),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
