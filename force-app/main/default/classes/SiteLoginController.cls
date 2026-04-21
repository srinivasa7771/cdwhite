/**
 * An apex page controller that exposes the site login functionality
 */
global class SiteLoginController {
    global String username {
        get;
        set;
    }
    global String password {
        get;
        set;
    }
    global String cPassword {
        get;
        set;
    }
    global String otp {
        get;
        set;
    }
    global String otpfrmPg {
        get;
        set;
    }
    public String pk {
        get;
        set;
    }
    public Boolean invalidPK {
        get;
        set;
    }
    public Boolean showUsereg {
        get;
        set;
    }
    public Boolean invalidEmail {
        get;
        set;
    }
    public String suggestedUN {
        get;
        set;
    }
    public String rqId {
        get;
        set;
    }
    global String mobNum {
        get;
        set;
    }
    global String cCode {
        get;
        set;
    }
    public Boolean inValidOtp {
        get;
        set;
    }
    public String otpValMsg {
        get;
        set;
    }
    public Integer otpTime {
        get;
        set;
    }
    public Integer otpMaxAtt {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }

    /* for custom Captcha starts */
    public Boolean enableCaptcha {
        get;
        set;
    }
    public Integer firstNum {
        get;
        set;
    }
    public Integer secondNum {
        get;
        set;
    }
    public Integer thirdNum {
        get;
        set;
    }
    public Integer captchaResult {
        get;
        set;
    }
    public String captchaResult_page {
        get;
        set;
    }
    public String captchaOperator {
        get;
        set;
    }
    public Map < String, String > captchaOperatorMap {
        get;
        set;
    }
    public String captchaResponse {
        get;
        set;
    }
    user extUser;
    /* for custom Captcha end */

    global SiteLoginController() {
        captchaOperatorMap = new Map < String, String > ();
        captchaOperatorMap.put('add', '+');
        captchaOperatorMap.put('sub', '-');
        captchaOperatorMap.put('multi', 'x');
        enableCaptcha = true;
        captchaOperator = 'add';
        firstNum = Integer.valueof(Math.random() * 10);
        secondNum = Integer.valueof(Math.random() * 100);
        thirdNum = Integer.valueof(Math.random() * 1000);
        otpMaxAtt = Integer.valueof(Label.Onboarding_Max_Values.split(';')[0]);
        otpTime = Integer.valueof(Label.Onboarding_Max_Values.split(';')[1]);
        if (captchaOperator == 'add') {
            captchaResult = firstNum + secondNum + thirdNum;
        }
        noSRfg = false;
        invalidPK = false;
        showUsereg = true;
        invalidEmail = false;
        ispu = gU.isPortalUser(UserInfo.getProfileId());
        System.debug('ispu::: ' + ispu);

        String cd = ApexPages.currentPage().getParameters().get('i');
        if (cd == '615bb0562675b0b3f63ed4b3cd4d48276636d889a5c934d508e41010ec596463') {
            pk = 'dic';
        } else if (cd == '8c50131fe08db465c3e95ce8c3bba36ae5660c9be5b373720dadc070dfb398eb') {
            pk = 'dmc';
        } else if (cd == 'ec5d207d673d66fd16bf1aa39e342c3395900b3792d3bbd8a1b4f1d9404b398e') {
            pk = 'ddd';
        } else if (cd == 'f3b4b2a9cd9208947015a6944bf5b4b05a83854630fd091c7350edcdd60cafb1') {
            pk = 'dia';
        } else if (cd == '09941c5801db3c4485bf94f462f32a7af220c84af3de671e5e8013458abfc08e') {
            pk = 'dic2';
        } else if (cd == '85868e7bfad993c2fffc6600e7363ce1d59f36f2a82c494a3d62a5a20995c047') {
            pk = 'doc';
        } else if (cd == 'bed127861dfc5261737dd1bf0addacd0b5bd8145ea2ebfa3493357db7b2c4cea') {
            pk = 'dpc';
        } else if (cd == '4cf3881e765cc0d28f380170508ebad5278c0b1e020f29f2f40b8f039924cb47') {
            pk = 'dkp';
        } else if (cd == '3820a182b22be0a80521fe9f59d31f69dade5fe946190a1377056d2c807b3a8e') {
            pk = 'dsc';
        } else if (cd == '3c2d11dfcd20823958175ff28f647ea199daa7479d139a51831fc8bdf2722260') {
            pk = 'dsp';
        } else if (cd == '141817be7585b1bed4595b517918fdcae2eddafaf6bebcd1dbcc0d9b32fb553b') {
            pk = 'in5';
        } else {
            pk = '';
            invalidPK = true;
        }


        rqId = ApexPages.CurrentPage().getParameters().get('id');
        system.debug('rqId::' + rqId);
        if (String.isNotBlank(rqId)) {
            validateRequest();
        } else {
            showUsereg = false;
        }

    }
    global PageReference checkValidEmail() {
        rqId = ApexPages.CurrentPage().getParameters().get('id');
        /* if(String.isNotBlank(rqId)){
List<g_req__c> rqLst = [Select id, name, sta__c, acc__r.id,xceml__c,xcmob__c,ldmob__c,xui__c,os__c FROM g_req__c where id=:rqID and srvc__r.uid__c in ('322','216')];
if(rqLst[0].xceml__c!=null && rqLst[0].xceml__c.split('@').size()>0 ){
String emailDom =  rqLst[0].xceml__c.split('@')[1];
system.debug('emailDom -- '+emailDom);
if(Label.inValidEmails.contains(emailDom)||Label.inValidEmails1.contains(emailDom)||Label.inValidEmails2.contains(emailDom)||Label.inValidEmails3.contains(emailDom)){
invalidEmail = true;
PageReference p = new PageReference('/Maintenance');
p.setRedirect(true);
return p;
}
}

}*/
        return null;
    }

    global PageReference login() {
        if (extUser != null) {
            system.setpassword(extUser.id, password);
        }
        String startUrl = extUser != null ? '/apex/lerqob?id=' + rqId : '/apex/gpm'; /*String startUrl = System.currentPageReference().getParameters().get('startURL');*/
        return Site.login(username, password, startUrl);
    }

    global Pagereference createData() {
        otpValMsg = '';
        System.debug(' reqId :: ' + rqId + '  username ::' + username + '  pswd::' + password);
        g_req__c req1 = [SELECT id, name, mtnm__c, sta__c, xfb__c, acc__c, xcslt__c, xcfn__c, xcln__c, xceml__c, xcmob__c, xaccbrand__c, xchph__c, xcnc__c, xcp__c, ccrmldid__c, os__c, parCat__c, xvtyp__c from g_req__c where id =: rqId]; /*'a0E1s0000000JSKEA2'*/ /*MS 1.1*/
        String otpVal = '';
        if (Label.Onboarding_OTP != 'NA') {
            if (Label.Onboarding_OTP == otpfrmPg) otpVal = 'verified';
            else otpVal = validateOtp();
        } else otpVal = validateOtp(); /*if(Label.Onboarding_OTP != 'NA' && Label.Onboarding_OTP == otpfrmPg) otpVal = 'verified';*/ /*String otpVal = validateOtp(); */
        System.debug('otpfrmPg:: ' + otpfrmPg + '  ::otpVal : ' + otpVal);
        if (String.isBlank(otpVal) || !otpVal.equalsIgnoreCase('verified')) {
            System.debug('OTP VALIDATION FAILED');
            otpValMsg = 'Entered OTP is invalid, please re-generate the OTP';
            inValidOtp = true;
            return null;
        }
        Savepoint sp = Database.setSavepoint();
        try {
            new obFreelancer().createAccount(req1, username, password);
            req1.acc__c = obFreelancer.newAccID;
            req1.os__c = 'Lead qualified';
            update req1;
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            Database.rollback(sp);
            otpValMsg = 'We are unable to process this request at the moment, please contact 800 4 axs (297)'; /* + '<loginUsr - update request>EX:: ' + e.getMessage() + '  Error getStackTraceString:' + e.getStackTraceString();*/
            System.debug('<loginUsr - update request>EX:: ' + e.getMessage() + '  Error getStackTraceString:' + e.getStackTraceString());
            return null;
        } /*invoke ccrm webservice to autoconvert the lead*/
        if (String.isBlank(req1.mtnm__c) || req1.mtnm__c != 'Existing') {
            grqWsOnboard.autoQualifyLead(req1.ccrmldid__c); /*auto login the portal user*/
        }
        system.debug('username=====' + username);
        system.debug('username=====' + password);
        PageReference loginRes = Site.login(username, password, '/gpm');
        system.debug('ref2::' + loginRes.getUrl());
        return loginRes;
    }

    global void validateRequest() {
        system.debug('validateRequest::');
        List < g_req__c > rqLst = [Select id, mtnm__c, acc__c, name, sta__c, acc__r.id, xceml__c, xcmob__c, ldmob__c, xui__c, os__c FROM g_req__c where id =: rqID and srvc__r.uid__c in ('322', '216')];
        system.debug('validateRequest1::');
        if (rqLst == null || rqLst.size() == 0) {
            showUsereg = false;
            return;
        }

        cCode = rqLst[0].xui__c;
        mobNum = rqLst[0].ldmob__c;
        system.debug('cd1::' + rqLst[0].xui__c);
        /* generate dynamic user name and check the existance*/
        extUser = checkExtUser(rqLst[0]);
        username = extUser != null ? extUser.username : AxsMethods.getUsername(rqLst[0].xceml__c);
        if (rqLst[0].os__c != 'Lead generated') {
            showUsereg = false;
            return;
        }
        system.debug('cd::' + rqLst[0].xui__c);
        system.debug('Mobile::' + mobNum);
        system.debug('email::' + rqLst[0].xceml__c);
    }

    global user checkExtUser(g_req__c rq) {
        list < User > lstuser = new list < User > ();
        if (rq.mtnm__c == 'Existing') {
            list < Contact > lstContact = [Select id from Contact where accountId =: rq.acc__c and email =: rq.xceml__c];
            if (!lstContact.isEmpty()) {
                lstUser = [Select Id, username from user where contactId IN: lstContact and isActive = true];
            }
        }
        if (!lstuser.isEmpty()) {
            return lstUser[0];
        }
        return null;
    }

    // OTP variables and functions
    public String otpResult {
        get;
        set;
    }
    public String otpReqId {
        get;
        set;
    }
    public Integer otpAttempt {
        get;
        set;
    }

    //public void generateOtp(){ try{ system.debug('rqID::'+rqID); List<g_req__c> rq = [select id, name,xawh__c from g_req__c where id=:rqId]; List<ws_call__c> wslist = [select id from ws_call__c  where xrno__c=:rq[0].Name]; if(wslist!=null && wslist.size()<=Integer.valueof(Label.Onboarding_Max_Values)){ otpReqId = SMSService.sendOtp(mobNum,rqId); otpResult=''; otpValMsg=''; system.debug('otpReqId -- '+otpReqId); }else{ otpValMsg = 'You have used the maximum number of attempts for OTP generation. Please contact 800 4 AXS (297).'; } if(String.isNotBlank(otpReqId) && otpReqId.startsWith('ERROR') &&  otpReqId.contains('is invalid')){ otpValMsg = 'Mobile number is invalid, please contact 800 4 axs (297)'; } }catch(Exception e){ otpValMsg = 'Error while sending the OTP, please try after sometime'; System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString()); } }

    //public void generateOtp() { try { system.debug('rqID::' + rqID); List < g_req__c > rq = [select id, name, xawh__c from g_req__c where id = : rqId]; List < ws_call__c > wslist = [select id from ws_call__c where xrno__c = : rq[0].Name]; if(wslist != null && wslist.size() < otpMaxAtt) { otpReqId = SMSService.sendOtp(mobNum, rqId); otpResult = ''; otpValMsg = ''; system.debug('otpReqId -- ' + otpReqId); } else { otpValMsg = 'You have used the maximum number of attempts for OTP generation. Please contact 800 4 AXS (297).'; } if(String.isNotBlank(otpReqId) && otpReqId.startsWith('ERROR') && otpReqId.contains('is invalid')) { otpValMsg = 'Mobile number is invalid, please contact 800 4 axs (297)'; } } catch(Exception e) { otpValMsg = 'Error while sending the OTP, please try after sometime'; System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString()); } }
    public void generateOtp() {
        try {
            system.debug('rqID::' + rqID);
            List < g_req__c > rq = [select id, name, xawh__c, resetOTP__c from g_req__c where id =: rqId];
            List < ws_call__c > wslist = [select id from ws_call__c where xrno__c =: rq[0].Name and mtd_nm__c = 'OTP'];
            otpMaxAtt = (rq.size() > 0 && rq[0].resetOTP__c == true) ? otpMaxAtt + 5 : otpMaxAtt;
            if (wslist != null && wslist.size() < otpMaxAtt) {
                otpReqId = SMSService.sendOtp(mobNum, rqId);
                otpResult = '';
                otpValMsg = '';
                system.debug('otpReqId -- ' + otpReqId);
            } else {
                otpValMsg = 'You have used the maximum number of attempts for OTP generation. Please contact 800 4 AXS (297).';
            }
            if (String.isNotBlank(otpReqId) && otpReqId.startsWith('ERROR') && otpReqId.contains('is invalid')) {
                otpValMsg = 'Mobile number is invalid, please contact 800 4 axs (297)';
            }
        } catch (Exception e) {
            otpValMsg = 'Error while sending the OTP, please try after sometime';
            System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString());
        }
    }
    public String validateOtp() {
        try {
            system.debug('otpReqId -- ' + otpReqId + ' && otpfrmPg -- ' + otpfrmPg);
            otpResult = SMSService.otpValidate(otpReqId, otpfrmPg);
        } catch (Exception e) {
            gU.AddErrorMsg('OTP validation failed, regenerate the OTP and verify.');
            System.debug('EX::: ' + e.getMessage() + ' stack: ' + e.getStackTraceString());
            return null;
        }
        System.debug('otpResult ' + otpResult);
        return otpResult;
    }


    /*Code for check status block starts */

    public list < g_itmHistorySTA__c > hist {
        get;
        set;
    }
    public string searchstring {
        get;
        set;
    }
    public string actMsg {
        set;
        get;
    }
    public Boolean codeCheck {
        get;
        set;
    }
    public boolean noSRfg {
        get;
        set;
    }

    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';
    //private static String secret = '6LcCUEEUAAAAANjzDnlRyDT8n_U-c2TwBNJHbbdH';
    private static String secret = Label.CaptchaSecret;
    //'6LeSuTYUAAAAAC-ANDQ7_ZjSTeUBUPj2jEEI9T0h';

    public static String TestResponse = 'System.HttpResponse[Status=OK, StatusCode=200]';

    public String sitekey {
        get {
            return Label.CaptchaSitekey;
        }
    }
    public String response {
        // get{ return 'true';}
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }

    public pageReference search() {
        System.debug('<search starts>');
        string str = searchstring;
        pageReference ref = null;
        System.debug('<search str> ' + str);
        str = str.trim();

        String responseBody = makeRequest(baseUrl, 'secret=' + secret + '&response=' + response);
        String success;
        if (Test.isRunningTest()) {
            success = 'true';

        } else {
            success = getValueFromJson(responseBody, 'success');
            system.debug('success-- ' + success);
        }
        if (Label.CaptchaFlag == 'false')
            success = 'true';
        if (success.equalsIgnoreCase('true')) {
            System.debug('<search str - 75> ' + str);
            List < g_req__c > rqLst = [select id, name from g_req__c where(name =: str or con__r.p__c =: str) and Acc__r.Name != 'test identity 1'
                and createddate = last_n_days: 365 order by createddate desc limit 1
            ];
            system.debug('rqlst -- ' + rqLst);
            if (rqLst != null && !rqLst.isEmpty()) {
                ref = new PageReference('/apex/statusinfo?id=' + rqLst[0].id);
            } else {
                noSRfg = true;
            }
        } else {
            system.debug('captcha issue ');
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha');
            ApexPages.addMessage(errorMsg);
        }
        return ref;
    }

    public void clear() {
        if (hist != null && hist.size() > 0) {
            hist.clear();
        }
        searchstring = '';
        noSRfg = false;
    }


    @RemoteAction
    global static Boolean isUsernameAvailable(String uName) {
        System.debug('uName ::' + uName);
        List < User > lstUser = [Select id, name from User where username =: uName];
        if (lstUser != null && lstUser.size() > 0) {
            return false;
        }
        return true;
    }


    /**
     * Make request to verify captcha
     * @return      response message from google
     */
    private static String makeRequest(string url, string body) {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(body);

        try {
            Http http = new Http();
            if (Test.isRunningTest()) {
                return TestResponse;

            } else {
                response = http.send(req);
                return response.getBody();
            }
        } catch (System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return '{"success":false}';
    }

    /**
     * to get value of the given json string
     * @params      
     *  - strJson       json string given
     *  - field         json key to get the value from
     * @return          string value
     */
    public static string getValueFromJson(String strJson, String field) {
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                if (parser.getText() == field) {
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return null;
    }


}