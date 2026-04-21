global class AutoInsertUsr_schdl implements Schedulable{

    global static void scheduleIt(String scheduleName) {
        for (integer i=0;i<12;i++) {System.schedule(scheduleName + '-'+i, '0 '+(i*5)+' * * * ?', new AutoInsertUsr_schdl());}
    }

    global void execute(SchedulableContext sc) {
       Database.executeBatch(new AutoInsertUsr(), 1);
    }
}