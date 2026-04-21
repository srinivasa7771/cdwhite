global class scheduledConfigDSGRec implements Schedulable{

    global static void scheduleIt(String DSGRec0, String DSGRec30) {
        scheduledConfigDSGRec dsg = new scheduledConfigDSGRec();
        System.schedule(DSGRec0, gu.csStr('scheduledDSGRec_0'), dsg);
        System.schedule(DSGRec30, gu.csStr('scheduledDSGRec_30'), dsg);
    }

    global void execute(SchedulableContext sc) {
        BatchDEGRec b = new BatchDEGRec();
        database.executebatch(b, 1);
     }
}