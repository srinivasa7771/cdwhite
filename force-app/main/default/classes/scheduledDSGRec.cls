global class scheduledDSGRec implements Schedulable{
     global void execute(SchedulableContext sc) {
        BatchDEGRec  b = new BatchDEGRec();
        database.executebatch(b, 10);
     }
  }