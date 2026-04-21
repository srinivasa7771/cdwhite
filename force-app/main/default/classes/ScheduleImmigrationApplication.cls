global class ScheduleImmigrationApplication implements Schedulable{

    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchImmigrationApplicationProcess('createApplication'), 1);
        database.executebatch(new BatchImmigrationApplicationProcess('uploadSingleDocument'), 1);
        //database.executebatch(new BatchImmigrationApplicationProcess('invokePayment'), 1);
        database.executebatch(new BatchImmigrationApplicationProcess('checkApplicationStatus'), 1);
    }
}