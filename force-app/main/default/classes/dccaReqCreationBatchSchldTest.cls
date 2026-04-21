@isTest
public class dccaReqCreationBatchSchldTest {
    static testMethod void myTestMethod() {
         test.starttest();
         dccaReqCreationBatchSchld myClass = new dccaReqCreationBatchSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
}
}