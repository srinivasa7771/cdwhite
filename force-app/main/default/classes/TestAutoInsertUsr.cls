@isTest
global class TestAutoInsertUsr {

    @isTest static void testScheduleIt() {

        Account acc = new Account(Name='Test Account_LDD', lc__c='31359', ORACLE_PARTY_ID__c = '29258');insert acc;
        acc_sharehd__c accsh = new acc_sharehd__c(accsh__c = acc.id, fname__c='test_GM',
                                                  lname__c='test_lm', Email__c='test243546@gmail.com' ,
                                                 crole__c = 'General Manager');
        insert accsh;
        gStg__c gpSU = new gStg__c(name='gpSU', Text_Value__c = '00e20000001AjBw');
        insert gpSU;

        List<Account> lstAcc = new List<Account>();
        lstAcc.add(acc);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetMngrInc());
        AutoInsertUsr_schdl.scheduleIt('testCreate');
        Test.stopTest();
    }

    @isTest static void testScheduleIt2() {

        Account acc = new Account(Name='Test Account_LDD', lc__c='31359', ORACLE_PARTY_ID__c = '29258');insert acc;
        List<Account> accList = [SELECT id, name, lc__c from Account where lc__c='31359' ];
        ws_call__c wsCall = new ws_call__c(rq_jsn__c=accList[0].lc__c, pmid__c= accList[0].Id, intsts__c = 'Ready for Integration', ws_typ__c = 'UserCreation');
        insert wsCall;

        gStg__c gpSU = new gStg__c(name='gpSU', Text_Value__c = '00e20000001AjBw');
        insert gpSU;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GetMngrInc());
        WsCAll_InsertUsr_scdl.scheduleIt('testCreate2');
        Test.stopTest();
    }

    global class GetMngrInc implements HTTPCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/JSON');
            res.setBody('[{"accLicNo":"33333", "salutation":"Mr.", "firstName":"Super33", "lastName":"axs333", "mobile":"050001111", "email":"sacx.h@tecomgroup.ae", "passportNo":"Test123", "nationality":"Tunisia"}]');
            res.setStatusCode(200);
            return res;
        }
    }
}