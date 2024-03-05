import "dart:convert";
import "dart:ffi";
import "dart:io";

Future send(Socket? socket) async {
  socket!.add(utf8.encode(jsonEncode({"uID": "uID", "type": "Matchmake", "data": {}})));
}


void main() async {
  Socket? socket = await Socket.connect("172.20.10.6", 5050);
  await send(socket);
  await send(socket);
  await send(socket);
  await send(socket);
  await send(socket);
  await send(socket);
  await send(socket);
  // Map<String, dynamic> matchmake =  {"uID": "player1", "type": "Matchmake", "data": {}};
  // socket.add(utf8.encode(jsonEncode(matchmake)));
}