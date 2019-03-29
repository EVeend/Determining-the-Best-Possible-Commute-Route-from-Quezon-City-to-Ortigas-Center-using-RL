/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package function;

import java.sql.*;

/**
 *
 * @author Laiza Marie
 */
public class DatabaseConnection {
    
    public static Connection connectDatabase(){
        try{
            String dbDriver = "oracle.jdbc.driver.OracleDriver";
            String dbURL = "jdbc:oracle:thin:@//localhost:1521:XE";
            String username = "ThesisAdmin";
            String password = "beanbelter";
            Connection test;
            
            Class.forName(dbDriver);
            test = DriverManager.getConnection(dbURL, username, password);
            System.out.println("Success");
            return test;
            
            
        }
        catch(Exception e){
            System.out.println("Error");
            e.printStackTrace();
        }
    return null;
    }
    
}
