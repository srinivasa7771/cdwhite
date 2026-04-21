@isTest
public class dccaStatusUpdBatchSchldTest {
 static testMethod void myTestMethod() {
         test.starttest();
         dccaStatusUpdBatchSchld myClass = new dccaStatusUpdBatchSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
}
}