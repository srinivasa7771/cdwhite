global class ScheduleImmigrationPayment implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchImmigrationApplicationProcess('invokePayment'), 1);
    }
}