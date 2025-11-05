package dbconnectionmongo;
import com.mongodb.client.*;
import com.mongodb.client.model.*;
import org.bson.Document;
import java.util.Scanner;
public class mongodbconnection {

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		try(MongoClient mongoclient = MongoClients.create("mongodb://127.0.0.1:27017/movieApp")){
			MongoDatabase db = mongoclient.getDatabase("movieApp");
			MongoCollection<Document> dc = db.getCollection("new");
			int choice;
			do {
				System.out.println("MENU");
				System.out.println("1).ADD");
				System.out.println("2).DISPLAY");
				System.out.println("3).UPDATE");
				System.out.println("4).DELETE");
				System.out.println("5).EXIT");
				System.out.println("ENTER YOUR CHOICE:");
				choice = sc.nextInt();
				sc.nextLine();
				switch(choice) {
					case 1:
						System.out.println("Enter name: ");
						String name = sc.nextLine();
						System.out.println("Enter id: ");
						String id = sc.nextLine();
						System.out.println("Enter major: ");
						String major = sc.nextLine();
						System.out.println("Enter gpa: ");
						double gpa = sc.nextDouble();
						Document doc = new Document("name",name)
										.append("stud_id",id)
										.append("major", major)
										.append("gpa", gpa);
						dc.insertOne(doc);
                        System.out.println("✅ Student added successfully!");
                        break;
					case 2:
						System.out.println("list of things here");
//						for(Document d: dc.find()) {
//							System.out.println(d.toJson());
//						}
						for(Document d:dc.find()) {
							System.out.println("name: "+ d.getString("name")
						+ "ID:" + d.getString("stud_id")
						+ " major:"+d.getString("major")
						+"gpa:"+d.getDouble("gpa"));
						}
                        break;
					case 3:
						System.out.println("id to update");
						String uid = sc.nextLine();
						System.out.println("Enter newgpa: ");
						double newgpa = sc.nextDouble();
						var updateResult = dc.updateOne(
								Filters.eq("stud_id",uid),
								Updates.set("gpa",newgpa));
						if(updateResult.getModifiedCount()>0) {
							System.out.println("✅ GPA updated successfully!");
						}
						else {
							System.out.println("✅ GPA updated unsuccessfully!");
						}
                        System.out.println("✅ Stud updated successfully!");
                        break;
					case 4:
						System.out.println("id to delete");
						String did = sc.nextLine();
						var deleteResult = dc.deleteOne(Filters.eq("stud_id",did));
                        if (deleteResult.getDeletedCount() > 0)
                            System.out.println("✅ Student deleted successfully!");
                        else
                            System.out.println("⚠️ No student found with that ID.");
                        break;
					case 5:
						System.out.println("BYE ");
                        break;
                    default:
                    	System.out.println("BYE ");
				}
			}while(choice!=5);
			}catch(Exception e) {
				System.err.println("⚠️ Error: " + e.getMessage());
		}
		sc.close();

	}

}
