import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      title: 'Primeiro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _fontSize = 20.0;
  final Set<WordPair> _saved = <WordPair>{};

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(pair.asLowerCase,
      style: TextStyle(fontSize: _fontSize)),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random English Words'),
        actions: [
          IconButton(
            onPressed: () => _pushSaved(context),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (context) => SavedWords(saved: _saved)),
    );
  }
}

class SavedWords extends StatelessWidget {
  const SavedWords({super.key, required this.saved});

  final Set<WordPair> saved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Words'),
      ),
      body: ListView(children: [
        for (WordPair pair in saved) Text(pair.asLowerCase),
      ]),
    );
  }
}
