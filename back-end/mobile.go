package main

import (
	"fmt"
	"text/template"
	"net/http"
	//"io"
	"log"
	_ "github.com/go-sql-driver/mysql"
	"github.com/julienschmidt/httprouter"
	//"database/sql"
	//"strings"
	"strconv"
	"math/rand"
)

type PageTags struct {
	ActionTitle	string
	BarCodeID	string
	GlobalDiscount1	string
	GlobalDiscount2	string
	BarcodeBtnColor	string
	BarcodeBtnLabel string
	//BarcodeButtonID	string
	BarcodeButtonFunc string
}

var (
	dbUsername string
	dbPassword string
	dbLoginString string
	dbQuery string
	proxyURL string
	barCodeID string
	barCodeBtnColor string
	barCodeBtnLabel string
	//barCodeButtonID	string
	barCodeButtonFunc string
)

func setVars() (int) {
	dbUsername="goservices"
	dbPassword="C7163mwx!"
	dbLoginString=dbUsername+":"+dbPassword
	return 8890
}

func ajaxRequests(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w,strconv.Itoa(rand.Intn(5000)) +"-" + strconv.Itoa(rand.Intn(5000)) + "-" + strconv.Itoa(rand.Intn(5000)))
}

func pageHandler(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	//Load the main template
	var pageTitle,templateName string

	pageRequest:=ps.ByName("page")

	switch pageRequest {
		case "mkBarCode":
			ajaxRequests(w,r,ps)
			return
		case "new-item":
			pageTitle="Add Inventory"
			templateName="item.tpl"
			barCodeBtnColor="#A06100"
			barCodeBtnLabel="New"
			//barCodeButtonID="bCodeNew"
			barCodeID="<empty>"
			barCodeButtonFunc="generateNewCode()"			
		case "get-item":
			pageTitle="Item Lookup"
			templateName="item.tpl"
			barCodeBtnColor="#1F8603"
			barCodeBtnLabel="Print"
			//barCodeButtonID="bCodeLookup"
		default:
			pageTitle="Mobile Inventory Management"
			templateName="main.tpl"
	}

	tpl:=template.New(templateName)

	tpl,err:=tpl.ParseFiles("templates/"+templateName)
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,PageTags{ActionTitle:pageTitle,BarcodeBtnColor:barCodeBtnColor,BarcodeBtnLabel:barCodeBtnLabel,BarcodeButtonFunc:barCodeButtonFunc,BarCodeID:barCodeID,})
	if err!=nil {
		log.Fatalln(err)
	}
}

func main() {
	port:=strconv.Itoa(setVars())
	router:=httprouter.New()

	router.GET("/",pageHandler)
	//
	//router.GET("/mkBarCode",generateBarCode)
	router.GET("/:page",pageHandler)
	//router.POST("/:page",ajaxRequests)
	http.Handle("css/", http.StripPrefix("css/", http.FileServer(http.Dir("css"))))
	fmt.Println("Product Management System listening and ready on port: " +port)
	http.ListenAndServe(":"+port,router)
}
