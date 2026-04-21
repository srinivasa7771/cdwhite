@isTest
public class CourBtchSchdl_Test {

      @testSetup static void setup() {
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c scheduledDSGRec_30 = new gStg__c(name='scheduledDSGRec_30', Text_Value__c = '0 30 * * * ?');
        gStg__c scheduledDSGRec_0 = new gStg__c(name='scheduledDSGRec_0', Text_Value__c = '0 0 * * * ?');
        lstGStg.add(scheduledDSGRec_30);lstGStg.add(scheduledDSGRec_0);

        insert lstGStg;
    }

    @isTest static void testPushReqItems() {
        CourBtchSchdl.scheduleIt('test');
        /*for (integer i=0;i<2;i++) {
            System.schedule('Cour Btch Schdle '+i, '0 '+(i*30)+' * * * ?', new CourBtchSchdl());
        }*/
    }
}