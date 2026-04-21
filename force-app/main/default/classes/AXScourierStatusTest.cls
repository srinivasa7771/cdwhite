@isTest
private class AXScourierStatusTest {
      @testSetup static void setup() {

        List < gStg__c > lstGStg = new List < gStg__c > ();

        gStg__c bh = new gStg__c(name = 'BH', Text_Value__c = '01m20000000BKEa');
        lstGStg.add(bh);
        gStg__c sla = new gStg__c(name = 'slaExpiry', Number_Value__c = 50);
        lstGStg.add(sla);
        gStg__c cour = new gStg__c(name = 'Courier_login', Text_Value__c = '61812, 61812, AXSEMPOST');
        lstGStg.add(cour);
        insert lstGStg;

    }
     @IsTest
    private static  void createBK() {
        try{
            new AXScourierStatus.AXScourierSTA();
            AXScourierStatus.AXScourierSTAResponse resp = new AXScourierStatus.AXScourierSTAResponse();
            resp.awb=resp.awb;
              String AXScourierSTA = '{"settings":[{"type":"3", "srNo":"23184320160430", "awbNo":"1604158387740", "fromStatus":"Alloted", "toStatus":"Delivered", "updateTimeStamp":"08/03/2016 12:33:00 PM", "updateReason":""}]}';

           AXScourierStatus.updateCourierStatus(AXScourierSTA, '10:10', 'AXSEMPOST');
            AXScourierStatus.getAWBDetailsByDate(string.valueOf(Date.today()) );
                  }catch (Exception e) {}
    }

}