/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main.resources.fxml;

import function.*;
import main.resources.fxml.*;
import java.net.URL;
import java.util.ResourceBundle;
import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;


/**
 *
 * @author Laiza Marie
 */
public class mainController implements Initializable {
    
    @FXML
    private ChoiceBox origin_dropdown, destination_dropdown, time_dropdown;
    
    DatabaseConnection connection = new DatabaseConnection();
    Connection connectDB;
    PreparedStatement ps;
    ResultSet rs;
    
    ObservableList<String> origin, destination, time;

   @Override
    public void initialize(URL location, ResourceBundle resources) {
        
        connectDB = connection.connectDatabase();
        String getOrigin = "SELECT location_name FROM Locations WHERE location_type = 'Origin'";
        String getDestination = "SELECT location_name FROM Locations WHERE location_type = 'Destination'";
        String getTime = "SELECT hour FROM Time";
        
        
        //Get location names of origin from database
        try{
            ps = connectDB.prepareStatement(getOrigin);
            System.out.println("Connection success.");
            rs = ps.executeQuery();
            origin = FXCollections.observableArrayList();
            System.out.println("Query execution success.");
            while (rs.next()) {
                origin.add(rs.getString("location_name"));
            }
            System.out.println(origin);
            origin_dropdown.setItems(origin);
            System.out.println("Origin dropdown success.");
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //Get location names of destination from database
        try{
            ps = connectDB.prepareStatement(getDestination);
            System.out.println("Connection success.");
            rs = ps.executeQuery();
            destination = FXCollections.observableArrayList();
            System.out.println("Query execution success.");
            while (rs.next()) {
                destination.add(rs.getString("location_name"));
            }
            System.out.println(destination);
            destination_dropdown.setItems(destination);
            System.out.println("Destination dropdown success.");
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //Get time from database
        try{
            ps = connectDB.prepareStatement(getTime);
            System.out.println("Connection success.");
            rs = ps.executeQuery();
            time = FXCollections.observableArrayList();
            System.out.println("Query execution success.");
            while (rs.next()) {
                time.add(rs.getString("hour"));
            }
            System.out.println(time);
            time_dropdown.setItems(time);
            System.out.println("Time dropdown success.");
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        /*
        origin.getItems().removeAll(origin.getItems());
        origin.getItems().addAll("Eastwood City", "Quezon City Circle", "University of the Philippines","SM North EDSA Public Transport Terminal",
                "UP-Ayala Technohub","LRT Katipunan Station","LRT Araneta-Cubao Station");
        // initial.getSelectionModel().select("Option B");
        destination.getItems().removeAll(destination.getItems());
        destination.getItems().addAll("EDSA Shrine","Robinsons Galleria","Saint Pedro Poveda College","Robinsons Equitable Tower",
                "Crowne Plaza", "Asian Development Bank","SM Megamall","Ortigas Building","Robinsons Cyberscape Alpha",
                "East of Galleria Condominium","Ortigas Park","San Miguel Corporation Head Office","EDSA Shangri-La","Lourdes School of Mandaluyong",
                "University of Asia and the Pacific","The Pearl Place","The Philippine Stock Exchange, Inc.");
        */
    } 
    
}