//package dbconnection;
//
//import java.sql.*;
//import java.util.Scanner;
//
//public class Dbconnection {
//
//    public static void main(String[] args) {
//        Connection connection = null;
//
//        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            connection = DriverManager.getConnection(
//                    "jdbc:mysql://127.0.0.1:3306/demodb"
//, "root", "adi@123");
//
//            Scanner sc = new Scanner(System.in);
//            Statement statement = connection.createStatement();
//            ResultSet resultSet = statement.executeQuery("SELECT * FROM emp");
//
//            System.out.println("Existing Employees:");
//            while (resultSet.next()) {
//                int eno = resultSet.getInt("empno");
//                String enm = resultSet.getString("ename").trim();
//                System.out.println("Employee No: " + eno + ", Employee Name: " + enm);
//            }
//            System.out.println("\nEnter new employee number and name:");
//            System.out.print("Employee No: ");
//            int eno = sc.nextInt();
//            sc.nextLine(); // Consume leftover newline
//            System.out.print("Employee Name: ");
//            String enm = sc.nextLine();
//            String query = "INSERT INTO emp VALUES (" + eno + ", '" + enm + "', 80000, 2, 101)";
//
//            try {
//                statement.executeUpdate(query);
//                System.out.println("Record inserted successfully into emp table.");
//            } catch (SQLIntegrityConstraintViolationException e) {
//                throw new RuntimeException("Employee number already exists.");
//            }
//            System.out.println("\nEnter employee number to update their name:");
//            System.out.print("Employee No: ");
//            int updateEno = sc.nextInt();
//            sc.nextLine();
//            System.out.print("New Employee Name: ");
//            String updateEnm = sc.nextLine();
//
//            String updateQuery = "UPDATE emp SET ename = '" + updateEnm + "' WHERE empno = " + updateEno;
//            int rowsUpdated = statement.executeUpdate(updateQuery);
//            if (rowsUpdated > 0) {
//                System.out.println("Record updated successfully.");
//            } else {
//                System.out.println("Update Failed: Employee not found.");
//            }
//            System.out.println("\nEnter employee number to delete:");
//            System.out.print("Employee No: ");
//            int deleteEno = sc.nextInt();
//
//            String deleteQuery = "DELETE FROM emp WHERE empno = " + deleteEno;
//            int rowsDeleted = statement.executeUpdate(deleteQuery);
//            if (rowsDeleted > 0) {
//                System.out.println("Record deleted successfully.");
//            } else {
//                System.out.println("Delete Failed: Employee not found.");
//            }
//
//            resultSet.close();
//            statement.close();
//            connection.close();
//            sc.close();
//
//        } catch (Exception e) {
//            System.out.println("Error: " + e);
//        }
//    }
//}
//ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'adi@123';
//FLUSH PRIVILEGES;
// above is imp for getting access to it

package dbconnection;

import java.sql.*;
import java.util.Scanner;

public class Dbconnection {

    public static void main(String[] args) {
        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(
                    "jdbc:mysql://127.0.0.1:3306/demodb", "root", "adi@123");

            Scanner sc = new Scanner(System.in);
            Statement statement = connection.createStatement();

            while (true) {
                System.out.println("\n===== Employee Management Menu =====");
                System.out.println("1. Display Employees");
                System.out.println("2. Insert New Employee");
                System.out.println("3. Update Employee Name");
                System.out.println("4. Delete Employee");
                System.out.println("5. Exit");
                System.out.print("Enter your choice: ");
                int choice = sc.nextInt();
                sc.nextLine();

                switch (choice) {
                    case 1:
                        ResultSet resultSet = statement.executeQuery("SELECT * FROM emp");
                        System.out.println("\nExisting Employees:");
                        while (resultSet.next()) {
                            int eno = resultSet.getInt("empno");
                            String enm = resultSet.getString("ename").trim();
                            System.out.println("Employee No: " + eno + ", Employee Name: " + enm);
                        }
                        resultSet.close();
                        break;

                    case 2:
                        System.out.print("\nEnter new employee number: ");
                        int eno = sc.nextInt();
                        sc.nextLine();
                        System.out.print("Enter new employee name: ");
                        String enm = sc.nextLine();

                        String insertQuery = "INSERT INTO emp VALUES (" + eno + ", '" + enm + "', 80000, 2, 101)";
                        try {
                            statement.executeUpdate(insertQuery);
                            System.out.println("Record inserted successfully.");
                        } catch (SQLIntegrityConstraintViolationException e) {
                            System.out.println("Insert Failed: Employee number already exists.");
                        }
                        break;

                    case 3:
                        System.out.print("\nEnter employee number to update: ");
                        int updateEno = sc.nextInt();
                        sc.nextLine();
                        System.out.print("Enter new employee name: ");
                        String updateEnm = sc.nextLine();

                        String updateQuery = "UPDATE emp SET ename = '" + updateEnm + "' WHERE empno = " + updateEno;
                        int rowsUpdated = statement.executeUpdate(updateQuery);
                        if (rowsUpdated > 0) {
                            System.out.println("Record updated successfully.");
                        } else {
                            System.out.println("Update Failed: Employee not found.");
                        }
                        break;

                    case 4:
                        System.out.print("\nEnter employee number to delete: ");
                        int deleteEno = sc.nextInt();

                        String deleteQuery = "DELETE FROM emp WHERE empno = " + deleteEno;
                        int rowsDeleted = statement.executeUpdate(deleteQuery);
                        if (rowsDeleted > 0) {
                            System.out.println("Record deleted successfully.");
                        } else {
                            System.out.println("Delete Failed: Employee not found.");
                        }
                        break;

                    case 5:
                        System.out.println("Exiting program...");
                        statement.close();
                        connection.close();
                        sc.close();
                        System.exit(0);

                    default:
                        System.out.println("Invalid choice! Please try again.");
                }
            }

        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }
}
