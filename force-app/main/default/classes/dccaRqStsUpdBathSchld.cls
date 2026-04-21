global class dccaRqStsUpdBathSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        dccaStatusUpdBatch b = new dccaStatusUpdBatch();
        database.executebatch(b, 1);
    }
}