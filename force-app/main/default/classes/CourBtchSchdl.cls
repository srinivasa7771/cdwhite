global  class CourBtchSchdl implements Schedulable{

    global static void scheduleIt(String scheduleName) {
        scheduledConfigDSGRec dsg = new scheduledConfigDSGRec();
        System.schedule(scheduleName, gu.csStr('scheduledDSGRec_30'), new CourBtchSchdl());
    }

    global void execute(SchedulableContext sc) {
        tecomBatch_CourStaUpdt b = new tecomBatch_CourStaUpdt ();
        database.executebatch(b, 10);
    }
}