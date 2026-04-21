@isTest
private class UpdateRequestItemStatusTest {
    private static testMethod void UpdateStatusMethodTest() {
      UpdateRequestItemStatus courierUp = new UpdateRequestItemStatus();
               try
               {
                   UpdateRequestItemStatus.empostResp x=new UpdateRequestItemStatus.empostResp ();
                   courierUp.settings=courierUp.settings;
                   courierUp.courRplst = courierUp.courRplst;
                   courierUp.returnawbNo=courierUp.returnawbNo;
                   x.srNo=x.srNo;
                   x.awbNo=x.awbNo;x.fromStatus=x.fromStatus;x.toStatus=x.toStatus;x.updateReason=x.updateReason;x.updateTimeStamp=x.updateTimeStamp;
                   x.type=x.type;x.recvName=x.recvName;

               }catch (Exception e) {}

    }

      @IsTest
    private static  void UpdateStatusTest() {
        String AXScourierSTA = '{"settings":[{"type":"3", "srNo":"23184320160430", "awbNo":"1604158387740", "fromStatus":"Alloted", "toStatus":"Delivered", "updateTimeStamp":"08/03/2016 12:33:00 PM", "updateReason":""}]}';
        UpdateRequestItemStatus courierUp = new UpdateRequestItemStatus();
        try
        {
        system.debug('at @@@@@@@@@@@@@@@@@@@@@@@@@6661116');
        List<UpdateRequestItemStatus.empostResp> lstEmpResp = courierUp.respParser(AXScourierSTA);

        system.debug('at @@@@@@@@@@@@@@@@@@@@@@@@@6666');
        courierUp.lstEmpResp = lstEmpResp;
        courierUp.UpdateStatusMethod();
        }
        catch (JSONException je) {system.debug(je.getMessage());}
        catch (Exception e) {
        system.debug(e.getMessage());
        }

    }
     @IsTest
    private static  void respParserTest() {
         String AXScourierSTA = '{"settings":[{"type":"3", "srNo":"23186320160501", "awbNo":"1604158387792", "fromStatus":"Alloted", "toStatus":"Delivered", "updateTimeStamp":"08/03/2016 12:33:00 PM", "updateReason":""}]}';
        UpdateRequestItemStatus courierUp = new UpdateRequestItemStatus();
        try
        {
        List<UpdateRequestItemStatus.empostResp> lstEmpResp = courierUp.respParser(AXScourierSTA);
        }catch (JSONException je) {system.debug(je.getMessage());}
        catch (Exception e) {
        system.debug(e.getMessage());
        }
    }

      @IsTest
    private static  void UpskipTestcasetest1() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   String x= cs.UpskipTestcase(2);
                  system.assertEquals('3', x);
    }Catch(Exception e) {}
    }
    @IsTest
    private static  void upTestCaseTest() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   String x= cs.UPTestCase(2);
                  system.assertEquals('4', x);
    }Catch(Exception e) {}
    }

@IsTest
    private static  void upcaseTestTest() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   String x= cs.UPcaseTest(2);
                  system.assertEquals('5', x);
    }Catch(Exception e) {}
    }

@IsTest
    private static  void upxmlCasetstTest() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   String x= cs.UpxmlCasetst(2);
                  system.assertEquals('6', x);
    }Catch(Exception e) {}
    }

    @IsTest
    private static  void upxmlCasetstTest1() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   String x= cs.UpxmlCasetst1(2);
                  system.assertEquals('6', x);
    }Catch(Exception e) {}
    }

      @IsTest
    private static  void str2DateTest() { try{  UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                   Date x= cs.str2Date('01/01/2017 10:01:0 PM');

    }Catch(Exception e) {}
    }

       @IsTest
    private static  void getAWBDetailsByDateTest() { try{

        UpdateRequestItemStatus cs=new UpdateRequestItemStatus();

                    cs.getAWBDetailsByDate('01/01/2017');

    }Catch(Exception e) {}
    }

}