global  class BatchCourBookingSchdl  implements Schedulable{

    global static void scheduleIt(String scheduleName) {
        for (integer i=0;i<30;i++) {
            System.schedule(scheduleName + '-'+i, '0 '+(i*2)+' * * * ?', new BatchCourBookingSchdl());
        }
    }

    global void execute(SchedulableContext sc) {
        BatchCourBooking b = new BatchCourBooking(); database.executebatch(b, 5);
    }
}