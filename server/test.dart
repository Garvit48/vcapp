import "dart:convert";
import "dart:io";
void main() async {
  Socket socket = await Socket.connect("192.168.217.1", 5050);
socket.listen((List<int> data) {
    print(String.fromCharCodes(data));
  });
  // Map<String, dynamic> matchmake =  {"uID": "player1", "type": "Matchmake", "data": {}};
  // socket.add(utf8.encode(jsonEncode(matchmake)));
  Map<String, dynamic> message =  {"uID": "player1", "type": "NewCall", "data": {"rec": "player2"}};
  socket.add(utf8.encode(jsonEncode(message)));
  
}