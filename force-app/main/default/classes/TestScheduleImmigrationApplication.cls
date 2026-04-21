@isTest
public class TestScheduleImmigrationApplication {

    static testMethod void testImmApplication () {

        System.schedule('Job1234' , '0 15 * * * ?', new ScheduleImmigrationApplication());
        System.schedule('Job_x1' , '0 15 * * * ?', new ScheduleImmigrationPayment());

    }
}