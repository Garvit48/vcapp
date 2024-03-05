import "dart:io";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_webrtc/flutter_webrtc.dart";

const Map<String, dynamic> _config = {
  "iceServers": [
    {
      'urls': [
        'stun:stun1.l.google.com:19302',
        'stun:stun2.l.google.com:19302',
        'stun:stun3.l.google.com:19302',
        'stun:stun4.l.google.com:19302',
      ],
    }
  ]
}; 

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String uID = "Player2";
  String recGlobal = "";
  int count = 0;
  List<RTCIceCandidate> candidates = [];

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  

  MediaStream? _localStream;
  Socket? socket;
  RTCPeerConnection? conn;

  void send(Map formattedData) {
    String msg = jsonEncode(formattedData);
    socket!.add(utf8.encode("--$msg--"));
  }


  void matchmake() async {
    socket = await Socket.connect("172.20.10.6", 5050);
    await socket!.listen((List<int> recvEncData) async {

        String str = String.fromCharCodes(recvEncData);
        List objs = str.split("--");

        for (int i = 0; i < objs.length; i++) {
          Map recvDecData = jsonDecode(objs[i]);

          if (recvDecData["type"] == "StartCallSender") {
            print("StartCallSender");

            RTCSessionDescription offer = await conn!.createOffer();
            conn!.setLocalDescription(offer);

            recGlobal = recvDecData["data"]["rec"];
            
            send({
              "sender": uID,
              "type": "NewCall",
              "data": {
                "rec": recGlobal,
                "offer": {"sdp": offer.sdp, "type": offer.type}
              }
            });
            
          }
          
          else if (recvDecData["type"] == "NewCall") {

            setState(() { recGlobal = recvDecData["sender"]; });

            RTCSessionDescription _incOffer = RTCSessionDescription(recvDecData["data"]["offer"]["sdp"], recvDecData["data"]["offer"]["type"]);
            conn!.setRemoteDescription(_incOffer);
            RTCSessionDescription _ans = await conn!.createAnswer();
            conn!.setLocalDescription(_ans);

            send({
              "sender": uID,
              "type": "Answer",
              "data": {
                "rec": recGlobal,
                "answer": {"sdp": _ans.sdp, "type": _ans.type}
              }
            });
            

          } else if (recvDecData["type"] == "Answer") {
            RTCSessionDescription _ans = RTCSessionDescription(recvDecData["data"]["answer"]["sdp"], recvDecData["data"]["answer"]["type"]);

            conn!.setRemoteDescription(_ans);

          } else if (recvDecData["type"] == "ICECandidate") {

            conn!.addCandidate(RTCIceCandidate(recvDecData["data"]["ICECandidate"]["candidate"], recvDecData["data"]["ICECandidate"]["sdpMid"], recvDecData["data"]["ICECandidate"]["sdpMLineIndex"]));


          }
        }


    });

    send({"uID": uID, "type": "Matchmake", "data": {}});
    print("Sent Request");
  }


  void initAsync() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    conn = await createPeerConnection(_config);

        conn!.onIceCandidate = (e) {
          send({
              "uID": uID,
              "type": "ICECandidate",
              "data": {
                "rec": recGlobal,
                "ICECandidate": {"candidate": e.candidate, "sdpMid": e.sdpMid, "sdpMLineIndex": e.sdpMLineIndex}
              }
          });

          
    };
    

    conn!.onTrack = (e) {
      _remoteRenderer.srcObject = e.streams[0];
      setState(() {});
    };

    
    _localStream = await navigator.mediaDevices.getUserMedia( { "audio": true, "video": true } );
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      conn!.addTrack(track, _localStream!);
    });
    setState(() {});
    
  }
  @override
  void initState() {
    
    initAsync();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    final TextEditingController _callerIDController = TextEditingController();
    

    
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[

        
          Expanded(child: Container(child: RTCVideoView(_localRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,), decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black)),)),
          Expanded(child: Container(child: RTCVideoView(_remoteRenderer), decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black)),)),
        TextField(
          controller: _callerIDController,
        ),
        OutlinedButton(onPressed: () async {matchmake();}, child: Text("Start Call"))
      ]),
    );
  }
}