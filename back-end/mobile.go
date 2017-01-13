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
	"time"
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
	SelectedColorCodeHtml string
	ApplyBtnName string
	PageType string
	ItemPrice string;
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
	pageType string
	itemPrice string

	//DB Names
	CATEGORY_DB string
	DISCOUNT_DB string
	BARCODE_DB string
)

func setVars() (int) {
	dbUsername="goservices"
	dbPassword="C7163mwx!"
	dbLoginString=dbUsername+":"+dbPassword

	CATEGORY_DB="CATEGORY_CD"
	DISCOUNT_DB="DISCOUNT_CD"
	BARCODE_DB="BARCODE_CD"

	return 8890
}

func getCategories() (string) {
	var category_id int
	var categoryName, dbQuery string
	dbResults:=""

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		return "Error loading categories"
	}
	defer db.Close()

	dbQuery = "select id, name from "+CATEGORY_DB

	if err!=nil {
		return "Error loading categories"
	}

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&category_id,&categoryName)

		if err!=nil {
			return "Error loading categories"
		}
		dbResults+="<row><button name=\"categoryName\" value=\"" + strconv.Itoa(category_id) + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + categoryName + "</button></row>"
	}

	return dbResults
}

func getDefaultColor(requestId int, colorName string) (string) {
	colorID:=0
	colorCode:=""

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		return "Error reading color codes"
	}
	defer db.Close()

	dbQuery = "select id, colorcode from "+DISCOUNT_DB + " WHERE name='" + colorName + "'"
	//fmt.Println(dbQuery)

	if err!=nil {
		return "Error reading color codes"
	}

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&colorID,&colorCode)

		if err!=nil {
			return "Error reading color codes"
		}
	}

	if(requestId==1) {
		return strconv.Itoa(colorID)
	} else {
		return colorCode
	}
}

func getColors() (string) {
	var colorname, colorcode string
	var colorID int		//singleColor returns request to populate the default color selection on the item template at the back end

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	dbResults:=""
	if err!=nil {
		return "Error loading colors"
	}
	defer db.Close()

	dbQuery = "select id, name, colorcode from "+DISCOUNT_DB + " WHERE type='color'"
	//fmt.Println(dbQuery)

	if err!=nil {
		return "Error loading colors"
	}

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&colorID, &colorname,&colorcode)

		if err!=nil {
			return "Error loading color"
		}

		dbResults+="<button class=\"color-buttons btn btn-cons active\" data-dismiss=\"modal\" style=\"border: solid; border-radius: 50px; background-color: "+colorcode+" !important; height: 150px;\" name=\"color\" value=\""+strconv.Itoa(colorID)+"\"></button>"
	}

	return dbResults
}

func generateBarCode(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	category_id:=r.PostFormValue("category_id")
	var bcode_val string
	existing_barcode:=""

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	//Generate a new random bar code until there are no matches in the BARCODE_CD database
	for {
		//bcode_val="1002-8081-7887-1847-4059"
		bcode_val=category_id +"-" + strconv.Itoa(rand.Intn(10000)) + "-" + strconv.Itoa(rand.Intn(10000)) + "-" + strconv.Itoa(rand.Intn(10000)) + "-" + strconv.Itoa(rand.Intn(10000))

		dbQuery = "select barcode from " + BARCODE_DB + " where barcode='" + bcode_val + "'"

		if err!=nil {
			fmt.Fprintf(w,"Error: Could not query database")
			break
		}

		rows,err := db.Query(dbQuery)
		defer rows.Close()

		for rows.Next() {
			err = rows.Scan(&existing_barcode)
			if err != nil {
				fmt.Fprintf(w,"Error: Could not query the database for barcodes")
				break
			}
		}

		if(existing_barcode=="") {
			break			//No bar code found, good to use the randomly generated code
		} else {
			//The randomly generated code was already in the database
			//Clear the db results (existing_barcode) so it doesn't get stuck in a loop at the rows.Next()
			existing_barcode=""
		}
	}
	//Check the BARCODE_CD database to be sure this barcode is unique, and if not regenerate

	//fmt.Println("New bar code generated: " + bcode_val)
	//fmt.Println("Category ID: " + category_id)
	fmt.Fprintf(w,bcode_val)
}

func addProduct (w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	//formData:=[]string{r.PostFormValue("bcode"),r.PostFormValue("category"),r.PostFormValue("price"),r.PostFormValue("description"),r.PostFormValue("colorcode")}
	frmBarcode:=r.PostFormValue("bcode")
	frmCategory:=r.PostFormValue("category")
	frmPrice:=r.PostFormValue("price")
	frmDescription:=r.PostFormValue("description")
	frmColorCode:=r.PostFormValue("colorcode")

	fmt.Println("Barcode: " + frmBarcode)
	fmt.Println("Category: " + frmCategory)
	fmt.Println("Price: " + frmPrice)
	fmt.Println("Description: " + frmDescription)
	fmt.Println("Color code: " + frmColorCode)
	fmt.Println("")
	time.Sleep(2*time.Second)
	fmt.Fprintf(w,"Success")

}

func pageHandler(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	//Load the main template
	var templateName string
	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	pageRequest:=ps.ByName("page")

	switch pageRequest {
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
			pageType="newItem"
			itemPrice="";
		case "get-item":
			pageTitle="Item Lookup"
			templateName="item.tpl"
			barCodeBtnLabel="Scan"
			clsbCodeBtn="clsScanCode"
			//barCodeButtonID="bCodeLookup"
			applyBtnName="ExItemApply"
			pageType="exItem"
			itemPrice="";
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
		"GetColors": func() string {
			return getColors()
		},
	})

	tpl,err:=tpl.ParseFiles("templates/"+templateName)
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,PageTags{PageType:pageType,ActionTitle:pageTitle,ApplyBtnName:applyBtnName,CopyRight:copyrightMsg,BarcodeBtnLabel:barCodeBtnLabel,BarcodeButtonFunc:barCodeButtonFunc,BarCodeID:barCodeID,ClsbCodeBtn:clsbCodeBtn,ItemPrice:itemPrice,SelectedColorCode:getDefaultColor(1,"White"),SelectedColorCodeHtml:getDefaultColor(2,"White"),})
	if err!=nil {
		log.Fatalln(err)
	}
}

func main() {
	port:=strconv.Itoa(setVars())
	router:=httprouter.New()
	router.GET("/",pageHandler)					//Main page handler with no pages named
	router.GET("/:page",pageHandler)				//Allows for specific pages using json format
	router.POST("/addProduct",addProduct)				//Ajax call to add new item
	router.POST("/mkBarCode",generateBarCode)			//Ajax call to generate new bar codes

	http.Handle("/css/", http.StripPrefix("css/", http.FileServer(http.Dir("./css"))))
	fmt.Println("Product Management System listening and ready on port: " +port)
	http.ListenAndServe(":"+port,router)
}
