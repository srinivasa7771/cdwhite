@isTest
public class BatchUpdateNxtStatusTest {
@isTest static void testUpdateNxtStatus() {
        Database.executeBatch(new BatchUpdateNxtStatus(), 1);
    }
}