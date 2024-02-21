import "dart:convert";
import "dart:io";

void main() async {
  dynamic store;
  dynamic serverFuture = await ServerSocket.bind(InternetAddress.anyIPv4, 5050);
    print("Server Listening on ${InternetAddress.anyIPv4}:${5050}");
    serverFuture.listen((Socket client) async {
      
      client.listen((List<int> data) async {
        print(String.fromCharCodes(data));
      });

      client.add(utf8.encode("Test"));
  ;
    
});}
