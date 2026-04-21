@isTest
public class ScheduleBatchTest {

    static testMethod void doTest() {

        ScheduleBatch objSch = new ScheduleBatch();

        Test.startTest();

        objSch.scheduleAll();

        String sch1 = '0 0 * * * ? *';

        ScheduleBatch.SchedulerDeg objdeg = new ScheduleBatch.SchedulerDeg();
        objdeg.exeSchdeg();
        String jobID1 = System.schedule('BatchDEGRecAuthTest', sch1, objdeg);

        ScheduleBatch.SchedulerInvoice objInv = new ScheduleBatch.SchedulerInvoice();
         objInv.exeSchInvoice();
        String jobID2 = System.schedule('Invoice', sch1, objInv);

        ScheduleBatch.SchedulerReceipt objRec = new ScheduleBatch.SchedulerReceipt();
        objRec.exeSchReceipt();
        String jobID3 = System.schedule('ReceiptTest', sch1, objRec);

        ScheduleBatch.SchedulerFreelancer objFree = new ScheduleBatch.SchedulerFreelancer();
        objFree.exeSchFreeLancer();
        String jobID4 = System.schedule('FreelancerTest', sch1, objFree);

        ScheduleBatch.SchedulerBatchCancelSR objCancelSR = new ScheduleBatch.SchedulerBatchCancelSR();
        objCancelSR.exeSchSR();
        String jobID5 = System.schedule('CancelSrTest', sch1, objCancelSR);

         /*ScheduleBatch.SchedulerBatchSurvey objbatchSurvey = new ScheduleBatch.SchedulerBatchSurvey();
        objbatchSurvey.exeSchSurvey();
        String jobID6 = System.schedule('batchSurvey', sch1, objCancelSR); */

        Test.stopTest();
    }

}