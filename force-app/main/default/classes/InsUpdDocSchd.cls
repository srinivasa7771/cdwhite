global class InsUpdDocSchd implements Schedulable {
    global void execute(SchedulableContext sc) {
        InsdocUploadBatch b = new InsdocUploadBatch();
        database.executebatch(b, 20);
    }
}