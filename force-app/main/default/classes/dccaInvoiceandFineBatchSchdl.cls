global class dccaInvoiceandFineBatchSchdl implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new dccaInvoiceandFineBatch(), 1);
    }
}