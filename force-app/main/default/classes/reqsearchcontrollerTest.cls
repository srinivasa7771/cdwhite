@isTest(SeeAllData=true)
public class reqsearchcontrollerTest {
    static testMethod void doTest() {
        reqsearchcontroller reqS = new reqsearchcontroller();
        List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c=:'ltp' limit 1 ];
        reqS.searchstring=reqList[0].Name;

        Attachment attach=new Attachment();
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=reqList[0].id;
        insert attach;

        reqS.search();
        reqS.clear();

    }

    static testMethod void doTestFalse() {
        reqsearchcontroller reqS = new reqsearchcontroller();
        List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c=:'ltn' limit 1 ];
        reqS.searchstring=reqList[0].Name;
        reqS.validFlag='false';
        reqS.codeCheck=false;
        reqS.search();
        reqS.clear();

    }

    static testMethod void validateQACodeTest() {
        reqsearchcontroller reqS = new reqsearchcontroller();
        //testData.accCrt(false);
                User adminU = [Select Id, Name from User where Name = 'System Admin'
            LIMIT 1
        ];
        Account a = new Account(name = 'Acc', Type = 'Customer - External', Prk__c = 'Dubai Internet City', mxPortalUsers__c = 1, stapsa__c = 'Signed', ec__c = '123',
                                ecidt__c = date.today(), ecedt__c = date.today().addYears(1), coidt__c = date.today(),
                                coadt__c = date.today(), lc__c = '1', lcidt1__c = date.today(), lcidt__c = date.today(), lcedt__c = date.today().addYears(1),
                                lcsta__c ='License Issued', lctp__c = 'Commercial License', adob__c = 0, van__c = '12345', adx__c = 10000,
                                bg__c = 125000, vespe__c = 100, vespex__c = 10, vcspe__c = 110, speabsc__c = 0, vcac__c = 0, veac__c = 0, veacx__c = 0,
                                vcid__c = 0, veid__c = 0, veidx__c = 0, vespst__c = 0, vespstx__c = 0, vcnspst__c = 0, venspst__c = 0, venspstx__c = 0,
                                ORACLE_PARTY_ID__c = '32023', Owner = adminU);
        insert a;
        Map<String, String> parameters = new Map<String, String>{
                'ri' => '03VZPWpng26yOVFLt2EjdrBc9Rj8nOLRVGs3wfHXMuE='
                };

        // Set the parameters on the current page
        ApexPages.currentPage().getParameters().putAll(parameters);
        reqS.validateQR();
    }
}