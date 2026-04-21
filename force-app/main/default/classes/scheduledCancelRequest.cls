global class scheduledCancelRequest implements Schedulable{
     global void execute(SchedulableContext sc) {
        BatchCancelRequests  b = new BatchCancelRequests();
        database.executebatch(b, 1);
     }
  }