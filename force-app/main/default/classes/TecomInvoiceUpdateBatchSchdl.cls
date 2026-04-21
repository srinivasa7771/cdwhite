global class TecomInvoiceUpdateBatchSchdl implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new TecomInvoiceUpdateBatch(), 1);
    }
}