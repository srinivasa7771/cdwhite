@isTest
public class leAMLCtlTest {
     @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.sdg__c = sd.id;
        update s;
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }
    static testmethod void test1() {
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Test.startTest();
         PageReference myVfPage = new PageReference('/apex/AuditReport');
         Test.setCurrentPage(myVfPage);
         String rid = ApexPages.currentPage().getParameters().put('sid', srvcLst[0].id);
        String DHREAcc = '{"005Ff000006MEqTIAW":["102202", "19299", "93067", "93068567", "9306722"], "005Ik0000010E3dIAE":["102202", "19299", "93067", "93068567", "9306722"]}';
        //System.Label.DHRE_Accounts;
        leAMLCtl obj = new leAMLCtl();
        obj.formatDateToString(System.Today());
        leAMLCtl.FnInfo fi = new leAMLCtl.FnInfo();
        fi.revenues = '0'; fi.costofsales='0';fi.yearstartdate = date.today(); fi.yearenddate = date.today();
        fi.grossprofit = '0';fi.operatingcost = '0';fi.operatingprofit = '0';fi.interestexpenses = '0';fi.depreciation = '0';
        fi.otherincomeorloss = '0';fi.netprofit = '0';
        fi.yearstartdate = Date.today();
        fi.yearenddate = Date.today().addMonths(12);
        fi.amortization=fi.amortization;
         fi.auditfirm=fi.auditfirm;
         fi.financialYear=fi.financialYear;
         fi.reasonNonSubmission=fi.reasonNonSubmission;
         fi.reasonNewSubmissionDate=fi.reasonNewSubmissionDate;
         fi.selectedCurrency=fi.selectedCurrency;

        obj.currentAfsRequest=obj.currentAfsRequest;
        obj.ast=obj.ast;
        obj.infoDocLst=obj.infoDocLst;
        obj.farDiff=obj.farDiff;
        obj.liFirstDate=obj.liFirstDate;
        obj.newSubmissionDate=obj.newSubmissionDate;
        obj.dsgu=obj.dsgu;
        obj.penaltyApplied=obj.penaltyApplied;

        obj.rq.Acc__c = accLst[0].id;obj.isdoc='';
        obj.fi = fi;
        List<String> srvList = new List<String>();
        obj.srvList = srvList;
        List<String> srvTrnsList = new List<String>();
        obj.srvTrnsList = srvTrnsList;
        obj.saveReq();
       g_Req__c rq =  [select id from g_Req__c limit 1];
       ApexPages.currentPage().getParameters().put('id', rq.id);
       leAMLCtl obj1 = new leAMLCtl();
        Test.stopTest();
    }
}