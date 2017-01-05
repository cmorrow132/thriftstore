package main

import (
	"fmt"
	"text/template"
	"net/http"
	//"io"
	"log"
	_ "github.com/go-sql-driver/mysql"
	"github.com/julienschmidt/httprouter"
	"database/sql"
	//"strings"
	"strconv"
)

type PageTags struct {
	ActionTitle	string
}

var (
	dbUsername string
	dbPassword string
	dbLoginString string
	dbQuery string
	proxyURL string
)

func setVars() (int) {
	dbUsername="goservices"
	dbPassword="C7163mwx!"
	dbLoginString=dbUsername+":"+dbPassword
	return 9000
}

func pageHandler(w http.ResponseWriter,r *http.Request, params  httprouter.Params) {
	//Load the main template
	tpl:=template.New("main.tpl")

	tpl,err=tpl.ParseFiles("templates/main.tpl")
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,PageTags{Title:"Mobile Inventory Management",})
	if err!=nil {
		log.Fatalln(err)
	}
}

func main() {
	port:=strconv.Itoa(setVars())
	router:=httprouter.New()
	router.NotFound=http.HandlerFunc(errorPage)

	router.GET("/",pageHandler)
	router.POST("/",pageHandler)
	fmt.Println("Product Management System listening and ready on port: " +port)
	http.ListenAndServe(":"+port,router)
}
