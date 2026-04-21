global class ScheduleImmigrationComplete implements Schedulable{
   global void execute(SchedulableContext sc) {
        database.executebatch(new BatchImmigrationApplicationProcess('updateEPStatus'), 1);
       database.executebatch(new BatchImmigrationApplicationProcess('updateEP'), 1);
    }
}