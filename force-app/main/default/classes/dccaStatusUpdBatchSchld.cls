global class dccaStatusUpdBatchSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new dccaStatusUpdBatch(), 1);
    }
}