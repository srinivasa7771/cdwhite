@isTest
public class dccaLicRenewalDocsSchldTest {
static testMethod void myTestMethod() {        
         test.starttest();
         dccaLicRenewalDocsSchld myClass = new dccaLicRenewalDocsSchld();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched',chron,myClass);
         test.stopTest();
}
}