package main

import (
	"net"
	"fmt"
	"bufio"
	"strings" // only needed below for sample processing
	"time"
	_ "github.com/go-sql-driver/mysql"
	"database/sql"
	"strconv"
)

var (
	returnResponse string
)

func verifyLicense(license string) (string) {
	expiry:="not found"
	licenseStatus:="valid"

	systemTime:=time.Now().Local();
	currentDate:=strings.Split(systemTime.String()," ")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/LICENSE_SERVER")

	if err != nil {
		fmt.Println(err.Error())
		return "1054"
	}
	defer db.Close()

	dbQuery := "select expiry from LICENSES WHERE license='" + license + "'"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&expiry)

		if err!=nil {
			fmt.Println(err.Error())
			return "1054"
		}
	}

	if(expiry=="not found") {
		licenseStatus="invalid"
	} else {
		expDateSplit:=strings.Split(expiry,"-")
		currentDateSplit:=strings.Split(currentDate[0],"-")

		expYear,_:=strconv.Atoi(expDateSplit[0])
		expMonth,_:=strconv.Atoi(expDateSplit[1])
		expDay,_:=strconv.Atoi(expDateSplit[2])

		curYear,_:=strconv.Atoi(currentDateSplit[0])
		curMonth,_:=strconv.Atoi(currentDateSplit[1])
		curDay,_:=strconv.Atoi(currentDateSplit[2])

		if curYear>expYear {
			fmt.Println("Current year = " + strconv.Itoa(curYear) + " , expYear = " + strconv.Itoa(expYear))
			licenseStatus="expired"
		} else if curMonth>expMonth {
			fmt.Println("Current month = " + strconv.Itoa(curMonth) + " , expMonth = " + strconv.Itoa(expMonth))
			licenseStatus="expired"
		} else if curDay>expDay {
			fmt.Println("Current day = " + strconv.Itoa(curDay) + " , expDay = " + strconv.Itoa(expDay))
			licenseStatus="expired"
		}
	}

	return licenseStatus
}

func main() {
	port:=":8891"

	ln, _ := net.Listen("tcp", port)
	defer ln.Close()

	fmt.Println("License server listening on port " + port)

	for {
		conn, _ := ln.Accept()
		request, _ := bufio.NewReader(conn).ReadString('\n')
		request=strings.Replace(request, "\n","",-1)

		command:=strings.Split(request,"=")

		if command[0]=="LICENSE" {
			returnResponse=verifyLicense(command[1])
		}

		conn.Write([]byte(returnResponse + "\n"))
	}
}
