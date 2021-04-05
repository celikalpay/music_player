import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/components/custom_list_tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  // Music List
  // you will find the code of this tutorial i the link of the description
  // if you want to get music url go to the website below in the desc
  // https://mixkit.co/free-stock-music/
  List musicList = [
    {
      "title": "Tech House vibes",
      "singer": "Alejandro Magaña",
      "url":
          "https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3",
      "coverUrl":
          "https://i.pinimg.com/originals/83/f7/8e/83f78e62feb95acc85d000aaf6350d23.jpg"
    },
    {
      "title": "Hazy After Hours",
      "singer": "Alejandro Magaña2",
      "url":
          "https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3",
      "coverUrl":
          "https://i.pinimg.com/originals/10/57/64/1057649b585652411fc4f61a3c5dc341.jpg"
    },
    {
      "title": "Hip Hop 02",
      "singer": "Lily J",
      "url": "https://assets.mixkit.co/music/preview/mixkit-hip-hop-02-738.mp3",
      "coverUrl":
          "https://i.pinimg.com/originals/10/57/64/1057649b585652411fc4f61a3c5dc341.jpg"
    }
  ];

  // Setting the Player UI Data
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  IconData btnIcon = Icons.play_arrow;

  // Now let's create the player
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  // Now let's make the seek Bar Move
  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.play_arrow;
          // From now on you will only hear the music from the emilator
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Play List",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // The app is compossed o 2 part
          // the first one is the song playlist
          // Now I'm going to import a list ( just to simulate an api call )
          // If you have your own music library you can use an
          // external API
          Expanded(
            child: ListView.builder(
                itemCount: musicList.length,
                itemBuilder: (context, index) => customListTile(
                      onTap: () {
                        playMusic(musicList[index]['url']);
                        setState(() {
                          currentTitle = musicList[index]["title"];
                          currentCover = musicList[index]["coverUrl"];
                          currentSinger = musicList[index]["singer"];
                        });
                      },
                      title: musicList[index]["title"],
                      singer: musicList[index]["singer"],
                      cover: musicList[index]["coverUrl"],
                    )),
          ),

          // Now let's build a costum list tile
          // Now let's Player UI
          // the second one is the player
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x55212121),
                blurRadius: 8.0,
              ),
            ]),
            child: Column(
              children: [
                Slider.adaptive(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {},
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: DecorationImage(
                                image: NetworkImage(currentCover))),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(currentSinger,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.0)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Okey now let's build the pause button
                          if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              btnIcon = Icons.pause;
                              isPlaying = false;
                            });
                          } else {
                            audioPlayer.resume();
                            setState(() {
                              btnIcon = Icons.play_arrow;
                              isPlaying = true;
                            });
                          }
                        },
                        iconSize: 42,
                        icon: Icon(btnIcon),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
