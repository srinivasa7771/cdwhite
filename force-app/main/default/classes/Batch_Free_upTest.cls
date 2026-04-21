@isTest
public class Batch_Free_upTest {
     static testMethod void doTest() {
        test.startTest();
        Batch_Free_up ctrl =  new Batch_Free_up();

          Database.executeBatch(ctrl, 1);
        test.stopTest();
    }
}