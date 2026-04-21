global class dccagetArabicDataBatchSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        dccagetArabicDataBatch b = new dccagetArabicDataBatch();
        database.executebatch(b, 1);
    }
}