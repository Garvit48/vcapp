const net = require("net")

const client = net.createConnection(5050, "172.20.10.6", () => {
    console.log("Connection Established")
})
