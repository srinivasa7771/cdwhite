@isTest
public class ScheduleRefundPayTest {
 static testMethod void unitTest01() {
        Test.startTest();
        System.schedule('refundTestJob', '0 0 0 3 9 ? 2050', new ScheduleRefundPay());
        Test.stopTest();
 }

}