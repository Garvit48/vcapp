const net = require("net")

const server = net.createServer(_conn => {
    console.log("Connection recieved")
    
    _conn.setEncoding("utf-8")

    _conn.on("data", encData => {
        let decData = JSON.parse(encData)

        if (decData["type"] == "Matchmake") {

            _conn.emit(JSON.stringify({
                "uID": "",
                "type": "StartCallSender",
                "data": {
                  "rec": ""
                }
              }))

        } else if (decData["type"] == "NewCall") {

        } else if (decData["type"] == "Answer") {

        } else if (decData["type"] == "ICECandidate") {
            console.log("Recieved Candidate")
        } else {
            
        }
    })
    
})

server.listen(5050, () => console.log("Server Started........"))