global class WsCAll_InsertUsr_scdl implements Schedulable{

    global static void scheduleIt(String scheduleName) {
        for (integer i=0;i<12;i++) {System.schedule(scheduleName + '-'+i, '0 '+(i*5)+' * * * ?', new WsCAll_InsertUsr_scdl());}
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new WsCAll_InsertUsr(), 1);
    }
}