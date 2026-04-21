@isTest(SeeAllData=false)
public class BatchOnboardMbupdateTest {
@testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c = '322';
        update s;
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        String adhoc = '{"workOrders":[], "status":null, "srtype":"Freelancer", "prmPhone":null, "prmMobile":null, "prmLastName":"Khaja Rafiq", "prmFirstName":null, "prmEmail":"khaja.rafeeq@dham.ae", "phoneno":"+971562351086", "passportno":null, "partyid":null, "park":"DKP", "licno":null, "leadId":"00Q6u000001jiCrEAI", "emailid":"khaja.rafeeq@dham.ae", "dob":null, "ddaid":null, "currentnat":null, "ccrmid":null, "axsSrNo":null, "appicationnum":null, "accountname":"Freelancer testing", "accid":null}';
        r.xadtx1__c = adhoc; r.os__c = 'Lead generated'; r.xcmob__c = ''; update r;

    }
     static testmethod void testUploadDoc() {
        Test.startTest();
         BatchOnboardMbupdate obj = new BatchOnboardMbupdate();
         BatchOnboardMbupdate obj1 = new BatchOnboardMbupdate('tst');
         Database.executeBatch(obj, 1);
        Test.stopTest();
     }

}