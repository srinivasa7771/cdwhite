global class AXScourierStatus {
    global class AXScourierSTA {string srNo, awbNo, fromStatus, toStatus, updateReason, updateTimeStamp, type, recvName;}
    //webservice callout method for courier status update
    webService static AXScourierSTAResponse updateCourierStatus(String AXScourierSTA, string timeStamp, string hashCode) {
        System.debug('--AXScourierSTA-- : ' +AXScourierSTA);
        System.debug('--timeStamp-- : ' +timeStamp);
        System.debug('--hashCode-- : ' +hashCode);
        //  AXScourierSTA = '{"settings":[{"type":"3", "srNo":"23058420160221", "awbNo":"1606006172098", "fromStatus":"At Dispatcher", "toStatus":"Alloted", "updateTimeStamp":"3/08/2016 0:00", "updateReason":""}]}';

        AXScourierSTAResponse response=new AXScourierSTAResponse();
        Boolean flg=false;
        String[] key = gU.csStr('Courier_login').split(', ');
        String axshashcode=gU.DEG_Encrypt(timeStamp+key[2]);
        // if (axshashcode.toUpperCase()==hashcode.toUpperCase())
        if (true) {
            List<UpdateRequestItemStatus.empostResp> lstEmpResp;
            UpdateRequestItemStatus courierUp = new UpdateRequestItemStatus();
            try {
                lstEmpResp = courierUp.respParser(AXScourierSTA);
                courierUp.json=AXScourierSTA;
                courierUp.lstEmpResp = lstEmpResp;
                courierUp.UpdateStatusMethod();
                response.error_code='0';
                response.status='Success';
            }
            catch (JSONException je) {
                response.error_code='1';
                response.status='Invalid JSON String';
                system.debug(je.getMessage());
            }
            catch (Exception e) {
                response.error_code='1';
                response.status='#Error : ' + e.getMessage() + ' #Line Number : ' +e.getLineNumber();
                system.debug(e.getMessage());
                cuerrlg__c errLog=new cuerrlg__c();
                errLog.rq__c='0';
                errLog.cuexp__c=e.getMessage();
                errLog.errTyp__c='Update';
                errLog.cxml__c=AXScourierSTA;
                if (Schema.sObjectType.cuerrlg__c.isCreateable()) {
                    insert errLog;
                }
            }
            }
            else{
                response.error_code='1';
                response.status='hashcode validation failed';
            }
        return response;
    }

         webService static String getAWBDetailsByDate(string  createDate) {
         System.debug('--getAWBDetailsByDate-- : ' +createDate);
     UpdateRequestItemStatus u=new UpdateRequestItemStatus();

     //String  responseString ='{"settings":[{"awbNo":"1606006172098", "Status":"At Dispatcher", "updateTimeStamp":"04/01/2017 16:40"}, {"awbNo":"1606006172091", "Status":"Alloted", "updateTimeStamp":"04/01/2017 16:40"}, {"awbNo":"1606006172093", "Status":"At Hub", "updateTimeStamp":"04/01/2017 16:40"}]}';
     String  responseString=u.getAWBDetailsByDate(createDate);
        return responseString;

    }

    global class AXScourierSTAResponse {webService string[] awb;webService string error_code, status;}
}