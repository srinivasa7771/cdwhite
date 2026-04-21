global class dccaSrvRqBatchSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        dccaServiceRqBatch b = new dccaServiceRqBatch();
        database.executebatch(b, 1);
    }
}