package main

import (
	"net"
	"net/http"
	"github.com/julienschmidt/httprouter"
	"fmt"
	"text/template"
	"bufio"
	"strings" // only needed below for sample processing
	"time"
	_ "github.com/go-sql-driver/mysql"
	"database/sql"
	"strconv"
	"github.com/gorilla/sessions"
	"github.com/gorilla/context"
	"github.com/nu7hatch/gouuid"
	"log"
)

var (
	returnResponse string
)

var session_id, _ = uuid.NewV4()
var sessionStore = sessions.NewCookieStore([]byte(session_id.String()))

//############################################################
// LICENSE SERVER FUNCTIONS
//############################################################
func verifyLicense(license string) (string) {
	expiry:="not found"

	systemTime:=time.Now().Local();
	currentDate:=strings.Split(systemTime.String()," ")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/LICENSE_SERVER")

	if err != nil {
		fmt.Println(err.Error())
		return "1054,"
	}
	defer db.Close()

	dbQuery := "select expiry from LICENSES WHERE license='" + license + "'"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&expiry)

		if err!=nil {
			fmt.Println(err.Error())
			return "1054,"
		}
	}

	if(expiry=="not found") {
		return "invalid,"
	} else {
		expDateSplit:=strings.Split(expiry,"-")
		currentDateSplit:=strings.Split(currentDate[0],"-")

		expYear,_:=strconv.Atoi(expDateSplit[0])
		expMonth,_:=strconv.Atoi(expDateSplit[1])
		expDay,_:=strconv.Atoi(expDateSplit[2])

		curYear,_:=strconv.Atoi(currentDateSplit[0])
		curMonth,_:=strconv.Atoi(currentDateSplit[1])
		curDay,_:=strconv.Atoi(currentDateSplit[2])

		//fmt.Println("Current date: " + strconv.Itoa(curYear) + "-" + strconv.Itoa(curMonth) + "-" + strconv.Itoa(curDay))
		//fmt.Println("Expiry date: " + strconv.Itoa(expYear) + "-" + strconv.Itoa(expMonth) + "-" + strconv.Itoa(expDay))

		if curYear<expYear {
			return "valid," + expiry
		} else if curMonth<expMonth {
			return "valid," + expiry
		} else if curDay<expDay {
			return "valid," + expiry
		} else {
			return "expired," + expiry
		}
	}
}

//###############################################################################
//# Web functions
//###############################################################################
func doLogin(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	session, _ := sessionStore.Get(r, "ls_webauth")
	session.Values["username"]="admin"
	session.Save(r,w)

	fmt.Fprintf(w,"Success")
}

func pageHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var templateName, templatePath string
	session, _ := sessionStore.Get(r, "ls_webauth")

	if (session.Values["username"] == nil) {
		//Not logged in, redirect to the login page
		templateName = "login.tpl"
	} else {
		templateName = "main.tpl"
	}

	tpl := template.New(templateName)
	templatePath = templateName

	tpl, err := tpl.ParseFiles(templatePath)
	if err != nil {
		log.Fatalln(err.Error())
	}

	err = tpl.Execute(w, nil)
	if err != nil {
		log.Fatalln(err)
	}
}

//###################################################################################
//# Main app
//###################################################################################
func main() {
	appPort:=":8891"
	webPort:="8892"

	go func() {
		router := httprouter.New()
		router.GET("/", pageHandler)
		router.POST("/login",doLogin)

		fmt.Println("Web listener ready on :"+webPort)
		http.ListenAndServe(":"+webPort, context.ClearHandler(router))
	}()

	ln, _ := net.Listen("tcp", appPort)
	defer ln.Close()

	fmt.Println("License server listening on port " + appPort)
	for {
		conn, _ := ln.Accept()
		request, _ := bufio.NewReader(conn).ReadString('\n')
		request = strings.Replace(request, "\n", "", -1)

		command := strings.Split(request, "=")

		if command[0] == "LICENSE" {
			returnResponse = verifyLicense(command[1])
		}

		conn.Write([]byte(returnResponse + ",expiryString\n"))
	}
}
