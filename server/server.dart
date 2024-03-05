import "dart:convert";
import "dart:io";

// Protocol Standard:

// {
//   uID: String
//   type: String,
//   data: Map[]
// }

class Room {
  String? pn1, pn2;
  Socket? p1, p2;
  Room(this.pn1, this.pn2, this.p1, this.p2);

  void start() async {
    print("Room Created");
    p1!.add(utf8.encode(jsonEncode({
      "uID": "",
      "type": "StartCallSender",
      "data": {
        "rec": pn2
      }
    })));
    print("Call Started");
  }
  
}

Map<String, Socket> _matchmakingQueue = {};

Future matchmake() async {
  List _players = _matchmakingQueue.keys.toList();
    if (_players.length >= 2) {
      Room(_players[0], _players[1], _matchmakingQueue[_players[0]], _matchmakingQueue[_players[1]]).start();
      // _matchmakingQueue.remove(_players[0]);
      // _matchmakingQueue.remove(_players[1]);

    }
}

void main() async {
  ServerSocket serverFuture = await ServerSocket.bind(InternetAddress.anyIPv4, 5050);
  print("Server Listening on ${InternetAddress.anyIPv4}:${5050}");

  

  serverFuture.listen((Socket client) {
    String data = "";
    print("Connection from ${client.remoteAddress.address}:${client.port}");
    
    client.listen((List<int> encReq) {

      String str = String.fromCharCodes(encReq);
      data += str;
      if (data[data.length - 1] == "-" && data[data.length - 2] == "-") {
          List objs = data.split("--");
          print(objs);

          for (int i = 0; i < objs.length; i++) {
            String currObjStr = objs[i];

            if (currObjStr != "") {
                      Map req = jsonDecode(currObjStr);

            if (req["type"] == "NewCall") {
              //_matchmakingQueue[req["data"]["rec"]]?.add(encReq);
              
            } else if (req["type"] == "Answer") {

              print("Call Answered (Answer)");
              //_matchmakingQueue[req["data"]["rec"]]?.add(encReq);

            } else if (req["type"] == "ICECandidate") {

              print("Candidate Receieved");
            //_matchmakingQueue[req["data"]["rec"]]?.add(encReq);
      
            } else if (req["type"] == "Matchmake") {

              _matchmakingQueue[req["uID"]] = client;
              matchmake();
                        client.add(utf8.encode(jsonEncode({
            "uID": "",
            "type": "StartCallSender",
            "data": {
              "rec": ""
            }
          })));
          }
            }

          }

          data = "";
      }

});
  }, onDone: () => {print("Data Recieved")});
  print("Done");
}