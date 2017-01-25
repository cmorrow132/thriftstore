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
	"github.com/gorilla/sessions"
	"github.com/gorilla/context"
	"database/sql"
	"strings"
	"strconv"
	"math/rand"
	//"os"
	//"bufio"
	"time"
	//"sync"
	"github.com/nu7hatch/gouuid"
)

var session_id,_ =uuid.NewV4()
var sessionStore = sessions.NewCookieStore([]byte(session_id.String()))

type PageTags struct {						//Mobile page tags
	ActionTitle	string
	CurrentUser	string
	MobOrPcHomeBtn	string
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
	mobOrPcHomeBtn string
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
	CREDENTIALS_DB string
	GROUPS_DB string
	GROUPS_CD_DB string
)

func setVars() (int) {
	dbUsername="goservices"
	dbPassword="C7163mwx!"
	dbLoginString=dbUsername+":"+dbPassword

	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	CATEGORY_DB="CATEGORY_CD"
	DISCOUNT_DB="DISCOUNT_CD"
	BARCODE_DB="BARCODE_CD"
	CREDENTIALS_DB="CREDENTIALS"
	GROUPS_DB="GROUPS"
	GROUPS_CD_DB="GROUPS_CD"

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
		//dbResults+="<row><button name=\"categoryName\" value=\"" + strconv.Itoa(category_id) + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + categoryName + "</button></row>"
		dbResults+=strconv.Itoa(category_id) + "=" + categoryName + ","
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

func getDiscounts() (string) {
	var colorcode string
	var discountAmount string;
	var discountDollars int
	var discountCents int
	var priceString string

	//var tmpDiscountDollars string
	//var tmpDiscountCents string


	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	dbResults:=""
	if err!=nil {
		return "Error loading discounts"
	}
	defer db.Close()

	dbQuery="SELECT colorcode, amount FROM DISCOUNT_CD WHERE type='color'";

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&colorcode, &discountAmount)

		if err!=nil {
			return "Error loading color"
		}


		discountSplit:=strings.Split(discountAmount,".")
		discountDollars,_=strconv.Atoi(discountSplit[0])	//Convert dollar string to int
		discountCents,_=strconv.Atoi(discountSplit[1])

		priceString=""

		if(discountDollars==0 && discountCents > 0) { //Dollars is 0, so discount is a percentage
			priceString = strconv.Itoa(discountCents) + "%"
		} else if(discountDollars>0) {
			priceString="$"
			priceString += strconv.Itoa(discountDollars)

			if(discountCents > 0) {
				priceString +="." + strconv.Itoa(discountCents)
			}
		}

		if(priceString != "") {
			dbResults+="<button class=\"discountlabel-text\" style=\"border: solid; background-color: " + colorcode + "; padding-top: 0px; margin-left: 20px; border-radius: 50px;\" disabled=\"disabled\">&nbsp&nbsp;</button> " + priceString
		}
	}

	if(dbResults=="") {
		dbResults="No discounts defined"
	}

	return dbResults
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

		dbResults+="<button class=\"color-buttons btn btn-cons active\" data-dismiss=\"modal\" style=\"background-color: "+colorcode+" !important;\" name=\"color\" value=\""+strconv.Itoa(colorID)+"\"></button>"
	}

	if(dbResults=="") {
		dbResults="<p class=\"dlglabel-msg\">No color codes defined</p>"
	}

	return dbResults
}

func setAdminPwd(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	adminPassword:=r.PostFormValue("password")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery:="INSERT INTO " + CREDENTIALS_DB + " VALUES(DEFAULT,'admin',SHA('" + adminPassword +"'))"
	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Println(err)
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Println(err)
	}


	dbQuery="DELETE FROM " + CREDENTIALS_DB + " WHERE username='setup'"
	stmt,err=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Println(err)
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Println(err)
	}

	fmt.Fprintf(w,"Success")

}

func removePassword(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("user")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery:="UPDATE " + CREDENTIALS_DB + " SET password=SHA('none') WHERE username='" + username + "'"
	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	fmt.Fprintf(w,"Success")
}

func removeUser(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("user")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery:="DELETE FROM " + CREDENTIALS_DB + " WHERE username='" + username + "'"
	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	dbQuery="DELETE FROM " + GROUPS_DB + " WHERE username='" + username + "'"
	stmt,err=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	fmt.Fprintf(w,"Success")
}

func addUser(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("user")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery:="INSERT INTO " + CREDENTIALS_DB + " VALUES(DEFAULT,'" + username + "',SHA('none'))"
	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
		return
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,"The user already exists")
		return
	}

	dbQuery="INSERT INTO " + GROUPS_DB + " VALUES('" + username + "','none|')"
	stmt,err=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
		return
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,"Could not add user to groups")
		return
	}

	fmt.Fprintf(w,"Success")
}

func chPwd(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {

	session,err:=sessionStore.Get(r,"auth")
	username:=session.Values["username"].(string)
	password:=r.PostFormValue("password")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery:="UPDATE " + CREDENTIALS_DB + " SET password=SHA('" + password +"') WHERE username='" + username + "'"
	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Fprintf(w,err.Error())
	}

	fmt.Fprintf(w,"Success")

}

func doLogin(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("username");
	password:=r.PostFormValue("password");
	dbMatch:=0

	session,err:=sessionStore.Get(r,"auth")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")

	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
		return
	}

	defer db.Close()

	dbQuery = "select * from "+CREDENTIALS_DB + " WHERE username='" + username + "' AND password=SHA('" + password + "')"

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err=rows.Scan()
		dbMatch++
	}

	if(dbMatch > 0) {
		session.Values["username"] = username
		session.Values["password"] = password

		session.Options = &sessions.Options{
			MaxAge: 0,
			HttpOnly: true,
		}

		session.Save(r, w)
		fmt.Fprintf(w, "Success")

	} else {
		fmt.Fprintf(w,"Invalid login")
	}
}

func doLogout(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	session,err:=sessionStore.Get(r,"auth")
	if err!= nil {
		fmt.Println(err);
	}

	session.Options.MaxAge=-1		//Delete the session
	session.Save(r,w);

	fmt.Fprintf(w,"Logout")
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

func printBarCode (w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	time.Sleep(2*time.Second)
	fmt.Fprintf(w,"Success")
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

func checkSetupComplete() (bool){
	setupComplete:=true

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}
	defer db.Close()

	dbQuery = "select * from " + CREDENTIALS_DB + " WHERE username='setup'"
	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		setupComplete=false;
	}

	return setupComplete
}

func checkPerms(username string, groupName string) bool {
	var groups=""

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()

	dbQuery = "select groups from GROUPS WHERE username='" + username + "'"

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err=rows.Scan(&groups)
	}

	if(strings.Contains(groups,groupName)) {
		return true
	} else {
		return false
	}
}

func getUserDetails(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("user")
	var groups string

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select groups from " + GROUPS_DB + " WHERE username='" + username + "'"

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err=rows.Scan(&groups)
	}

	fmt.Fprintf(w,groups)

}

func isUserPasswordSet(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	username:=r.PostFormValue("user")
	match:=0

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select * from " + CREDENTIALS_DB + " WHERE username='" + username + "' AND password=SHA('none')"

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		match=1
	}

	if match==1 {
		fmt.Fprintf(w,"No password set");
	} else {
		fmt.Fprintf(w,"Password is set")
	}
}

func saveUserDetails(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	user:=r.PostFormValue("user")
	groups:=r.PostFormValue("groups");

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "update " + GROUPS_DB + " SET groups='" + groups + "' WHERE username='" + user + "'"

	stmt,err:=db.Prepare(dbQuery)
	if err!= nil {
		fmt.Println(err)
	}

	_,err=stmt.Exec()
	if err!= nil {
		fmt.Println(err)
	}

	fmt.Fprintf(w,"Success");
}

func getSystemGroups(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	var groups, groupList string

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Fprintf(w,"Error: Could not open the database")
	}

	defer db.Close()
	dbQuery = "select name from " + GROUPS_CD_DB

	rows,err := db.Query(dbQuery)
	defer rows.Close()

	for rows.Next() {
		err=rows.Scan(&groups)

		if err != nil {
			fmt.Fprintf(w,err.Error())
		}

		groupList+=groups+"|"
	}

	fmt.Fprintf(w,groupList)

}

func getConfig(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	var templateName, templatePath string
	var users,groups,groupDescription string
	//var userName string

	pageRequest:=ps.ByName("page")

	db, err := sql.Open("mysql", "admin:C7163mwx!@/thriftstore")
	if err!=nil {
		fmt.Println("Error: Could not open the database")
	}

	defer db.Close()


	switch pageRequest {
		case "users":
			templateName="user-config.tpl"
		case "categories":
			templateName="category-config.tpl"
	}

	templatePath="sys-templates/config/" + templateName

	tpl:=template.New(templateName)

	tpl=tpl.Funcs(template.FuncMap{
		"GetUserList": func() string {

			userList:=""

			//Return list of current discounts for item.tpl
			dbQuery = "select username from " + CREDENTIALS_DB + " WHERE username!='admin'"
			rows,err := db.Query(dbQuery)

			if(err!=nil) {
				return(err.Error())
			}
			defer rows.Close()

			for rows.Next() {
				err=rows.Scan(&users)

				userList+="<li class=\"dynContent-dropdown-text\" name=\"user\">" + users + "</li>\n"
			}

			if userList=="" {
				userList="<li class=\"dynContent-dropdown-text\">No users exist</li>\n"
			}
			return userList
		},

		"GetGroupList": func() string {
			var groupList string

			dbQuery = "select name, description from " + GROUPS_CD_DB
			rows,err := db.Query(dbQuery)

			if err!=nil {
				return(err.Error())
			}

			defer rows.Close()

			for rows.Next() {
				err=rows.Scan(&groups,&groupDescription)

				groupList+="<p><span style='width: 50px;'><b>" + groups + ":</b></span> " + groupDescription + "</p>"
			}
			return groupList
		},

		"CategoryList": func() string {
			formattedCatList:=""
			categoryList:=strings.Split(getCategories(),",")

			for i:=0;i<len(categoryList)-1;i++ {
				itemSplit:=strings.Split(categoryList[i],"=")

				if(itemSplit[1] != "No category") {
					formattedCatList+="<p><i name='removeCategory' data-value='" + itemSplit[0] + "' class='fa fa-times-circle-o' style='color: #337ab7; margin-right: 10px;'> </i><label class='cat-" + itemSplit[0] + "'>" + itemSplit[1] + "</label></p>\n";
				}
			}

			return formattedCatList
		},
	})

	tpl,err=tpl.ParseFiles(templatePath)
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,"")
	if err!=nil {
		log.Fatalln(err)
	}
}

func pageHandler(w http.ResponseWriter,r *http.Request, ps httprouter.Params) {
	//Load the main template
	var mobile bool
	var loggedInUser string

	session,_:=sessionStore.Get(r,"auth")

	if(session.Values["username"] != nil) {
		loggedInUser = session.Values["username"].(string)
	} else {
		loggedInUser="none"
	}

	urlPath:=strings.Split(r.URL.Path,"/")
	mobOrPC:=urlPath[1]				//Detect if mobile or pc version is request (/m, or /front)
	if(mobOrPC=="m") {
		mobile=true
	} else {
		mobile=false
	}

	var templateName, templatePath string
	copyrightMsg = "Copyright &copy 2017 Christopher Morrow"

	pageRequest:=ps.ByName("page")

	switch pageRequest {
		case "firstLogin":
			pageTitle="First Login"
			templateName="first_login.tpl"
		case "config":
			if(checkPerms(loggedInUser,"admin")==false) {
				templateName="access_denied.tpl"
			} else {
				templateName="config.tpl"
			}
		case "new-item":
			pageTitle="Add Inventory"
			if(checkPerms(loggedInUser,"inv")==false) {
				templateName="access_denied.tpl"
			} else {
				templateName="item.tpl"
			}

			barCodeBtnLabel="New"
			clsbCodeBtn="clsNewCode"
			//barCodeButtonID="bCodeNew"
			barCodeID=""
			barCodeButtonFunc="generateNewCode()"
			selectedColorCode="white"
			selectedColorCodeName="white"
			applyBtnName="NewItemApply"
			pageType="newItem"
			itemPrice="$0.00";
		case "get-item":
			pageTitle="Item Lookup"

			templateName="item.tpl"
			barCodeBtnLabel="Scan"
			clsbCodeBtn="clsScanCode"
			//barCodeButtonID="bCodeLookup"
			applyBtnName="ExItemApply"
			pageType="exItem"
			itemPrice="$";
		default:
			pageTitle="Inventory Management"
			templateName="main.tpl"
	}



	if(session.Values["username"] == nil) {
		//Not logged in, redirect to the login page
		templateName="login.tpl"
	}

	if(checkSetupComplete()==false) {
		//Setup has not been completed, load that page
		templateName="first_setup.tpl"
		templatePath="sys-templates/first_setup.tpl"

	} else {
		if (mobile) {
			templatePath = "m-templates/" + templateName
			mobOrPcHomeBtn = "/m"
		} else {
			templatePath = "pos-templates/" + templateName
			mobOrPcHomeBtn = "/front"
		}
	}

	tpl:=template.New(templateName)
	tpl=tpl.Funcs(template.FuncMap{
		"FncGlobalDiscount1": func() string {
			//Return list of current discounts for item.tpl
			return getDiscounts();
		},

		"FnMbiTrkc": func() string {
			formattedCatList:=""
			categoryList:=strings.Split(getCategories(),",")
			fmt.Println("Array items: " + strconv.Itoa(len(categoryList)))

			for i:=0;i<len(categoryList)-1;i++ {
				fmt.Println("Item " + strconv.Itoa(i))
				fmt.Println(categoryList[i])
				itemSplit:=strings.Split(categoryList[i],"=")
				if(itemSplit[1] != "No category") {
					formattedCatList += "<row><button name=\"categoryName\" value=\"" + itemSplit[0] + "\" class=\"category-buttons btn btn-block\" data-dismiss=\"modal\">" + itemSplit[1] + "</button></row>"
				}
			}

			return formattedCatList
		},
		"GetColors": func() string {
			return getColors()
		},
	})

	tpl,err:=tpl.ParseFiles(templatePath)
	if err!=nil { log.Fatalln(err.Error()) }
	err = tpl.Execute(w,PageTags{PageType:pageType,ActionTitle:pageTitle,CurrentUser:loggedInUser,MobOrPcHomeBtn:mobOrPcHomeBtn,ApplyBtnName:applyBtnName,CopyRight:copyrightMsg,BarcodeBtnLabel:barCodeBtnLabel,BarcodeButtonFunc:barCodeButtonFunc,BarCodeID:barCodeID,ClsbCodeBtn:clsbCodeBtn,ItemPrice:itemPrice,SelectedColorCode:getDefaultColor(1,"White"),SelectedColorCodeHtml:getDefaultColor(2,"White"),})
	if err!=nil {
		log.Fatalln(err)
	}
}

func main() {
	port:=strconv.Itoa(setVars())

	router:=httprouter.New()
	router.GET("/m",pageHandler)					//Main page handler with no pages named
	router.GET("/m/:page",pageHandler)				//Allows for specific pages using json format
	router.GET("/front",pageHandler)
	router.GET("/front/:page",pageHandler)
	router.POST("/addProduct",addProduct)				//Ajax call to add new item
	router.POST("/mkBarCode",generateBarCode)			//Ajax call to generate new bar codes
	router.POST("/login",doLogin)
	router.POST("/logout",doLogout)
	router.POST("/printCode", printBarCode)
	router.POST("/setAdminPwd", setAdminPwd)
	router.POST("/chPwd",chPwd)
	router.POST("/removePassword",removePassword)
	router.POST("/removeUser",removeUser)
	router.POST("/addUser",addUser)
	router.POST("/getConfig/:page",getConfig)
	router.POST("/getUserDetails",getUserDetails)
	router.POST("/saveUserDetails",saveUserDetails)
	router.POST("/isUserPasswordSet",isUserPasswordSet)
	router.POST("/getSystemGroups",getSystemGroups)
	http.Handle("/css/", http.StripPrefix("css/", http.FileServer(http.Dir("./css"))))
	fmt.Println("Product Management System listening and ready on port: " +port)
	http.ListenAndServe(":"+port,context.ClearHandler(router))
}
