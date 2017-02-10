/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package thriftstore.license.server.management;

import java.io.IOException;
import java.net.URL;
import java.util.Optional;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.control.TextInputDialog;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author matt
 */
public class LoginFXMLController implements Initializable {
    private String dbServer;
    
    @FXML
    private Label lblError;
    
    @FXML
    private Label lblStatus;
    
    @FXML
    private Button btnLogin;
    
    @FXML
    private AnchorPane AnchorPane;
    
    @FXML
    private TextField txtUsername;
    @FXML
    private PasswordField txtPassword;

    public LoginFXMLController() {
        this.dbServer = "devbox";
        //lblStatus.setText("Server:"+dbServer);
    }
    /**
     * Initializes the controller class.
     */
    
    @FXML
    private void btnConfigClicked(ActionEvent event) throws IOException {
        TextInputDialog dialog = new TextInputDialog(this.dbServer);
        dialog.setHeaderText("");
        dialog.setTitle("License Server");
        dialog.setContentText("License Server Address:");
        Optional<String> result = dialog.showAndWait();
        if (result.isPresent()){
            dbServer=result.get();
            lblStatus.setText("Server:"+dbServer);
        }
    }
    
    @FXML
    private void btnLoginClicked(ActionEvent event) throws IOException {
        int loginResults;
        lblError.setText("");
        
        SQLAccess sqlAccess=SQLAccess.getInstance();
        
        loginResults=sqlAccess.checkCredentials(dbServer,txtUsername.getText(),txtPassword.getText());
        
        if(loginResults==9999) {
            Stage stage = (Stage) ((Node)event.getSource()).getScene().getWindow(); 
            Parent root;

            root = FXMLLoader.load(getClass().getResource("MainApp.fxml"));
            Scene scene = new Scene(root);
            stage.setScene(scene);
        }
        else {
            Alert alert = new Alert(AlertType.ERROR);
            
            switch(loginResults) {
                case 1045:
                    lblError.setText(Integer.toString(loginResults)+": Invalid username or password");
                    break;
                case 0:
                    lblError.setText(Integer.toString(loginResults)+": Invalid server or server is down.");
                    break;
                default:
                    alert.setTitle("Error");
                    alert.setHeaderText("");
                    alert.setContentText(Integer.toString(loginResults));

                    alert.showAndWait();
            }
            
        }
    }
    
    @FXML
    private void usernameChanged(ActionEvent event) {
        btnLogin.setDisable(false);
    }
    
    @FXML void passwordChanged(ActionEvent event) {
        
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
        lblStatus.setText("Server:"+dbServer);
    }    
}
