@IsTest
public class BatchtoUpdateUBOfilenameTest {
@IsTest
    static void UpdateUBOfilenameTest() {
        try{

           BatchtoUpdateUBOfilenames obj = new BatchtoUpdateUBOfilenames();
            database.executeBatch(obj, 1);
        }catch (Exception e) {}
    }
}