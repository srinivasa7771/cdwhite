global class ScheduleStatusUpadte implements Schedulable{
    global String batchname {set;get;}
    global integer ndays {set;get;}
    global ScheduleStatusUpadte(String bname, integer ndays) {
        batchname = bname;
        this.ndays = ndays;
    }
    global void execute(SchedulableContext sc) {
        if (batchname == 'updateEP') {
            database.executebatch(new BatchImmigrationApplicationProcess('updateEP', ndays), 1);
        }
        else
         database.executebatch(new BatchImmigrationApplicationProcess(batchname), 1);  /* updateRP */
    }
}