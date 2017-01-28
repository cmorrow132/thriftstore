package main

import "net"
import "fmt"
//import "bufio"
//import "strings" // only needed below for sample processing

func main() {
	port:=":8891"
	// listen on all interfaces
	ln, _ := net.Listen("tcp", port)
	defer ln.Close()

	fmt.Println("License server listening on port " + port)
	// accept connection on port

	// run loop forever (or until ctrl-c)
	for {
		conn, _ := ln.Accept()
		// will listen for message to process ending in newline (\n)
		//message, _ := bufio.NewReader(conn).ReadString('\n')
		// output message received
		//fmt.Print("Message Received:", string(message))
		// sample process for string received
		//newmessage := strings.ToUpper(message)
		// send new string back to client
		//fmt.Println(message)
		conn.Write([]byte("true" + "\n"))
		//conn.Write([]byte("License is good"))
	}
}
