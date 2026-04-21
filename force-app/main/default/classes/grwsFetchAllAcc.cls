@RestResource(urlMapping='/getAllaccinfo/*')
global class grwsFetchAllAcc {

    @HttpPost
    global static void getAccInfo() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('Content-Type', 'application/json');
        //String resp = '{"Accounts":[{"AccountName":"Test identity 01", "LicenseNo":"93408", "LicenseStatus":"License Issued", "LicenseIssueDate":"25/02/2019", "LicenseExpDate":"24/02/2020"}, {"AccountName":"Test identity 02", "LicenseNo":"93509", "LicenseStatus":"License Issued", "LicenseIssueDate":"20/01/2019", "LicenseExpDate":"19/01/2020"}]}';
        try{
              // String accid = req.params.get('category');
               //String pid = req.params.get('pid');
             String reqBody = RestContext.request.requestBody.toString();
                System.debug('reqBody: ' + reqBody);
            accReq rqData = (accReq) JSON.deserialize(reqBody, accReq.class);
               List<accInfo> aList =new List<accInfo>();
               List<servReq> rList =new List<servReq>();
              List<rQdocs> dList =new List<rQdocs>();

               List<Account> accLst = [select id, name, lc__c, ORACLE_PARTY_ID__c, lcsta__c, lcidt__c,
                   lcedt__c, vespe__c, vespex__c, vctemp__c from Account where isDeleted=false and  Type!='Customer-DED' and ORACLE_PARTY_ID__c=:rqData.partyId];
               List<g_Req__c> reqLst = [select id, name, xcamdt__c, xcamc__c,
                   (select id, name from rdocs__r where req__c=true and isdeleted=false ) from g_Req__c where isDeleted=false  and srvc__r.uid__c='220' and sta__c in ('Draft',
                   'Open', 'Under Review', 'In Process') and Acc__r.ORACLE_PARTY_ID__c=:rqData.partyId];
               List<g_reqDoc__c> rqDocs= new List<g_reqDoc__c>();

            if (accLst != null && !accLst.isEmpty()) {
                    for (g_Req__c r:reqLst) {
                         servReq rq=new servReq();
                        dList =new List<rQdocs>();
                         rq.reqNo=r.Name;
                         rq.amdType=r.xcamdt__c;
                         rq.amdCat=r.xcamc__c;
                         rqDocs=r.rdocs__r;
                         for (g_reqDoc__c rd:rqDocs) {
                            rQdocs d= new rQdocs();
                            d.name=rd.name; d.id=rd.id;
                            dList.add(d);
                         }
                        rq.docList=dList;
                        rList.add(rq);

                        }
                    for (Account a:accLst) {
                    accInfo acc = new accInfo();
                    acc.AccountName = accLst[0].name;
                    acc.oraPartyId=accLst[0].ORACLE_PARTY_ID__c;
                    acc.LicenseNo = accLst[0].lc__c;
                    acc.LicenseStatus = accLst[0].lcsta__c;
                    acc.LicenseIssueDate =formatDate(accLst[0].lcidt__c);
                    acc.LicenseExpDate =formatDate(accLst[0].lcedt__c);
                    acc.VisaEligibility =accLst[0].vespe__c;
                    acc.AddOnVisa= accLst[0].vespex__c;
                    acc.ConsumedVisa= accLst[0].vctemp__c;
                    acc.serReqLst=rList;
                    aList.add(acc);
                    }

                    string accres = Json.serialize(aList);
                    system.debug(accres);
                    res.responseBody = Blob.valueOf(accres);
                }
                else
                {
                    res.responseBody = Blob.valueOf('');
                }

        }
        catch (Exception ex) {
             res.responseBody = Blob.valueOf('');
        }

    }
   public static String formatDate(Date input) {
    Datetime output = Datetime.newInstanceGmt(input, Time.newInstance(0, 0, 0, 0));
     return output.format('yyyy/MM/dd');
}
    global class accInfo {webService String AccountName, LicenseNo, oraPartyId, LicenseStatus, LicenseIssueDate, LicenseExpDate;
                          webService Decimal  VisaEligibility, AddOnVisa, ConsumedVisa;
                          webservice list<servReq> serReqLst;
                         }
    global class servReq  {webService String reqNo;webService String  amdType;webService String  amdCat;webservice list<rQdocs> docList;}
    global class rQdocs  {webService String Name;webService String  id;}
    global class accReq  {webService String partyId;}
}