import 'package:flashcard_app/flashcard.dart';
import 'package:flashcard_app/flashcards_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<FlashCards> _flashcards = [
    FlashCards(
        question: "What is Flutter?", answer: "Flutter is an open-source UI "),
    FlashCards(
        question: "What is Stateless widget?",
        answer: "It does not maintain any state "),
    FlashCards(
        question: "What is a Stateful Widget?",
        answer: "It has a mutable state"),
    FlashCards(
        question: "What is a Widget in Flutter?",
        answer: "A Widget is the basic building block of the UI"),
        
  ];

  int _currentIndex = 0;

  void showNextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
    });
  }

  void deleteCard() {
    if (_flashcards.isNotEmpty) {
      setState(() {
        _flashcards.removeAt(_currentIndex);
        _currentIndex =
            _currentIndex % (_flashcards.isEmpty ? 1 : _flashcards.length);
      });
    }
  }

  void editCard() {
    if (_flashcards.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          final TextEditingController questionController =
              TextEditingController(text: _flashcards[_currentIndex].question);
          final TextEditingController answerController =
              TextEditingController(text: _flashcards[_currentIndex].answer);

          return AlertDialog(
            title: const Text('Edit Flashcard'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Question'),
                ),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(labelText: 'Answer'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _flashcards[_currentIndex] = FlashCards(
                      question: questionController.text,
                      answer: answerController.text,
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  // Add Flashcard
  void _addCard() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController questionController =
            TextEditingController();
        final TextEditingController answerController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  setState(() {
                    _flashcards.add(FlashCards(
                      question: questionController.text,
                      answer: answerController.text,
                    ));
                  });
                  Navigator.of(context).pop(); // Close the dialog after saving
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("FlashCard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_flashcards.isEmpty)
              const Text(
                "No flashcards available",
                style: TextStyle(fontSize: 18),
              )
            else
              SizedBox(
                width: 250,
                height: 250,
                child: FlipCard(
                  front: FlashcardsView(
                    text: _flashcards[_currentIndex].question,
                  ),
                  back: FlashcardsView(
                    text: _flashcards[_currentIndex].answer,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (_flashcards.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    onPressed: showPreviousCard,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 163, 191, 7),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: showNextCard,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 163, 191, 7),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: editCard,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 163, 191, 7),
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                ElevatedButton.icon(
                  onPressed: deleteCard,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      // Floating Action Button to add new flashcard
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        backgroundColor: Colors.blue,
        tooltip: 'Add Flashcard',
        child: const Icon(Icons.add),
      ),
    );
  }
}
