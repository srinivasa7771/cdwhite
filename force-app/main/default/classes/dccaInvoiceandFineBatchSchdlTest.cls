@isTest
public class dccaInvoiceandFineBatchSchdlTest {
static testMethod void myTestMethod() {
         test.starttest();
         dccaInvoiceandFineBatchSchdl myClass = new dccaInvoiceandFineBatchSchdl();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}