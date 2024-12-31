import 'package:flutter/material.dart';

class MicrophoneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.mic),
          onPressed: () {
            // Mikrofonu açacak işlevi ekleyeceğiz
          },
        ),
        SizedBox(width: 20),
        Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child:
                Text('Ses Dalga Alanı', style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
