@isTest
public class dccaSrvRqBatchSchldTest {
 static testMethod void myTestMethod() {
         test.starttest();
         dccaSrvRqBatchSchld myClass = new dccaSrvRqBatchSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
}
}