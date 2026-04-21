global with sharing class DocumentPushDDACCRMBatchSchedule implements Schedulable {

    global void execute(SchedulableContext sc) {
        DocumentPushDDACCRMBatch batch = new DocumentPushDDACCRMBatch();
        database.executeBatch(batch, 10);
     }
}