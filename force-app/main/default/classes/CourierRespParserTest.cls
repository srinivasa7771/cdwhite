@isTest
private class CourierRespParserTest  {
 private static testMethod void coverTypes() {
        new CourierRespParser();
    }

     @IsTest
    private static  void respParserTest() {

        CourierRespParser cls = new CourierRespParser();
         String AXScourierSTA = '{"settings":[{"type":"3", "srNo":"23184320160430", "awbNo":"1604158387740", "fromStatus":"Alloted", "toStatus":"Delivered", "updateTimeStamp":"08/03/2016 12:33:00 PM", "updateReason":""}]}';

            try{
            cls.respParser(AXScourierSTA);
        }catch (Exception e) {e.getStackTraceString();}

    }

}