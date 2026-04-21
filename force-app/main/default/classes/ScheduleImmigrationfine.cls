global class ScheduleImmigrationfine implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchImmigrationApplicationProcess('checkFinePayment'), 1);
    }
}