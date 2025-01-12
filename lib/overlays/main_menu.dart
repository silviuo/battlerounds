import 'package:battlerounds/battlerounds_game.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final BattleroundsGame game;

  const MainMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.black,
      child: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/main_menu_background.png'),
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Battlerounds',
                style: TextStyle(
                  color: blackTextColor,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.startGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'To Battle!',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
