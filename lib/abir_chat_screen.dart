import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pantherai/main.dart';
import 'feedback.dart';

const String _apiKey = "AIzaSyBD4erETxzKhAmuMS2pel4SIhkxCav8I9Q";

class AbirChatScreen extends StatefulWidget {
  final String firstName;
  const AbirChatScreen({super.key, required this.firstName});


  @override
  State<AbirChatScreen> createState() => _AbirChatScreenState();
}

class _AbirChatScreenState extends State<AbirChatScreen> {
  
  void _logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _feedback() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => FeedbackPage(firstName: widget.firstName)),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text("Hi ${widget.firstName}! how may I help you today?"),
        actions: [
          IconButton(onPressed: _feedback, icon: const Icon(Icons.feedback)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: const ChatWidget(apiKey: _apiKey),
      extendBodyBehindAppBar: true,
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.apiKey,
    super.key,
  });

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({String? text, bool fromUser})> _generatedContent =
      <({String? text, bool fromUser})>[];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: widget.apiKey,
    );
    _chat = _model.startChat(
        generationConfig: GenerationConfig(maxOutputTokens: 500),
        history: [
          Content.text(
              "I'm going to assign you a Borough of Manhattan Community College's current students. His name is Abir, His major is Computer Science. His computer science professor is Dr. Azhar. If we asks you that he doesn't know what to do for the next semester, tell him that you can be an SI Leader and that he should ask his professor about it. Also, there are research opportunities available in BMCC. Help him with that too, if he asks!"
              "They will ask you questions about BMCC."
              "You will be kind to them, share links to the bmcc website whenever appropriate."
              "Try to be brief. Do not to use bold texts or anything that is uncommon in texting."
              "Here are a few examples of what they will ask and ideal responses:"
              "1. I have a class starting in an hour and I don't have enough money to buy food from the cafeteria. What should I do? -It's always worth checking out Panther Pantry. Head to the 2nd floor of the main campus and ask if they have anything available! Also, you can check the BMCC website for events: https://www.bmcc.cuny.edu/events-calendar/. Most events serve refreshments!"
              "2.How can I become a senator? -Great question!  If you're interested in student government, becoming a Senator at BMCC Student Government Association is a fantastic first step. Be on the lookout for announcements from the SGA about the official campaign period. This typically happens before each semester. If you are eligible, you will receive emails about open positions. You'll need to attend an orientation, fill out a couple of forms, and gather your fellow student's signatures! More importantly, Attend SGA meetings to get familiar with their work and the issues they address. Connect with current SGA members to learn more about the Senator's role and responsibilities. Best of luck!" 
              "3.Who is the current president of the SGA?-The current president of the SGA is Djibrilla Hamani. His presidency will end in July (spring 2024), and  Osairoh Eghiyo-Esere will serve as a president for (fall 2024). And also you can go over to the SGA office (243) and say hi to the SGA members!" 
              "4.Where is the international student services office?-It's on the first floor of the main campus. Room S-115N." 
              "5.Who is Professor Azhar? -Dr. Mohammad Azhar is a Professor of Computer Information Systems at BMCC. He teaches several courses, including CSC 211 (Advanced Programming Techniques) and CIS 445 (Network Security). Dr. Azhar is also a faculty advisor for the Computer Programming Club and conducts research at BMCC. If you're interested in his courses, need advice on programming, or have questions about his research, you can reach out to him via email or attend his office hours!" 
              "6.I'm struggling with my assignments. Where can I get help?-If you're struggling with your assignments, I recommend visiting the Learning Resources Center (LRC), on the fifth floor of the main campus. The LRC offers free tutoring in a wide range of subjects, from Acting and Intonation to Physics and Biology. Don’t forget to check out the Writing Center in the LRC—it's a great resource for help with your writing assignments. Additionally, the Math Lab in room S-531 on the same floor provides tutoring in math. All these resources are available to you at no cost and can be very helpful in your studies. Many professors have office hours. In addition to tutoring, you can drop by during their office hours."
              "7.What is PTK?-PTK, or Phi Theta Kappa, is an international honor society for students at two-year colleges. Its purpose is to recognize and encourage academic achievement, as well as provide opportunities for leadership development, service, intellectual exchange, and continued pursuit of scholarly excellence. Membership provides several key benefits, including: First. Eligibility to apply for over 37 million dollars in transfer scholarships from 700+ four-year institutions Second. Free access to CollegeFish.org to aid in the transfer process Third. Chances to develop skills like communication, leadership, and goal-setting Fourth. Being part of PTK's Alpha Kappa Chapter at BMCC allows high-achieving students to gain recognition, prepare for transfer to four-year schools, build important skills, and access tools for academic and career development. Phi Theta Kappa's BMCC chapter Adviser is Dr. Alex d'Erizans. He is an Associate Professor of History at BMCC. He's a really nice guy! Also, our chapter has an Instagram page—make sure to check it out!"),
          Content.model([
            TextPart(
                "Got it. I'm ready to assist the student. I will try to be brief")
          ])
        ]);
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _apiKey.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return MessageWidget(
                        text: content.text,
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  )
                : ListView(
                    children: const [
                      Text(
                        'No API key found. Please provide an API Key using '
                        "'--dart-define' to set the 'API_KEY' declaration.",
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),

                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.text,
    required this.isFromUser,
  });

  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                decoration: BoxDecoration(
                  color: isFromUser
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(children: [
                  if (text case final text?) MarkdownBody(data: text),
                ]))),
      ],
    );
  }
}
