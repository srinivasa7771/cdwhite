@isTest
public class ScheduleStatusUpadteTest {
 static testMethod void unitTest01() {
     Test.startTest();
        System.schedule('StatusUpadteTestJob', '0 0 0 3 9 ? 2050', new ScheduleStatusUpadte('updateEP', 1));
     Test.stopTest();
 }
    static testMethod void unitTest02() {
     Test.startTest();
        System.schedule('StatusUpadteTestJob1', '0 0 0 3 9 ? 2050', new ScheduleStatusUpadte('updateRP', 1));
     Test.stopTest();
 }
}