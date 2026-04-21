global class ScheduleBatch
{
    global class SchedulerDeg implements Schedulable {

        global void execute(SchedulableContext SC) {
            exeSchdeg();
        }

        global void exeSchdeg() {
            database.executeBatch(new BatchDEGRecAuth(), 1);
        }

    }

    global class SchedulerInvoice implements Schedulable {

        global void execute(SchedulableContext SC) {
            exeSchInvoice();
        }

        global void exeSchInvoice() {
            Datetime firstDtOfMonth = System.today().toStartOfMonth();
            Datetime LstDtOfMOnth = firstDtOfMonth.addMonths(1).addDays(-1);
            Datetime firstDayOfMonth = System.today();
            Database.executeBatch(new BatchTransctionOraFu(firstDayOfMonth.format('yyyy-MM-dd'), LstDtOfMOnth.format('yyyy-MM-dd'), '', 'ONLY_INVOICE', '', 1), 1);
        }
    }

    global class SchedulerReceipt implements Schedulable {
        global void execute(SchedulableContext SC) {
            exeSchReceipt();
        }

        global void exeSchReceipt() {
            Datetime firstDtOfMonth = System.today().toStartOfMonth();
            Datetime LstDtOfMOnth = firstDtOfMonth.addMonths(1).addDays(-1);
            Datetime firstDayOfMonth = System.today();
            Database.executeBatch(new BatchTransctionOraFu(firstDayOfMonth.format('yyyy-MM-dd'), LstDtOfMOnth.format('yyyy-MM-dd'), '', 'ONLY_RECEIPT', ''), 1);
        }
    }

    global class SchedulerFreelancer implements Schedulable {
        global void execute(SchedulableContext SC) {
            exeSchFreeLancer();
        }

        global void exeSchFreeLancer() {
            Database.executeBatch(new UpdateFreelancerUser('All'), 1);
        }
    }

     global class SchedulerBatchCancelSR implements Schedulable {

        global void execute(SchedulableContext SC) {
            exeSchSR();
        }

        global void exeSchSR() {
            database.executeBatch(new BatchCancelUnderCancellationSR());
        }

    }

   /* global class SchedulerBatchSurvey implements Schedulable {

        global void execute(SchedulableContext SC) {
            exeSchSurvey();
        }

        global void exeSchSurvey() {
            BatchSurveyUpdates batchAfPay = new BatchSurveyUpdates('afterpayment');
        }

    }*/

    global class ScheduleDeg
    {
        global void callScheduler() {
            SchedulerDeg m = new SchedulerDeg();
            String sch1 = '0 0 08 * * ? *';
            String sch2 = '0 0 22 * * ? *';
            String jobID1 = System.schedule('BatchDEGRecAuth1', sch1, m);
            String jobID2 = System.schedule('BatchDEGRecAuth2', sch2, m);
        }

    }

    global class ScheduleInvoice
    {
        global void callScheduler() {
            SchedulerInvoice m = new SchedulerInvoice();
            String sch1 = '0 0 7 * * ? *';
            String sch2 = '0 0 11 * * ? *';
            String sch3 = '0 0 15 * * ? *';
            String sch4 = '0 0 22 *  * ? *';
            String jobID1 = System.schedule('SchedulerInvoice1', sch1, m);
            String jobID2 = System.schedule('SchedulerInvoice2', sch2, m);
            String jobID3 = System.schedule('SchedulerInvoice3', sch3, m);
            String jobID4 = System.schedule('SchedulerInvoice4', sch4, m);
        }

    }

    global class ScheduleReceipt
    {
        global void callScheduler() {
            SchedulerReceipt m = new SchedulerReceipt();
            String sch1 = '0 0 * * * ?';
            String jobID1 = System.schedule('SchedulerReceipt', sch1, m);
        }

    }

    global class ScheduleFreelancer
    {
        global void callScheduler() {
            SchedulerFreelancer m = new SchedulerFreelancer();
            String sch1 = '0 0 23 * * ? *';
            String jobID1 = System.schedule('SchedulerFreelancer', sch1, m);
        }

    }

     global class ScheduleBatchCancelSR
    {
        global void callScheduler() {
            SchedulerBatchCancelSR m = new SchedulerBatchCancelSR();
            String sch1 = '0 0 21 * * ? *';
            String jobID1 = System.schedule('SchedulerBatchCancelSR', sch1, m);
        }

    }

     /*global class ScheduleBatchSurvey
    {
        global void callScheduler() {
            SchedulerBatchSurvey m = new SchedulerBatchSurvey();
            String sch1 = '0 0 7 * * ? *';
            String jobID1 = System.schedule('SchedulerBatchSurvey', sch1, m);
        }

    }*/

    global void scheduleAll() {
        new ScheduleFreelancer().callScheduler();
        new ScheduleDeg().callScheduler();
        new ScheduleInvoice().callScheduler();
        new ScheduleReceipt().callScheduler();
        new ScheduleBatchCancelSR().callScheduler();
        /*new ScheduleBatchSurvey().callScheduler();*/

    }

}