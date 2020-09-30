import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kmb/PathTimer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:kmb/Indicator.dart';
import 'GoogleMapWidget.dart';
import 'KmbCard.dart';
import 'apiCall/getData/getData.dart';
import 'apiCall/getData/ChallengeDataJson.dart';

class MainBody extends StatefulWidget {
  final List<ChallengeData> passInData;
  const MainBody({this.passInData});

  @override
  MainBodyState createState() => MainBodyState();
}

class MainBodyState extends State<MainBody> {
  var _apiReturnData = List<ChallengeData>();
  bool successfulDrop = false;
  var dragSuccessTemp;

  var path;
  var centerPoint;
  var allStop;
  PageController pageController = PageController();

  var font30White = TextStyle(
    fontSize: 30,
    color: Colors.white,
  );

  void retrievePathResult(input) {
    setState(() => {path = input});
    print("MOTHERFUCKERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(path
        .elementAt(0)
        .points[(path.elementAt(0).points.length / 2).round()]);
  }

  void retrieveStop(input) {
    setState(() => {allStop = input});
  }

  @override
  void initState() {
    fetchData().then((value) {
      print('Async done');
      _apiReturnData = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ogSize = MediaQuery.of(context).size;
    print(ogSize);

    return Column(
      children: <Widget>[
        // top part of the app(KMB Logo)
        Container(
          height: 100,
          margin: const EdgeInsets.only(
            top: 15,
          ),
          child: Align(
            alignment: Alignment.center,
            child: widget.passInData.length == 0
                ? FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) => ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...(_apiReturnData as List<ChallengeData>)
                            .map((passInData) => Draggable(
                                  data: passInData,
                                  child: KmbCard(passInData: passInData),
                                  feedback: KmbCard(passInData: passInData),
                                  //allow us to if there are two widget scroll in a same direction, if yes can set affinity to limit it.
                                  affinity: Axis.vertical,
                                ))
                            .toList()
                      ],
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...(widget.passInData as List<ChallengeData>)
                          .map((passInData) => Draggable(
                                data: passInData,
                                child: KmbCard(passInData: passInData),
                                feedback: KmbCard(passInData: passInData),
                                //allow us to if there are two widget scroll in a same direction, if yes can set affinity to limit it.
                                affinity: Axis.vertical,
                              ))
                          .toList()
                    ],
                  ),
          ),
        ),
        // below code is the "display details part"

        Column(
          children: <Widget>[
            Container(
              width: ogSize.width,
              height: MediaQuery.of(context).size.height - 230,
              margin: const EdgeInsets.only(
                top: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  DragTarget(
                    builder: (context, List<ChallengeData> candidateData,
                        rejectedData) {
                      return successfulDrop
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  dragSuccessTemp.company,
                                  style: font30White,
                                ),
                                Text(
                                  dragSuccessTemp.startingPoint,
                                  style: font30White,
                                ),
                                Text(
                                  dragSuccessTemp.direction,
                                  style: font30White,
                                ),
                                Text(
                                  dragSuccessTemp.destination,
                                  style: font30White,
                                ),
                              ],
                            )
                          : Align(
                              alignment: Alignment(0, 0),
                              child: Text(
                                'Empty dropzone',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            );
                    },
                    onWillAccept: (data) {
                      print("onWillAccept");
                      return true;
                    },
                    onAccept: (data) {
                      print("onAccept");
                      getPath(data.route, retrievePathResult, retrieveStop);
                      print("I just set state TESTING:");
                      print(path);

                      if (data.id != 0) {
                        setState(() {
                          successfulDrop = true;
                          dragSuccessTemp = data;
                        });
                        return true;
                      } else {
                        return Text('Almost there !!!');
                      }
                    },
                  ),
                  //Google Map
                  GoogleMapWidget(passInPathList: path),
                  PathTimer(passInStopList: allStop != null ? allStop : null)
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: SlideEffect(),
            ),
          ],
        ),
      ],
    );
  }
}
