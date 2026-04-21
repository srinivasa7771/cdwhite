@isTest
public class TecomInvoiceUpdateBatchSchdlTest {
static testMethod void myTestMethod() {
         test.starttest();
         TecomInvoiceUpdateBatchSchdl myClass = new TecomInvoiceUpdateBatchSchdl();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}