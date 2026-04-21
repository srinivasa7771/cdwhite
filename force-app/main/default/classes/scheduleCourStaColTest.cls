@isTest
public class scheduleCourStaColTest {
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 0 15 3 ? *';

        // Create your test data

        Test.startTest();

        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new scheduleCourStaCol())  ; //System.Sche(,  , );
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        // Add assert here to validate result
    }

}