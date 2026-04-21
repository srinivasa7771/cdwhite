@isTest
public class axsAmendCheckBatchSchldTest {
 static testMethod void myTestMethod() {
         test.starttest();
         axsAmendCheckBatchSchld myClass = new axsAmendCheckBatchSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}