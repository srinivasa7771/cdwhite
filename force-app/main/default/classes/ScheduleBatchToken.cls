global class ScheduleBatchToken implements Schedulable{
    global void execute(SchedulableContext sc) {
         Database.executeBatch(new BatchGDRFAAccessToken(), 1);
    }
}