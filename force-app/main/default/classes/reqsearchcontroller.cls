/**************************************************************************************************
@Version History
* Version       Date            Name                        Description
* 1.0         Orginal          AXS
* 1.1         25-07-2024       Prateek Jangir              Added logic to validate ltc, ltp,dnc document using QR code scan.
* 1.2         23-11-2025       Sorna Mary                  Added logic to validate the QR code for employee visa requests.
**************************************************************************************************/
public class reqsearchcontroller {

    public transient list<g_Req__c> req{get;set;}
    public transient list<g_reqitem__c> reqI{get;set;}
    public transient String pdfConfirm{get;set;}
    public transient String reqIdEn{get;set;}
    public transient Boolean isInvalidDocument{get;set;}
    public transient String validFlag{get;set;}
    public transient String searchstring{get;set;}



    public Boolean codeCheck{get;set;}
    public transient String baseFileData{get;set;}
    public boolean noAtt{get;set;}
    public boolean noSRfg{get;set;}
    public boolean isQrCode{get;set;}
    public boolean isDocumentExpired{get;set;}


    public Boolean isGv{get;set;}

    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';
    private static String secret = Label.CaptchaSecret;

    public static String TestResponse = 'System.HttpResponse[Status=OK, StatusCode=200]';

    public String sitekey {
        get {return Label.CaptchaSitekey;  }
    }
    public String response  {
        get { return String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('g-recaptcha-response')); }
    }

    public reqsearchcontroller ( ) {
        noSRfg=false;
        isDocumentExpired=false;
        isInvalidDocument=false;
        if (Label.CaptchaFlag == 'false')
            codeCheck = true;
    }

   public void searchRI() { string str = searchstring; pdfConfirm = ''; str = str.trim(); String responseBody = makeRequest(baseUrl, 'secret=' + secret + '&response=' + response); String success; set < String > qrCodeServiceCodes = new set < String > { 'ltc', 'ltp', 'dnc', 'gv','001','002','003','004','020','021','040','078' }; /* 1.2 - Added employee visa service codes */ success = 'true'; if (success.equalsIgnoreCase('true')) { string searchquery = 'select id,RQ__c  from g_reqitem__c where  id  =\'' + str + '\'' + ' Limit 1'; reqI = Database.query(searchquery); if (reqI != null && reqI.size() > 0) { string Rqsearchquery='select id,xcped__c,xltr__c,xfpc__c,Name,Full_Name__c,led__c,Account_Name__c,acc__r.lc__c,xlt__c,Letter_dt__c,Service_Code__c,xfpdd__c  from g_Req__c where AP__c>0 and Name  =\''+reqI[0].RQ__c+'\''+' Limit 1'; req= Database.query(Rqsearchquery); List < Attachment > attId = [SELECT id FROM Attachment WHERE ParentID =: reqI[0].Id ORDER BY CreatedDate DESC limit 1]; if (attId != null && attId.size() > 0) { noAtt = false; /*isGv=false;URL.getSalesforceBaseUrl().toExternalForm() +*/ pdfConfirm =  '/apex/filedwnld?id=' + attId[0].id; } else { noAtt = true; } } } else { ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha'); ApexPages.addMessage(errorMsg); } If(req == null) { noSRfg = true; } }

    public void search(){
        string str = searchstring;
        pdfConfirm='';
        str=str.trim();

        String responseBody = makeRequest(baseUrl,'secret=' + secret +'&response='+ response);
        String success;
        set<String> qrCodeServiceCodes = new set<String>{'ltc', 'ltp', 'dnc','gv','001','002','003','004','020','021','040','078'}; //1.2 - Added employee visa service codes
            //ltp,ltn,lts,ltc,204,205,208,dnc
            if (Test.isRunningTest()){
                success='true';

            }else{
                success = getValueFromJson(responseBody, 'success');
            }
        if (Label.CaptchaFlag == 'false')
            success ='true';
        if (success.equalsIgnoreCase('true')){

            string searchquery='select id,xcped__c,xltr__c,xfpc__c,Name,Full_Name__c,led__c,Account_Name__c,acc__r.lc__c,xlt__c,Letter_dt__c,Service_Code__c,xfpdd__c  from g_Req__c where AP__c>0 and Name  =\''+str+'\''+' Limit 1';
            req= Database.query(searchquery);

            if (req!=null && req.size()>0){
                String reqCode = req[0].Service_Code__c;
                if (reqCode=='gv'){ isGv=true;}
                String validateLetterCodes = System.Label.validateLetterCodes;
                if (reqCode!= null && validateLetterCodes.contains(reqCode)){
                    codeCheck=true;
                    if (Test.isRunningTest()){
                        req[0].Letter_dt__c= system.today();
                    }
                    If( req[0].Letter_dt__c!=null || req[0].xfpc__c != null ){
                        DateTime myDateTime = req[0].Letter_dt__c != null ? req[0].Letter_dt__c :  req[0].xfpc__c ;
                        system.debug(myDateTime);
                        DateTime newDateTime;
                        if (req[0].led__c == null){
                            newDateTime = DateTime.newInstance(myDateTime.year(),myDateTime.month()+2,myDateTime.day(),myDateTime.hour(),myDateTime.minute(),myDateTime.second());
                        }else {
                            newDateTime = req[0].led__c ;

                            if ( req[0].xltr__c == 'Permit for Catering Service'){
                                If(req[0].xcped__c!= null){
                                    newDateTime=  req[0].xcped__c;}
                            }
                        }

                        if (qrCodeServiceCodes.contains(req[0].Service_Code__c)){ //1.1
                            // Retrieve the custom label value (it will be a string)
                            String qrCodeCtOffDateStr = Label.Validate_QR_Code_Cut_Off_Date;

                            // Convert the string into a DateTime instance
                            Datetime qrCodeCtOffDate = Datetime.valueOf(qrCodeCtOffDateStr);

                            if (String.isblank(reqIdEn) && myDateTime >= qrCodeCtOffDate ){
                              //  isInvalidDocument = true;
                            }
                            else if (DateTime.Now() < newDateTime){
                                validFlag ='Valid';
                            }
                            else{
                                //validFlag ='Not Valid';
                            }
                        }
                        else{
                            if (DateTime.Now() < newDateTime){
                                validFlag ='Valid';
                            }else{
                                //validFlag ='Not Valid';
                            }
                        }
                    }
                    else{  //1.1
                        isDocumentExpired = true;
                        validFlag ='Not Valid';
                    }
                }else codeCheck=false;

                System.debug('isInvalidDocument :'+isInvalidDocument);
                Date dt = Date.newInstance(2021, 04, 04);
                if (req[0].Service_Code__c == '208' && req[0].xfpdd__c != null && req[0].xfpdd__c >= dt){
                    noAtt=false;
                    //pdfConfirm = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/filedwnld?lc='+req[0].acc__r.lc__c;
                }
                else{
                    List<Attachment> attId = new List<Attachment>();
                    /*1.2 Start*/
                    Set<String> empVisaSrvcCodes = new Set<String> { '001','002','003','004','020','021','040','078' }; /* Added employee visa service codes */
                    if (empVisaSrvcCodes.contains(req[0].Service_Code__c)) {
                        attId = [ SELECT Id, body FROM Attachment WHERE ParentID = :req[0].Id AND Name LIKE '%Offer Letter%' ORDER BY CreatedDate DESC limit 1 ];
                    } else {
                        attId = [SELECT id,body FROM Attachment WHERE ParentID =: req[0].Id ORDER BY CreatedDate DESC limit 1];
                    }
                    /*1.2 End*/
                    if (attId!=null && attId.size()>0){
                        noAtt=false;
                        baseFileData =EncodingUtil.base64Encode(attId[0].body);
                        //System.debug('baseFileData :'+baseFileData);
                        pdfConfirm = '/apex/filedwnld?id='+attId[0].id;
                    } else {
                        noAtt= true;
                    }
                }
            }

        }else{ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha');ApexPages.addMessage(errorMsg);}
        If(req==null ){noSRfg=true;}
    }

    public void clear(){
        if (req!=null && req.size()>0){
            req.clear();
        }
        searchstring='';
        codeCheck=false;
    }


    /**
* Make request to verify captcha
* @return      response message from google
*/
    private static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);

        try {
            Http http = new Http();
            if (Test.isRunningTest()){
                return TestResponse;

            }else{ response = http.send(req); return response.getBody();}
        } catch (System.Exception e) { System.debug('ERROR: ' + e); }return '{"success":false}';
    }

    /**
* to get value of the given json string
* @params
*  - strJson       json string given
*  - field         json key to get the value from
* @return          string value
*/
    public static string getValueFromJson ( String strJson, String field ){ JSONParser parser = JSON.createParser(strJson); while (parser.nextToken() != null) { if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) { if (parser.getText() == field){ parser.nextToken(); return parser.getText(); } } } return null; }

    public void validateQR() {

        String lc = apexpages.currentpage().getparameters().get('i');
        reqIdEn = apexpages.currentpage().getparameters().get('ri'); //1.1
        if (String.isNotBlank(reqIdEn)) {
        reqIdEn = reqIdEn.replaceAll(' ', '+');
    }
        if (lc != null && lc != '') { lc = lc.replace(' ', '+'); lc = gU.DED_Decrypt(lc); List < Account > acc = [select id from account where lc__c =: lc]; if (acc.size() > 0) { isQrCode = false; noAtt = false; /*pdfConfirm = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/filedwnld?lc=' + lc;*/ } }
        if (String.isNotBlank(reqIdEn)){  //1.1
            isQrCode = true;
            if (reqIdEn  != null){
                String reqId = getDecryptedId(reqIdEn,5);
                if (reqId!=null && reqId.contains('-gvsal')){ isGv=true;List<String> ril=reqId.split('-gvsal'); reqId=ril[0]; reqI = [select id,name from g_reqitem__c where id =:reqId ]; if (reqI.size() > 0){ searchstring= reqI[0].id; isDocumentExpired= false; searchRI(); } }
                else if (reqId != null){
                    req = [select id,name,Full_Name__c,Account_Name__c,xlt__c,xfpdd__c from g_req__c where id =:reqId AND Service_Code__c in ('ltc', 'ltp', 'dnc','gv','001','002','003','004','020','021','040','078')]; /* 1.2 - Added employee visa service codes */
                    if (req.size() > 0){
                        searchstring= req[0].Name;
                        isDocumentExpired= false;
                        search();
                    }
                }
            }
        }
    }

    /*************************************************************************************************
* Description       : Method to get decrypted recordid.
* Created Date      : 28-July-2024
* Created By        : Prateek Jangir
**************************************************************************************************/
    public String getDecryptedId(String reqId, Integer decryptNum) {  //1.1
       // String decryptedid =gctlInsHelper.decryptStr(reqId.replace(' ','+'),decryptNum);
        String decryptedid = gctlInsHelper.decryptStr(reqId.replaceAll(' ','+'), decryptNum);
        return decryptedid;
    }
}