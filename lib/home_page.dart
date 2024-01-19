import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fly_bird/barrier.dart';
import 'package:fly_bird/bird_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double verticalAxisBird = 0;
  double time = 0;
  double height = 0;
  static double barrierOne = 1;
  double barrierTwo = barrierOne + 1.8;
  double initialHeight = verticalAxisBird;
  bool gameStarted = false;
  int score = 0;
  int highestScore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = verticalAxisBird;
    });
  }

  void loadHighestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highestScore = prefs.getInt('highestScore') ?? 0;
    });
  }

  void saveHighestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highestScore', highestScore);
  }

  void showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                Text('Your score: $score'),
                Text('Highest score: $highestScore'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                restartGame();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      // Reset the game state to its initial values
      verticalAxisBird = 0;
      time = 0;
      height = 0;
      barrierOne = 2;
      barrierTwo = barrierOne + 1.8;
      initialHeight = verticalAxisBird;
      gameStarted = false;
      score = 0;
    });

    // Optionally, you can also restart the game automatically
    // startGame();
  }

  void checkCollision() {
    // Adjust these values based on your game design
    double birdSize = 1; // Assuming the bird's size is 50x50

    if (
        // Check for collision with barrierOne
        (verticalAxisBird + birdSize / 2 > 1.1 &&
                verticalAxisBird - birdSize / 2 < 1.1 &&
                barrierOne > -0.5 &&
                barrierOne < 0.5) ||
            (verticalAxisBird + birdSize / 2 > -1.1 &&
                verticalAxisBird - birdSize / 2 < -1.1 &&
                barrierOne > -0.5 &&
                barrierOne < 0.5) ||
            // Check for collision with barrierTwo
            (verticalAxisBird + birdSize / 2 > 1.1 &&
                verticalAxisBird - birdSize / 2 < 1.1 &&
                barrierTwo > -0.5 &&
                barrierTwo < 0.5) ||
            (verticalAxisBird + birdSize / 2 > -1.1 &&
                verticalAxisBird - birdSize / 2 < -1.1 &&
                barrierTwo > -0.5 &&
                barrierTwo < 0.5)) {
      // Collision detected, game over
      gameOver();
    }
  }

  void gameOver() {
    setState(() {
      gameStarted = false;
    });
    showGameOverDialog(context);
  }

  void startGame() {
    gameStarted = true;
    setScore();
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.5 * time;
      setState(() {
        verticalAxisBird = initialHeight - height;
        barrierOne -= 0.05;
        barrierTwo -= 0.05;
      });

      setState(() {
        if (barrierOne < -1.1) {
          barrierOne += 3;
        } else {
          barrierOne -= 0.05;
        }
      });
      setState(() {
        if (barrierTwo < -1.1) {
          barrierTwo += 3;
        } else {
          barrierTwo -= 0.05;
        }
      });
      checkCollision();
      if (verticalAxisBird > 1) {
        setState(() {
          timer.cancel();
          gameStarted = false;
          showGameOverDialog(context);
        });
      }
    });
  }

  void setScore() {
    if (gameStarted) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          score++;
          if (score > highestScore) {
            setState(() {
              highestScore = score;
              saveHighestScore();
            });
          }
        });

        if (verticalAxisBird > 1) {
          setState(() {
            timer.cancel();
            gameStarted = false;
          });
        }
      });
      if (score > highestScore) {
        setState(() {
          highestScore = score;
        });
      }
    }
  }

  @override
  void initState() {
    loadHighestScore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (gameStarted) {
            jump();
          } else {
            startGame();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(0, verticalAxisBird),
                    color: Colors.blue,
                    child: const BirdGif(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: (gameStarted)
                        ? const Text("")
                        : const Text(
                            "T A P   T O   P L A Y",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierOne, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBrarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierOne, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBrarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierTwo, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBrarrier(
                      size: 100.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierTwo, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBrarrier(
                      size: 250.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.brown,
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Score",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            score.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Best Score",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            highestScore.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
