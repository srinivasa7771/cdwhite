global class axsAmendCheckBatchSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new axsAmendCheckBatch('', 0), 1);
    }
}