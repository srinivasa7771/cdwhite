@isTest
private class ScheduleBatchTokentest {
static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 6 * * ?';
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new ScheduleBatchToken())  ;
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}