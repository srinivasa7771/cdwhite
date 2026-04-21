@isTest
public class dccaRqStsUpdBathSchldTest {
 static testMethod void myTestMethod() {
         test.starttest();
         dccaRqStsUpdBathSchld myClass = new dccaRqStsUpdBathSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
}
}