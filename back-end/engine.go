package main

import (
	"fmt"
	"text/template"
	"net"
	"net/http"
	//"io"
	//"io/ioutil"
	"log"
	_ "github.com/go-sql-driver/mysql"
	"github.com/julienschmidt/httprouter"
	"github.com/gorilla/sessions"
	"github.com/gorilla/context"
	"database/sql"
	"strings"
	"strconv"
	"math/rand"
	"os"
	"bufio"
	"time"
	//"sync"
	"github.com/nu7hatch/gouuid"
	"github.com/robfig/cron"
)

var session_id, _ = uuid.NewV4()
var sessionStore = sessions.NewCookieStore([]byte(session_id.String()))

type PageTags struct {
	//Mobile page tags
	ActionTitle     string
	CurrentUser     string
	MobOrPcHomeBtn  string
	BarCodeID       string
	GlobalDiscount1 string
	GlobalDiscount2 string
	BarcodeBtnLabel string
	//BarcodeButtonID	string
	BarcodeButtonFunc     string
	ClsbCodeBtn           string
	CopyRight             string
	SelectedColorCode     string
	SelectedColorCodeHtml string
	ApplyBtnName          string
	PageType              string
	ItemPrice             string
	LicenseStatus	      string
	ProdLicense	      string
	ProdLicenseExpiry     string
	LicenseDaysLeft	      float64

	SessionID	string
}

var (
	dbUsername      string
	dbPassword      string
	dbLoginString   string
	dbQuery         string
	proxyURL        string
	mobOrPcHomeBtn  string
	barCodeID       string
	barCodeBtnLabel string
	//barCodeButtonID	string
	barCodeButtonFunc     string
	clsbCodeBtn           string
	copyrightMsg          string
	pageTitle             string
	selectedColorCode     string
	selectedColorCodeName string
	applyBtnName          string
	pageType              string
	itemPrice             string

	//DB Names
	OPERATING_DB	string
	INVENTORY_DB	string
	CATEGORY_DB    string
	DISCOUNT_DB    string
	BARCODE_DB     string
	CREDENTIALS_DB string
	GROUPS_DB      string
	GROUPS_CD_DB   string
	LICENSE_DB     string

	licenseServer 	string
	licenseStatus 	string
	licenseKey	string
	licenseExpiry	string
	licenseDaysLeft float64
	appPort		string

	maxIdleTime int
)

func setVars() {
	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	OPERATING_DB = "thriftstore"
	INVENTORY_DB = "INVENTORY_CD"
	CATEGORY_DB = "CATEGORY_CD"
	DISCOUNT_DB = "DISCOUNT_CD"
	BARCODE_DB = "BARCODE_CD"
	CREDENTIALS_DB = "CREDENTIALS"
	GROUPS_DB = "GROUPS"
	GROUPS_CD_DB = "GROUPS_CD"
	LICENSE_DB = "LICENSE"

	licenseStatus=""
	licenseServer = "192.168.1.190:8891"
	maxIdleTime = 60*1

	appPort="8890"
}

func getDBAccess() {
	file, err := os.Open("db.crd")
	if err!= nil {
		panic(err.Error())
	}

	defer file.Close()
	var lines string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines += scanner.Text()
	}

	fileArray:=strings.Split(lines,",")
	dbUsername=fileArray[0]
	dbPassword=fileArray[1]

	dbLoginString = dbUsername + ":" + dbPassword
}

func getCategories() (string) {
	var category_id int
	var categoryName, dbQuery string
	dbResults := ""

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		return "Error loading categories"
	}
	defer db.Close()

	dbQuery = "select id, name from " + CATEGORY_DB

	if err != nil {
		return "Error loading categories"
	}

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&category_id, &categoryName)

		if err != nil {
			return "Error loading categories"
		}
		//dbResults+="<row><button name=\"categoryName\" value=\"" + strconv.Itoa(category_id) + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + categoryName + "</button></row>"
		dbResults += strconv.Itoa(category_id) + "=" + categoryName + ","
	}

	return dbResults
}

func getDefaultColor(requestId int, colorName string) (string) {
	colorID := 0
	colorCode := ""

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		return "Error reading color codes"
	}
	defer db.Close()

	dbQuery = "select id, colorcode from " + DISCOUNT_DB + " WHERE name='" + colorName + "'"

	if err != nil {
		return "Error reading color codes"
	}

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&colorID, &colorCode)

		if err != nil {
			return "Error reading color codes"
		}
	}

	if (requestId == 1) {
		return strconv.Itoa(colorID)
	} else {
		return colorCode
	}
}

func getConfigDiscounts(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	id:=r.PostFormValue("id")

	var discountAmount string

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w,err.Error())
	}
	defer db.Close()

	dbQuery = "SELECT amount FROM DISCOUNT_CD WHERE id=" + id

	rows, _ := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err=rows.Scan(&discountAmount)

		if err != nil {
			fmt.Println(err.Error())
		}
	}

	fmt.Fprintf(w,discountAmount)
}

func saveDiscounts(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	discountType:=r.PostFormValue("type")
	dbRequest:=""
	dbRequest2:=""

	switch discountType {
	case "1":
		seniorDiscountAmount:=r.PostFormValue("senior")
		militaryDiscountAmount:=r.PostFormValue("military")

		dbRequest="update DISCOUNT_CD set amount=" + seniorDiscountAmount + " WHERE type='senior'"
		dbRequest2="update DISCOUNT_CD set amount=" + militaryDiscountAmount + " WHERE type='military'"
		break

	case "2":
		discountID:=r.PostFormValue("id")
		discountAmount:=r.PostFormValue("amount")
		dbRequest="update DISCOUNT_CD set amount=" + discountAmount + " WHERE id=" + discountID
		break
	}

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w,err.Error())
		return
	}
	defer db.Close()

	stmt, err := db.Prepare(dbRequest)
	if err != nil {
		fmt.Fprintf(w, err.Error()+"\n"+dbRequest)
		return
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error()+"\n"+dbRequest)
		return
	}

	if dbRequest2 !="" {
		stmt, err := db.Prepare(dbRequest2)
		if err != nil {
			fmt.Fprintf(w, err.Error()+"\n"+dbRequest2)
			return
		}

		_, err = stmt.Exec()
		if err != nil {
			fmt.Fprintf(w, err.Error()+"\n"+dbRequest2)
			return
		}

	}

	fmt.Fprintf(w,"Success")
}

func getDiscounts(discountType string) (string) {

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	dbResults := ""
	if err != nil {
		return "Error loading discounts"
	}
	defer db.Close()

	if discountType=="color" {
		var colorcode string
		var discountAmount string;

		dbQuery = "SELECT colorcode, amount FROM DISCOUNT_CD WHERE type='color'";
		rows, err := db.Query(dbQuery)
		defer rows.Close()

		for rows.Next() {
			err = rows.Scan(&colorcode, &discountAmount)

			if err != nil {
				return "Error loading color"
			}

			if (discountAmount != "0") {
				dbResults += "<button class=\"discountlabel-text\" style=\"border: solid; background-color: " + colorcode + "; padding-top: 0px; margin-left: 20px;\" disabled=\"disabled\">&nbsp&nbsp;</button> " + discountAmount + " %"
			}
		}

		if (dbResults == "") {
			dbResults = "No discounts defined"
		}

	} else if discountType=="senior" {
		var discountName string
		var discountAmount string

		dbQuery = "SELECT type, amount FROM DISCOUNT_CD WHERE type!='color'";
		rows, err := db.Query(dbQuery)
		defer rows.Close()

		for rows.Next() {
			err = rows.Scan(&discountName, &discountAmount)

			if err != nil {
				fmt.Println(err.Error())
			}

			dbResults+="<label id='" + discountName + "DiscountLbl' hidden>" + discountAmount + "</label>"
		}
	}

	return dbResults
}

func getColors() (string) {

	var colorcode string
	var colorID int //singleColor returns request to populate the default color selection on the item template at the back end

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	dbResults := ""
	if err != nil {
		return "Error loading colors"
	}
	defer db.Close()

	dbQuery = "select id, colorcode from " + DISCOUNT_DB + " WHERE type='color'"

	if err != nil {
		return "Error loading colors"
	}

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&colorID, &colorcode)

		if err != nil {
			return "Error loading color"
		}

		dbResults += "<button class=\"color-buttons btn btn-cons active\" data-dismiss=\"modal\" style=\"background-color: " + colorcode + " !important;\" name=\"color\" value=\"" + strconv.Itoa(colorID) + "\"></button>"
	}

	if (dbResults == "") {
		dbResults = "<p class=\"dlglabel-msg\">No color codes defined</p>"
	}

	return dbResults
}

func setAdminPwd(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	adminPassword := r.PostFormValue("password")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery := "INSERT INTO " + CREDENTIALS_DB + " VALUES(DEFAULT,'admin',SHA('" + adminPassword + "'))"
	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	dbQuery = "DELETE FROM " + CREDENTIALS_DB + " WHERE username='setup'"
	stmt, err = db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	fmt.Fprintf(w, "Success")

}

func removePassword(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	username := r.PostFormValue("user")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery := "UPDATE " + CREDENTIALS_DB + " SET password=SHA('none') WHERE username='" + username + "'"
	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	fmt.Fprintf(w, "Success")
}

func removeUser(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	username := r.PostFormValue("user")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery := "DELETE FROM " + CREDENTIALS_DB + " WHERE username='" + username + "'"
	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	dbQuery = "DELETE FROM " + GROUPS_DB + " WHERE username='" + username + "'"
	stmt, err = db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	fmt.Fprintf(w, "Success")
}

func addUser(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	username := r.PostFormValue("user")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery := "INSERT INTO " + CREDENTIALS_DB + " VALUES(DEFAULT,'" + username + "',SHA('none'))"
	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, "The user already exists")
		return

	}

	dbQuery = "INSERT INTO " + GROUPS_DB + " VALUES('" + username + "','none|')"
	stmt, err = db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return

	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, "Could not add user to groups")
		return

	}

	if err == nil {
		fmt.Fprintf(w, "Success")
	}
}

func chPwd(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {

	session, err := sessionStore.Get(r, "auth")
	username := session.Values["username"].(string)
	password := r.PostFormValue("password")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery := "UPDATE " + CREDENTIALS_DB + " SET password=SHA('" + password + "') WHERE username='" + username + "'"
	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	fmt.Fprintf(w, "Success")

}

func doLogin(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	username := r.PostFormValue("username");
	password := r.PostFormValue("password");
	dbMatch := 0

	session, err := sessionStore.Get(r, "auth")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery = "select * from " + CREDENTIALS_DB + " WHERE username='" + username + "' AND password=SHA('" + password + "')"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan()
		dbMatch++
	}

	if (dbMatch > 0) {
		session.Values["username"] = username
		session.Values["password"] = password

		session.Options = &sessions.Options{
			MaxAge:   maxIdleTime,
			HttpOnly: true,
		}

		session.Save(r, w)
		fmt.Fprintf(w, "Success")

	} else {
		fmt.Fprintf(w, "Invalid login")
	}
}

func doLogout(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	session, err := sessionStore.Get(r, "auth")
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	session.Options.MaxAge = -1 //Delete the session
	session.Save(r, w);
	fmt.Fprintf(w, "Logout")
}

func heartbeat(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	session, err := sessionStore.Get(r, "auth")
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	session.Options.MaxAge = maxIdleTime
	session.Save(r, w);

	return
}

func generateBarCode(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	//category_id := r.PostFormValue("category_id")
	var bcode_val string
	existing_barcode := ""

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)

	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	//Generate a new random bar code until there are no matches in the BARCODE_CD database
	for {
		//bcode_val="1002-8081-7887-1847-4059"
		bcode_val = strconv.Itoa(rand.Intn(10000)) + "-" + strconv.Itoa(rand.Intn(10000)) + "-" + strconv.Itoa(rand.Intn(10000))

		dbQuery = "select barcode from " + BARCODE_DB + " where barcode='" + bcode_val + "'"

		if err != nil {
			fmt.Fprintf(w, "Error: Could not query database")
			break
		}

		rows, err := db.Query(dbQuery)
		defer rows.Close()

		for rows.Next() {
			err = rows.Scan(&existing_barcode)
			if err != nil {
				fmt.Fprintf(w, "Error: Could not query the database for barcodes")
				break
			}
		}

		if (existing_barcode == "") {
			break //No bar code found, good to use the randomly generated code
		} else {
			//The randomly generated code was already in the database
			//Clear the db results (existing_barcode) so it doesn't get stuck in a loop at the rows.Next()
			existing_barcode = ""
		}
	}
	//Check the BARCODE_CD database to be sure this barcode is unique, and if not regenerate

	fmt.Fprintf(w, bcode_val)
}

func printBarCode(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	heartbeat(w,r,p)	//Extend session life

	time.Sleep(2 * time.Second)
	fmt.Fprintf(w, "Success")
}

func configProduct(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	heartbeat(w,r,p)	//Extend session life

	productType:=r.PostFormValue("config")

	dbQuery:=""

	frmBarcode := r.PostFormValue("bcode")
	frmCategory := r.PostFormValue("category")
	frmPrice := r.PostFormValue("price")
	frmDescription := r.PostFormValue("description")
	frmColorCode := r.PostFormValue("colorcode")

	/*fmt.Println("Barcode: " + frmBarcode)
	fmt.Println("Category: " + frmCategory)
	fmt.Println("Price: " + frmPrice)
	fmt.Println("Description: " + frmDescription)
	fmt.Println("Color code: " + frmColorCode)*/

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}
	defer db.Close()

	if productType=="new" {
		dbQuery = "insert into " + INVENTORY_DB + " values(DEFAULT," + frmCategory + "," + frmColorCode + ",'" + frmDescription + "'," + frmPrice + ",'" + frmBarcode + "')"
	} else {
		dbQuery = "update " + INVENTORY_DB + " SET category=" + frmCategory + ",discount=" + frmColorCode + ",description='" + frmDescription + "',price=" + frmPrice +" WHERE barcode='" + frmBarcode +"'"
	}

	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return
	}

	if productType=="new" {
		dbQuery = "insert into BARCODE_CD values(DEFAULT,'" + frmBarcode + "')"

		stmt, err = db.Prepare(dbQuery)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}

		_, err = stmt.Exec()
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
	}

	time.Sleep(2 * time.Second)
	fmt.Fprintf(w, "Success")

}

func lookupItem(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	heartbeat(w,r,p)	//Extend session life

	bCodeID:=r.PostFormValue("bcode")
	var category,catName,discount,description,price,colorcode string
	returnResponse:="Error: Item not found"

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}
	defer db.Close()

	dbQuery:="select category,discount,description,price from " + INVENTORY_DB + " WHERE barcode='" + bCodeID + "'"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	if err!=nil {
		fmt.Fprintf(w,"Error: " + err.Error())
		return
	}

	for rows.Next() {
		err = rows.Scan(&category, &discount, &description, &price)
		if err != nil {
			fmt.Fprintf(w, "Error: "+err.Error())
			return
		}
		returnResponse=category + "|" + discount + "|" + description + "|" + price
	}

	if returnResponse!="Error: Item not found" {
		dbQuery="select colorcode from " + DISCOUNT_DB + " WHERE id=" + discount
		rows, err = db.Query(dbQuery)
		defer rows.Close()

		if err!=nil {
			fmt.Fprintf(w, "Error: "+err.Error())
			return
		}
		for rows.Next() {
			err = rows.Scan(&colorcode)
			if err != nil {
				fmt.Fprintf(w, "Error: "+err.Error())
				return
			}
			returnResponse += "|" + colorcode
		}

		dbQuery="select name from " + CATEGORY_DB + " WHERE id=" + category
		rows, err = db.Query(dbQuery)
		defer rows.Close()

		if err!=nil {
			fmt.Fprintf(w, "Error: "+err.Error())
			return
		}
		for rows.Next() {
			err = rows.Scan(&catName)
			if err != nil {
				fmt.Fprintf(w, "Error: "+err.Error())
				return
			}
			returnResponse += "|" + catName
		}

	}

	fmt.Fprintf(w,returnResponse)

}

func checkSetupComplete() (bool) {
	setupComplete := true

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Println("Error: Could not open the database")
	}
	defer db.Close()

	dbQuery = "select * from " + CREDENTIALS_DB + " WHERE username='setup'"
	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		setupComplete = false;
	}

	return setupComplete
}

func checkPerms(username string, groupName string) bool {
	var groups = ""

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()

	dbQuery = "select groups from GROUPS WHERE username='" + username + "'"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&groups)
	}

	if (strings.Contains(groups, groupName)) {
		return true
	} else {
		return false
	}
}

func getUserDetails(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	username := r.PostFormValue("user")
	var groups string

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select groups from " + GROUPS_DB + " WHERE username='" + username + "'"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&groups)
	}

	fmt.Fprintf(w, groups)

}

func isUserPasswordSet(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	username := r.PostFormValue("user")
	match := 0

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select * from " + CREDENTIALS_DB + " WHERE username='" + username + "' AND password=SHA('none')"

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		match = 1
	}

	if match == 1 {
		fmt.Fprintf(w, "No password set");
	} else {
		fmt.Fprintf(w, "Password is set")
	}
}

func saveUserDetails(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	user := r.PostFormValue("user")
	groups := r.PostFormValue("groups");
	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "update " + GROUPS_DB + " SET groups='" + groups + "' WHERE username='" + user + "'"

	stmt, err := db.Prepare(dbQuery)
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	_, err = stmt.Exec()
	if err != nil {
		fmt.Fprintf(w, err.Error())
	}

	fmt.Fprintf(w, "Success");
}

func getSystemGroups(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	var groups, groupList string

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select name from " + GROUPS_CD_DB

	rows, err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&groups)

		if err != nil {
			fmt.Fprintf(w, err.Error())
		}

		groupList += groups + "|"
	}

	fmt.Fprintf(w, groupList)

}

func saveCategories(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	heartbeat(w,r,ps)	//Extend session life

	removeCategories := r.PostFormValue("removeCategories")
	addCategories := r.PostFormValue("addCategories")

	rCatlist := strings.Split(removeCategories, ",")
	aCatList := strings.Split(addCategories, ",")

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
		return
	}

	defer db.Close()

	for i := 0; i < len(rCatlist)-1; i++ {
		dbQuery = "DELETE FROM " + CATEGORY_DB + " WHERE id=" + rCatlist[i]

		stmt, err := db.Prepare(dbQuery)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}

		_, err = stmt.Exec()
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
	}

	for j := 0; j < len(aCatList)-1; j++ {
		dbQuery = "INSERT INTO " + CATEGORY_DB + " VALUES(DEFAULT,'" + aCatList[j] + "')"

		stmt, err := db.Prepare(dbQuery)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}

		_, err = stmt.Exec()
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
	}

	fmt.Fprintf(w, "Success")
}

func getConfig(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var templateName, templatePath string
	var users, groups, groupDescription string

	pageRequest := ps.ByName("page")

	heartbeat(w,r,ps)	//Extend session life

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Fprintf(w, "Error: Could not open the database")
	}

	defer db.Close()

	switch pageRequest {
	case "users":
		templateName = "user-config.tpl"
	case "categories":
		templateName = "category-config.tpl"
	case "discounts":
		templateName = "discount-config.tpl"
	case "colors":
		templateName = "color-config.tpl"
	case "license":
		templateName = "license-config.tpl"
	}

	templatePath = "sys-templates/config/" + templateName

	tpl := template.New(templateName)

	tpl = tpl.Funcs(template.FuncMap{
		"GetUserList": func() string {

			userList := ""

			//Return list of current discounts for item.tpl
			dbQuery = "select username from " + CREDENTIALS_DB + " WHERE username!='admin'"
			rows, err := db.Query(dbQuery)

			if (err != nil) {
				return (err.Error())
			}
			defer rows.Close()

			for rows.Next() {
				err = rows.Scan(&users)

				userList += "<li class=\"dynContent-dropdown-text\" name=\"user\">" + users + "</li>\n"
			}

			if userList == "" {
				userList = "<li class=\"dynContent-dropdown-text\">No users exist</li>\n"
			}
			return userList
		},

		"GetGroupList": func() string {
			var groupList string

			dbQuery = "select name, description from " + GROUPS_CD_DB
			rows, err := db.Query(dbQuery)

			if err != nil {
				return (err.Error())
			}

			defer rows.Close()

			for rows.Next() {
				err = rows.Scan(&groups, &groupDescription)

				groupList += "<p><span style='width: 50px;'><b>" + groups + ":</b></span> " + groupDescription + "</p>"
			}
			return groupList
		},

		"CategoryList": func() string {
			formattedCatList := ""

			categoryList := strings.Split(getCategories(), ",")

			for i := 0; i < len(categoryList)-1; i++ {
				itemSplit := strings.Split(categoryList[i], "=")

				if (itemSplit[1] != "No category") {

					formattedCatList += "<p><i name='removeCategory' data-value='" + itemSplit[0] + "' class='fa fa-times-circle-o' style='color: #337ab7; margin-right: 10px;'> </i><label class='cat-" + itemSplit[0] + "'>" + itemSplit[1] + "</label></p>\n";
				}
			}

			if formattedCatList == "" {
				formattedCatList = "No categories defined"
			}
			return formattedCatList
		},

		"GetColors": func() string {
			return getColors()
		},

		"GetDiscounts": func() string {
			discountData:=getDiscounts("color")
			discountData+=getDiscounts("senior")

			return discountData
		},

	})

	tpl, err = tpl.ParseFiles(templatePath)
	if err != nil {
		log.Fatalln(err.Error())
	}
	err = tpl.Execute(w, PageTags{ProdLicense:licenseKey,})
	if err != nil {
		log.Fatalln(err)
	}

}

func pageHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	//Load the main template
	var mobile bool
	var loggedInUser string

	session, _ := sessionStore.Get(r, "auth")

	if (session.Values["username"] != nil) {
		loggedInUser = session.Values["username"].(string)
	} else {
		loggedInUser = "none"
	}

	urlPath := strings.Split(r.URL.Path, "/")
	mobOrPC := urlPath[1] //Detect if mobile or pc version is request (/m, or /front)
	if (mobOrPC == "m") {
		mobile = true
	} else {
		mobile = false
	}

	var templateName, templatePath string
	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	pageRequest := ps.ByName("page")

	switch pageRequest {
	case "firstLogin":
		pageTitle = "First Login"
		templateName = "first_login.tpl"
	case "config":
		if (checkPerms(loggedInUser, "admin") == false) {
			templateName = "access_denied.tpl"
		} else {
			templateName = "config.tpl"
		}
	case "new-item":
		pageTitle = "Add Inventory"
		if (checkPerms(loggedInUser, "inv") == false) {
			templateName = "access_denied.tpl"
		} else {
			templateName = "item.tpl"
		}

		barCodeBtnLabel = "New"
		clsbCodeBtn = "clsNewCode"
		//barCodeButtonID="bCodeNew"
		barCodeID = ""
		barCodeButtonFunc = "generateNewCode()"
		selectedColorCode = "white"
		selectedColorCodeName = "white"
		applyBtnName = "NewItemApply"
		pageType = "newItem"
		itemPrice = "$0.00";
	case "get-item":
		pageTitle = "Item Lookup"

		templateName = "item.tpl"
		barCodeBtnLabel = "Scan"
		clsbCodeBtn = "clsScanCode"
		//barCodeButtonID="bCodeLookup"
		applyBtnName = "ExItemApply"
		pageType = "exItem"
		itemPrice = "$";
	default:
		pageTitle = "Inventory Management"
		templateName = "main.tpl"
	}

	if (session.Values["username"] == nil) {
		//Not logged in, redirect to the login page
		templateName = "login.tpl"
	} else {
		heartbeat(w,r,ps)
	}

	if(licenseStatus != "valid") {
		if(mobile) {
			templateName = "license-error.tpl"
			templatePath = "m-templates/license-error.tpl"
		} else {
			templateName = "license-error.tpl"
			templatePath = "sys-templates/license-error.tpl"
		}

	} else if (checkSetupComplete() == false) {
		//Setup has not been completed, load that page
		templateName = "first_setup.tpl"
		templatePath = "sys-templates/first_setup.tpl"

	} else {
		if (mobile) {
			templatePath = "m-templates/" + templateName
			mobOrPcHomeBtn = "/m"
		} else {
			templatePath = "pos-templates/" + templateName
			mobOrPcHomeBtn = "/front"
		}

	}

	tpl := template.New(templateName)
	tpl = tpl.Funcs(template.FuncMap{
		"FncGlobalDiscount1": func() string {
			//Return list of current discounts for item.tpl
			return getDiscounts("color");
		},

		"FnMbiTrkc": func() string {
			formattedCatList := ""
			categoryList := strings.Split(getCategories(), ",")

			for i := 0; i < len(categoryList)-1; i++ {
				itemSplit := strings.Split(categoryList[i], "=")
				if (itemSplit[1] != "No category") {
					formattedCatList += "<row><button name=\"categoryName\" value=\"" + itemSplit[0] + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + itemSplit[1] + "</button></row>"
				}
			}

			if formattedCatList == "" {
				formattedCatList = "<row><label class='category-buttons'>No categories defined</label>"
			}
			return formattedCatList
		},
		"GetColors": func() string {
			return getColors()
		},
	})

	tpl, err := tpl.ParseFiles(templatePath)
	if err != nil {
		log.Fatalln(err.Error())
	}

	err = tpl.Execute(w, PageTags{LicenseDaysLeft:licenseDaysLeft,ProdLicense:licenseKey,ProdLicenseExpiry:licenseExpiry,LicenseStatus:licenseStatus,PageType:pageType, ActionTitle:pageTitle, CurrentUser:loggedInUser, MobOrPcHomeBtn:mobOrPcHomeBtn, ApplyBtnName:applyBtnName, CopyRight:copyrightMsg, BarcodeBtnLabel:barCodeBtnLabel, BarcodeButtonFunc:barCodeButtonFunc, BarCodeID:barCodeID, ClsbCodeBtn:clsbCodeBtn, ItemPrice:itemPrice, })
	if err != nil {
		log.Fatalln(err)
	}
}

func updateLicense(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	newLicense := r.PostFormValue("license")

	newLicenseStatus:=""
	newLicenseExpiry:=""

	conn, err := net.Dial("tcp", licenseServer)

	if err != nil {
		newLicenseStatus="1054"
	} else {

		licenseQuery := "LICENSE=" + newLicense

		fmt.Fprintf(conn, licenseQuery+"\n")
		licenseServerResponse, _ := bufio.NewReader(conn).ReadString('\n')

		rawLicenseServerResponse:=strings.Split(licenseServerResponse,",")

		newLicenseStatus=rawLicenseServerResponse[0]
		newLicenseExpiry=rawLicenseServerResponse[1]
	}

	if(newLicenseStatus=="valid") {

		db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
		if err != nil {
			fmt.Println("Error: Could not open the database")
		}
		defer db.Close()

		dbQuery = "update " + LICENSE_DB + " set license='" + newLicense + "'"
		stmt, err := db.Prepare(dbQuery)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}

		_, err = stmt.Exec()
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}

		fmt.Println("License updated")
		doLicenseCheck()
	}

	fmt.Fprintf(w,newLicenseStatus+","+newLicenseExpiry)
}

func doLicenseCheck() {
	fmt.Println("License check at ", time.Now())

	db, err := sql.Open("mysql", dbLoginString+"@/"+OPERATING_DB)
	if err != nil {
		fmt.Println("Error: Could not open the database")
	}
	defer db.Close()

	dbQuery = "select license from " + LICENSE_DB

	rows, err := db.Query(dbQuery)

	if err!=nil {
		fmt.Println(err.Error)
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&licenseKey)
	}

	if (licenseKey != "") {
		conn, err := net.Dial("tcp", licenseServer)

		if err != nil {
			fmt.Println("Could not connect to the license server");
			licenseStatus="1054"
		} else {

			licenseQuery := "LICENSE=" + licenseKey

			fmt.Fprintf(conn, licenseQuery+"\n")
			licenseServerResponse, _ := bufio.NewReader(conn).ReadString('\n')

			rawLicenseServerResponse:=strings.Split(licenseServerResponse,",")

			licenseStatus=rawLicenseServerResponse[0]
			licenseExpiry=rawLicenseServerResponse[1]

			//Check license days remaining
			currentDate:=time.Now().Format("2006-01-02")

			d1,_:=time.Parse("2006-01-02",currentDate)
			d2, _ := time.Parse("2006-01-02", licenseExpiry)
			durationInDay := d2.Sub(d1).Hours()/24

			licenseDaysLeft=durationInDay
		}
	}
}

func licenseServerRetry(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	//Used when the license server is down to retry
	doLicenseCheck()

	if licenseStatus != "1054" {
		fmt.Fprintf(w,"1050")
	} else {
		fmt.Fprintf(w,"error")
	}

}

func init() {
	getDBAccess()
	setVars()

	licenseCheckThread:=cron.New()
	licenseCheckThread.AddFunc("@every 12h",func() {
		doLicenseCheck()
	})

	licenseCheckThread.Start()

	doLicenseCheck()
}

func main() {
	router := httprouter.New()
	router.GET("/m", pageHandler)       //Main page handler with no pages named
	router.GET("/m/:page", pageHandler) //Allows for specific pages using json format
	router.GET("/front", pageHandler)
	router.GET("/front/:page", pageHandler)
	router.POST("/configProduct", configProduct)     //Ajax call to add new item
	router.POST("/lookupItem", lookupItem)	   //Used by the barcode scan function on item.tpl
	router.POST("/mkBarCode", generateBarCode) //Ajax call to generate new bar codes
	router.POST("/login", doLogin)
	router.POST("/logout", doLogout)
	router.POST("/printCode", printBarCode)
	router.POST("/setAdminPwd", setAdminPwd)
	router.POST("/chPwd", chPwd)
	router.POST("/removePassword", removePassword)
	router.POST("/removeUser", removeUser)
	router.POST("/addUser", addUser)
	router.POST("/getConfig/:page", getConfig)
	router.POST("/getUserDetails", getUserDetails)
	router.POST("/saveUserDetails", saveUserDetails)
	router.POST("/isUserPasswordSet", isUserPasswordSet)
	router.POST("/getSystemGroups", getSystemGroups)
	router.POST("/getConfigDiscounts",getConfigDiscounts)		//used by discount-config.tpl ajax call
	router.POST("/saveDiscounts",saveDiscounts)
	router.POST("/saveCategories", saveCategories)
	router.POST("/updateLicense",updateLicense)
	router.POST("/licenseServerRetry",licenseServerRetry)
	http.Handle("/css/", http.StripPrefix("css/", http.FileServer(http.Dir("./css"))))
	fmt.Println("Product Management System listening and ready on port: " + appPort +"\n")
	http.ListenAndServe(":"+appPort, context.ClearHandler(router))
}
