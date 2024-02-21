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

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  

  MediaStream? _localStream;
  Socket? socket;
  RTCPeerConnection? _conn;

  void matchmake() async {
    socket = await Socket.connect("3.105.228.41", 5050);
    socket!.listen((List<int> recvEncData) async {


      Map recvDecData = jsonDecode(String.fromCharCodes(recvEncData));

      if (recvDecData["type"] == "StartCallSender") {
        print("StartCallSender");
        RTCSessionDescription _offer = await _conn!.createOffer();
        _conn!.setLocalDescription(_offer);

        recGlobal = recvDecData["data"]["rec"];
        print(jsonEncode({
          "sender": uID,
          "type": "NewCall",
          "data": {
            "rec": recGlobal,
            "offer": {"sdp": _offer.sdp, "type": _offer.type}
          }
        }));
        socket!.add(utf8.encode(jsonEncode({
          "sender": uID,
          "type": "NewCall",
          "data": {
            "rec": recGlobal,
            "offer": {"sdp": "_offer.sdp", "type": _offer.type}
          }
        })));
      }
      
      else if (recvDecData["type"] == "NewCall") {

        setState(() { recGlobal = recvDecData["sender"]; });

        RTCSessionDescription _incOffer = RTCSessionDescription(recvDecData["data"]["offer"]["sdp"], recvDecData["data"]["offer"]["type"]);
        _conn!.setRemoteDescription(_incOffer);
        RTCSessionDescription _ans = await _conn!.createAnswer();
        _conn!.setLocalDescription(_ans);

        socket!.add(utf8.encode(jsonEncode({
          "sender": uID,
          "type": "Answer",
          "data": {
            "rec": recGlobal,
            "answer": {"sdp": _ans.sdp, "type": _ans.type}
          }
        })));

      } else if (recvDecData["type"] == "Answer") {
        RTCSessionDescription _ans = RTCSessionDescription(recvDecData["data"]["answer"]["sdp"], recvDecData["data"]["answer"]["type"]);

        _conn!.setRemoteDescription(_ans);

      } else if (recvDecData["ICECandidate"]) {
        _conn!.addCandidate(RTCIceCandidate(recvDecData["data"]["ICECandidate"]["candidate"], recvDecData["data"]["ICECandidate"]["sdpMid"], recvDecData["data"]["ICECandidate"]["sdpMLineIndex"]));
      }

    });

    socket!.add(utf8.encode(jsonEncode({"uID": uID, "type": "Matchmake", "data": {
      "rec": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }})));
    print("Sent Request");
  }


  void initAsync() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _conn = await createPeerConnection(_config);
    // _conn!.onIceCandidate = (e) {
    //   socket!.add(utf8.encode(jsonEncode({
    //     "uID": uID,
    //     "type": "ICECandidate",
    //     "data": {
    //       "rec": recGlobal,
    //       "ICECandidate": {"candidate": e.candidate, "sdpMid": e.sdpMid, "sdpMLineIndex": e.sdpMLineIndex}
    //     }
    //   })));
    // };

    // _conn!.onTrack = (e) {
    //   _remoteRenderer.srcObject = e.streams[0];
    //   setState(() {});
    // };

    
    _localStream = await navigator.mediaDevices.getUserMedia( { "audio": true, "video": true } );
    _localRenderer.srcObject = _localStream;
    // _localStream!.getTracks().forEach((track) {
    //   _conn!.addTrack(track, _localStream!);
    // });
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
        OutlinedButton(onPressed: matchmake, child: Text("Start Call"))
      ]),
    );
  }
}