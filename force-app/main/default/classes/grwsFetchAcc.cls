@RestResource(urlMapping='/getaccinfo/*')
global class grwsFetchAcc {

@HttpGet
    global static void getAccInfo() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('Content-Type', 'application/json');
        //String resp = '{"Accounts":[{"AccountName":"Test identity 01", "LicenseNo":"93408", "LicenseStatus":"License Issued", "LicenseIssueDate":"25/02/2019", "LicenseExpDate":"24/02/2020"}, {"AccountName":"Test identity 02", "LicenseNo":"93509", "LicenseStatus":"License Issued", "LicenseIssueDate":"20/01/2019", "LicenseExpDate":"19/01/2020"}]}';
        try{
             String accid = req.params.get('accid');
            if (accid != null && string.isNotBlank(accid)) {
               List<Account> accLst = [select id, name, lc__c, lcsta__c, lcidt__c, lcedt__c from Account where id=:accid and Legal_Framework__c='Freelancer'];
                if (accLst != null && !accLst.isEmpty()) {
                    accInfo acc = new accInfo();
                    acc.AccountName = accLst[0].name;
                    acc.LicenseNo = accLst[0].lc__c;
                    acc.LicenseStatus = accLst[0].lcsta__c;
                    acc.LicenseIssueDate =formatDate(accLst[0].lcidt__c);
                    acc.LicenseExpDate =formatDate(accLst[0].lcedt__c);
                    string accres = Json.serialize(acc);
                    res.responseBody = Blob.valueOf(accres);
                }
                else
                {
                    res.responseBody = Blob.valueOf('');
                }
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
    global class accInfo {webService String AccountName, LicenseNo, LicenseStatus, LicenseIssueDate, LicenseExpDate;}
    global class accReq  {webService String accId;}
}