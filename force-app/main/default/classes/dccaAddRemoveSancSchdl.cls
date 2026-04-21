global class dccaAddRemoveSancSchdl implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new dccaAddRemoveSanc(), 1);
    }
}