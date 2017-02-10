
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package thriftstore.license.server.management;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author matt
 */
public class SQLAccess {
    private static SQLAccess instance = null;
    
    private String dbUsername;
    private String dbPassword;
    
    private Connection con;
    private Statement stmt;
    private ResultSet rs;
    
    protected SQLAccess() {
        System.out.println("Initialized sql class");
        
        
    }
    
    public static synchronized SQLAccess getInstance() {
        
        if(instance==null) {
            instance=new SQLAccess();
        }
        return instance;
    }
    
    public int checkCredentials(String dbServer, String username, String password)
    {
        int loginResults;
        String url = "jdbc:mysql://"+dbServer+":3306/LICENSE_SERVER";
        
        try {
            
            con = DriverManager.getConnection(url, username, password);
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT VERSION()");

            if (rs.next()) {
                dbUsername=username;
                dbPassword=password;
            }
            
            loginResults=9999;
            
        }
        catch (SQLException ex) {
            loginResults=ex.getErrorCode();
        }

        return loginResults;
    }
    
    public void printCredentials() {
        System.out.println(dbUsername + "|" + dbPassword);
    }
}
