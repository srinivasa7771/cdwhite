@RestResource(urlMapping='/updateaccinfo')
global class grwsUpdateAcc {
  @HttpPost
    global static void updateAccInfo() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('Content-Type', 'application/json');
         accInfo rqData = new  accInfo();
        //String resp = '{"Accounts":[{"AccountName":"Test identity 01", "LicenseNo":"93408", "LicenseStatus":"License Issued", "LicenseIssueDate":"25/02/2019", "LicenseExpDate":"24/02/2020"}, {"AccountName":"Test identity 02", "LicenseNo":"93509", "LicenseStatus":"License Issued", "LicenseIssueDate":"20/01/2019", "LicenseExpDate":"19/01/2020"}]}';
        try{
              // String accid = req.params.get('category');
               //String pid = req.params.get('pid');
             String reqBody = RestContext.request.requestBody.toString();
                System.debug('reqBody: ' + reqBody);
             rqData = (accInfo) JSON.deserialize(reqBody, accInfo.class);

               List<Account> accLst = [select id, name, lc__c, ORACLE_PARTY_ID__c, vespex__c from Account where isDeleted=false and  Type!='Customer-DED' and ORACLE_PARTY_ID__c=:rqData.partyId];
                if (accLst != null && !accLst.isEmpty() && rqData.AddOnVisa != null) {
                    accLst[0].vespex__c = rqData.AddOnVisa;
                    if (Schema.sObjectType.Account.isUpdateable()) {
                        update accLst;
                    }
                    rqData.isSuccess = true;
                    rqData.respMsg = 'Success';

                }
                else
                {
                    rqData.isSuccess = false;
                    rqData.respMsg = 'Account details not exist';
                }

        }
        catch (Exception ex) {
             rqData.isSuccess = false;
             rqData.respMsg = 'Exception:'+ex.getMessage();
        }
       string accres = Json.serialize(rqData);
                    system.debug(accres);
                    res.responseBody = Blob.valueOf(accres);

    }
  global class accInfo {webService String partyId, respMsg;
                          webService integer  AddOnVisa;
                          webService boolean  isSuccess;
                         }
}