package main

import (
	"fmt"
	"text/template"
	"net/http"
	//"io"
	//"io/ioutil"
	"log"
	_ "github.com/go-sql-driver/mysql"
	"github.com/julienschmidt/httprouter"
	"database/sql"
	//"strings"
	"strconv"
	"math/rand"
	//"os"
	//"bufio"
)

type PageTags struct {
	ActionTitle	string
	BarCodeID	string
	GlobalDiscount1	string
	GlobalDiscount2	string
	BarcodeBtnLabel string
	//BarcodeButtonID	string
	BarcodeButtonFunc string
	ClsbCodeBtn	string
	CopyRight	string
	SelectedColorCode string
	SelectedColorCodeName string
	ApplyBtnName string
}

var (
	dbUsername string
	dbPassword string
	dbLoginString string
	dbQuery string
	proxyURL string
	barCodeID string
	barCodeBtnLabel string
	//barCodeButtonID	string
	barCodeButtonFunc string
	clsbCodeBtn string
	copyrightMsg string
	pageTitle string
	selectedColorCode string
	selectedColorCodeName string
	applyBtnName string
)

func setVars() (int) {
	dbUsername="goservices"
	dbPassword="C7163mwx!"
	dbLoginString=dbUsername+":"+dbPassword
	return 8890
}

func getCategories() (string) {
	var categoryName, dbQuery string
	dbResults:=""

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		panic(err)
	}
	defer db.Close()

	dbQuery = "select name from categories"

	if err!=nil {
		panic(err)
	}

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&categoryName)

		if err!=nil {
			panic(err)
		}
		dbResults+="<row><button name=\"categoryName\" value=\"" + categoryName + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + categoryName + "</button></row>"
	}

	return dbResults
}

func generateBarCode(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	bcode_val:=strconv.Itoa(rand.Intn(5000)) +"-" + strconv.Itoa(rand.Intn(5000)) + "-" + strconv.Itoa(rand.Intn(5000))

	fmt.Println("New bar code generated: " + bcode_val)
	fmt.Fprintf(w,bcode_val)
}

func addProduct (w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	formData:=[]string{r.PostFormValue("bcode"),r.PostFormValue("bcode"),r.PostFormValue("category"),r.PostFormValue("price"),r.PostFormValue("description"),r.PostFormValue("colorcode")}
	/*frmBarcode:=r.PostFormValue("bcode")
	frmCategory:=r.PostFormValue("category")
	frmPrice:=r.PostFormValue("price")
	frmDescription:=r.PostFormValue("description")
	frmColorCode:=r.PostFormValue("colorcode")*/

	for _,value:=range formData {
		fmt.Println(value)
	}

	fmt.Fprintf(w,"There was some error updating inventory.")

}

func pageHandler(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	//Load the main template
	var templateName string
	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	pageRequest:=ps.ByName("page")

	switch pageRequest {
		case "addProduct":
			addProduct(w,r,ps)
		case "mkBarCode":
			generateBarCode(w,r,ps)
			return
		case "new-item":
			pageTitle="Add Inventory"
			templateName="item.tpl"
			barCodeBtnLabel="New"
			clsbCodeBtn="clsNewCode"
			//barCodeButtonID="bCodeNew"
			barCodeID=""
			barCodeButtonFunc="generateNewCode()"
			selectedColorCode="white"
			selectedColorCodeName="white"
			applyBtnName="NewItemApply"
		case "get-item":
			pageTitle="Item Lookup"
			templateName="item.tpl"
			barCodeBtnLabel="Scan"
			clsbCodeBtn="clsScanCode"
			//barCodeButtonID="bCodeLookup"
			applyBtnName="ExItemApply"
		default:
			pageTitle="Mobile Inventory Management"
			templateName="main.tpl"
	}

	tpl:=template.New(templateName)
	tpl=tpl.Funcs(template.FuncMap{
		"FncGlobalDiscount1": func() string {
			//Return list of current discounts for item.tpl
			return "None";
		},

		"FnMbiTrkc": func() string {
			return getCategories()
		},
	})

	tpl,err:=tpl.ParseFiles("templates/"+templateName)
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,PageTags{ActionTitle:pageTitle,ApplyBtnName:applyBtnName,CopyRight:copyrightMsg,BarcodeBtnLabel:barCodeBtnLabel,BarcodeButtonFunc:barCodeButtonFunc,BarCodeID:barCodeID,ClsbCodeBtn:clsbCodeBtn,SelectedColorCode:selectedColorCode,SelectedColorCodeName:selectedColorCodeName,})
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
	router.POST("/addProduct",addProduct)				//Ajax call to add new item
	//router.POST("/:page",ajaxRequests)
	http.Handle("/css/", http.StripPrefix("css/", http.FileServer(http.Dir("./css"))))
	fmt.Println("Product Management System listening and ready on port: " +port)
	http.ListenAndServe(":"+port,router)
}
