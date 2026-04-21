/**
 * Description: Test class for grqbgtocdCtrl
 * Added By: Meenu
 * Version : 1.0 - Test Class for grqbgtocdCtrl
 * Added On : 11-March-2024
 */

@isTest
private class grqbgtocdCtrlTest {
    /**
     * Method to set up data
     */
    @testSetup static void setup() {
        testData.init();
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        User usr = testData.createportalUser('test');
        insert usr;

        List < user > ulist = [select contactid from user where id =: usr.id LIMIT 1];
        List < Contact > conList = [select accountid from contact where id =: ulist[0].contactid LIMIT 1];
        conList[0].xped__c = Date.newInstance(2023, 12, 9);
        conList[0].rp__c = '1123123123';
        conList[0].rol__c = 'Employee';
        update conList;
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();

        stg.payq__c = 'Select xcnc__c, Id,Name,STA__c,AT__c,AP__c,AOP__c,dsc__c,dsc__r.prct__c,spCh__c,rmob__c,xaloc__c,xbrnd__c,xbn__c, nt__c, xfpc__c, srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.stg__r.payq__c, srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.pstg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c,srvc__r.payMd__c, Acc__r.Name,Acc__r.lc__c, Acc__c,Acc__r.Type,Acc__r.bgrfi__c, Acc__r.adrfi__c,Acc__r.Prk__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c,Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bg__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c,Acc__r.vestd__c,Acc__r.vbtemp__c, LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,Item_Count__c,srvc__r.kstp__c,  Acc__r.adb__c,Acc__r.bgb__c,Acc__r.bgnr__c,xtpa__c,srvc__r.uid__c,xltr__c, (Select Id,Name From reqMbrs__r where isDeleted=false), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c From Transactions__r where isDeleted=false), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AD__c,AOP__c,nt__c,xprnt__c,xr__c, Dsc__c,DscApp__c,KF__c,cN__c,scN__c, smN__c,exp__c,cXP__c,scXP__c,smXP__c, itm__c,itm__r.xf__c,itm__r.cd__c,itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c, itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c,sta__r.rc__c,sta__r.noEXP__c,sta__r.Courier_Stage__c,xcawb__c,xcnopro__c ,xcub__c ,xcco__c,xcasc__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,AV__c,su__c,vsu__c,TAX_CODE__c,extc__c,TAXCODE_SC__c,extcsc__c,vsc__c,vesch__c,vst__c,vec__c,ngs__c,ngsXP__c,tvatp__c,tgop__c,tngop__c,tgovp__c,tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c),Zone__c,Full_Name__c,CreatedBy.Name ,srvc__r.Category__c,xadh__c,xcmob__c ,xceml__c From g_Req__c';
        update stg;
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Contact emp = testData.conCrt(null, conList[0].accountId, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req = testData.reqCrt(conList[0].accountId, s.Id, conList[0].Id, 'Open', stg.reqq__c);


    }
    /**
     * Method to call function where page paremeter is request id
     */
    static testmethod void test1() {
        List < user > ulist = [select id from user where Email = 'portaluser@testorg.com'
            LIMIT 1
        ];

        g_srvc_definition__c sd = new g_srvc_definition__c(Name = 'test', ptype__c = 'Normal:10 Days;Express:3 Days;', cv__c = 'NewVisa', sd__c = 'Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>', docslbl__c = 'Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;

        List < Contact > conLst = [select id from Contact LIMIT 1];
        List < Account > accLst = [select id from Account LIMIT 1];
        List < g_Srvc__c > srvcLst = [select id from g_Srvc__c where Name = 'Srvc'
            LIMIT 1
        ];
        Contact c = new Contact(Id = conLst[0].Id, mbs__c = 500000, eidid__c = '784198774283257', eidedt__c = system.today().addyears(3));
        update c;
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        loc__c aloc = new loc__c(acc__c = accLst[0].Id, IsActive__c = true);
        insert aloc;
        List < g_srvcitm__c > srvitm = [select id from g_srvcitm__c where srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        List < g_srvcitm_Status__c > stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        g_srvcitm_Status__c stng = new g_srvcitm_Status__c(Id = stng1[0].id, Courier_Stage__c = 'Collection');
        g_Srvc__c gs = new g_Srvc__c(id = srvcLst[0].Id, stg__c = srvcsettings[0].Id, sdg__c = sd.id, sprrole__c = 'Employee;Non Sponsored;Student;Trainee', sprsta__c = 'Active', lbl__c = 'employee service', conrol__c = 'Employee', xoi__c = 'test', uid__c = '155', AddOnSrv__c = 'inr;vfs;', dsc__c = 'Employee visa eligibility depends on the size of the facility (lease area) and the business activity.', Prk__c = 'Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers', AccTp__c = 'Customer - External; Customer - LAS', ckgsnc__c = true, snc__c = 'CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;
        g_Req__c rq = new g_Req__c(Id = r.id, xcmbs__c = 5000, con__c = c.Id, acc__c = accLst[0].id, srvc__c = gs.id, STA__c = 'Draft', xadh__c = 'ptn;');
        update rq;
        list < g_reqitem__c > lstrqItem = new list < g_reqitem__c > ();
        for (g_reqitem__c req1: [Select Id from g_reqitem__c]) {
            req1.vst__c = 200;
            req1.exp__c = true;
            req1.vesch__c = 200;
            req1.vec__c = 200;
            lstrqItem.add(req1);
        }
        g_reqitem__c rqitem = new g_reqitem__c(Name = 'test', RQ__c = rq.Id, itm__c = srvitm[0].Id, sta__c = stng1[0].Id);
        g_reqitem__c rqitem1 = new g_reqitem__c(Name = 'test1', RQ__c = rq.Id, itm__c = srvitm[0].Id, sta__c = stng1[0].Id,
            vst__c = 200, exp__c = true, vesch__c = 200,
            vec__c = 200);
        Test.startTest();

        lstrqItem.add(rqitem);
        lstrqItem.add(rqitem1);
        upsert lstrqItem;
        g_reqDoc__c rdoc = new g_reqDoc__c(Name = 'test', RQ__c = rq.Id, ats__c = 5);
        insert rdoc;
        system.debug('rdoc----' + rdoc);
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name = 'test', reqItm__c = rqitem.Id, reqDoc__c = rdoc.Id, mnAts__c = 1);
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;

        // system.runAs(ulist[0]){
        PageReference myVfPage = new PageReference('/apex/grnbgr');
        myVfPage.getParameters().put('id', rq.Id);
        Test.setCurrentPage(myVfPage);
        String rid = ApexPages.currentPage().getParameters().get('id');
        grqbgtocdCtrl objGrq = new grqbgtocdCtrl();
        objGrq.processPay();
        objGrq.assignAccount();
        objGrq.pyMthd = objGrq.pyMthd;
        objGrq.sid = objGrq.sid;
        objGrq.U = objGrq.U;
        objGrq.pt = objGrq.pt;
        objGrq.pDsc = objGrq.pDsc;

        // }
        Test.stopTest();

    }


    /**
     * Method to call function where page paremeter is service sid 
     */
    static testmethod void test2() {
        List < user > ulist = [select id from user where Email = 'portaluser@testorg.com'
            LIMIT 1
        ];
        g_srvc_definition__c sd = new g_srvc_definition__c(Name = 'test', ptype__c = 'Normal:10 Days;Express:3 Days;', cv__c = 'NewVisa', sd__c = 'Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>', docslbl__c = 'Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List < Contact > conLst = [select id from Contact LIMIT 1];
        List < Account > accLst = [select id from Account LIMIT 1];
        List < g_Srvc__c > srvcLst = [select id from g_Srvc__c where Name = 'Srvc'
            LIMIT 1
        ];
        Contact c = new Contact(Id = conLst[0].Id, mbs__c = 500000, eidid__c = '784198774283257', eidedt__c = system.today().addyears(3));
        update c;
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        loc__c aloc = new loc__c(acc__c = accLst[0].Id, IsActive__c = true);
        insert aloc;
        List < g_srvcitm__c > srvitm = [select id from g_srvcitm__c where srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        List < g_srvcitm_Status__c > stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        g_srvcitm_Status__c stng = new g_srvcitm_Status__c(Id = stng1[0].id, Courier_Stage__c = 'Collection');
        update stng;
        g_Srvc__c gs = new g_Srvc__c(id = srvcLst[0].Id, stg__c = srvcsettings[0].Id, sdg__c = sd.id, sprrole__c = 'Employee;Non Sponsored;Student;Trainee', sprsta__c = 'Active', lbl__c = 'employee service', conrol__c = 'Employee', xoi__c = 'test', uid__c = '155', AddOnSrv__c = 'inr;vfs;', dsc__c = 'Employee visa eligibility depends on the size of the facility (lease area) and the business activity.', Prk__c = 'Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers', AccTp__c = 'Customer - External; Customer - LAS', ckgsnc__c = true, snc__c = 'CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;
        g_Req__c rq = new g_Req__c(Id = r.id, xcmbs__c = 5000, con__c = c.Id, acc__c = accLst[0].id, srvc__c = gs.id, STA__c = 'Draft', xadh__c = 'ptn;');
        update rq;

        Test.startTest();

        system.runAs(ulist[0]) {
            PageReference myVfPage = new PageReference('/apex/grnbgr');
            myVfPage.getParameters().put('sid', gs.Id);
            Test.setCurrentPage(myVfPage);
            String rid = ApexPages.currentPage().getParameters().get('sid');
            grqbgtocdCtrl objGrq = new grqbgtocdCtrl();
        }
        Test.stopTest();
    }

}