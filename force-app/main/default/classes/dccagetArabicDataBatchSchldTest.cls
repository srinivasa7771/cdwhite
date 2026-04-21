@isTest
public class dccagetArabicDataBatchSchldTest {
 static testMethod void myTestMethod() {
         test.starttest();
         dccagetArabicDataBatchSchld myClass = new dccagetArabicDataBatchSchld();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}