/**
 * An apex page controller that exposes the site login functionality MS
 */
@isTest(SeeAllData=true)
global with sharing class SiteLoginControllerTest {
    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';

        System.assertEquals(controller.login(), null);
    }
    static testMethod void doTest() {
        SiteLoginController reqS = new SiteLoginController();

        reqS.mobNum=reqS.mobNum;
        reqS.cCode=reqS.cCode;
        reqS.captchaResult_page=reqS.captchaResult_page;
        reqS.captchaResponse=reqS.captchaResponse;

        reqS.username=reqS.username;
        reqS.password=reqS.password;
        reqS.checkValidEmail();
        reqS.cPassword=reqS.cPassword;
        reqS.otp=reqS.otp;
        reqS.otpfrmPg=reqS.otpfrmPg;
        reqS.suggestedUN=reqS.suggestedUN;
        reqS.inValidOtp=reqS.inValidOtp;

         reqS.otpResult=reqS.otpResult;
         reqS.otpReqId=reqS.otpReqId;
         reqS.otpAttempt=reqS.otpAttempt;
        reqS.actMsg=reqS.actMsg;

            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

        //List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c='ltp' limit 1 ];
        reqS.searchstring=r.Name;
        reqS.search();
        reqS.clear();
        reqS.validateRequest();
        reqS.generateOtp();
        reqS.otpReqId='ERROR is invalid';
        reqS.generateOtp();
        reqS.validateOtp();
       reqS.codeCheck=false;
        reqS.search();
        reqS.clear();

    }

   /* static testMethod void doTestFalse() {
        g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
        SiteLoginController reqS = new SiteLoginController();
        //List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c=:'ltn' limit 1 ];
        reqS.searchstring=r.Name;

        reqS.codeCheck=false;
        reqS.search();
        reqS.clear();

    }*/
}