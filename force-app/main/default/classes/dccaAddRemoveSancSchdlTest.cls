@isTest
public class dccaAddRemoveSancSchdlTest {
    static testMethod void myTestMethod() {
         test.starttest();
         dccaAddRemoveSancSchdl myClass = new dccaAddRemoveSancSchdl();
         String chron = '0 0 23 * * ?';
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
}

}