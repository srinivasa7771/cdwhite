@isTest(SeeAllData=false)
public class lstViewCntTest {

    @TestSetup static void setup() {
        testData.init();
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        User usr = testData.createportalUser('test');
        insert usr;

        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select accountid from contact where id=:ulist[0].contactid LIMIT 1];
        conList[0].xped__c =Date.newInstance(2023, 12, 9);
        conList[0].rp__c ='1123123123';
        conList[0].rol__c ='Employee';
        update conList;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c = '220';
        update s;
        Contact emp=testData.conCrt(null, conList[0].accountId, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(conList[0].accountId, s.Id, conList[0].Id, 'Open', stg.reqq__c);
        g_Req__c r=testData.reqCrtOptItems(conList[0].accountId, s.Id, conList[0].Id, 'Open', stg.reqq__c, 'md');
        List<g_reqitem__c>  riItmLst =[select id, xf__c, itm__c, RQ__r.Service_Code__c, RQ__r.tsrv__c, itm__r.cd__c , AP__c,
                                       STA__r.cd__c, RQ__r.xcamc__c, RQ__r.STA__c from g_reqitem__c where itm__r.cd__c ='md'];

        r.xcamc__c = 'Operating Name Change';
        r.STA__c = 'In Process';
        r.tsrv__c = false;
        update r;
        g_srvcitm__c srvItem= new g_srvcitm__c(Id = riItmLst[0].itm__c, cd__c= 'dr', ilv__c='ofl:ok;ofl:r;ofl:c;', elv__c ='ofl:ok;ofl:r;ofl:c;');
        update srvItem;
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=riItmLst[0].RQ__c, TP__c='Payment');
        insert T;
        List<g_TranItem__c> TIs = new List<g_TranItem__c>();
        TIs.add(new g_TranItem__c(itm__c = riItmLst[0].Id, T__c = T.Id, iRef__c = '20102666341', A__c =552.50, Tp__c = 'Payment', STA__c = 'Completed'));
        TIs.add(new g_TranItem__c(itm__c = riItmLst[0].Id, T__c = T.Id, iRef__c = '20102666342', A__c =552.50, Tp__c = 'Payment', STA__c = 'Completed'));
        TIs.add(new g_TranItem__c(itm__c = riItmLst[0].Id, T__c = T.Id, iRef__c = '20102666343', A__c =552.50, Tp__c = 'Payment', STA__c = 'Completed'));
        insert  TIs;

        riItmLst =[select id, xf__c, itm__c, RQ__r.Service_Code__c, RQ__r.tsrv__c, itm__r.cd__c , AP__c,
                   STA__r.cd__c, RQ__r.xcamc__c, RQ__r.STA__c from g_reqitem__c];
        system.debug('riItmLst=1=='+riItmLst);
    }

    static testMethod void doTest() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='001, 002, 003, 004, 021, 078, 040, 020';
        listV.getCatOpt();
        listV.getItmOpt();
        listV.getStsOpt();
        listV.selItm = 'ep';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }

    static testMethod void doTest1() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='220';

        listV.selItm = 'dr, dsr, xyz, cdr';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }

    static testMethod void doTest2() {
        boolean blV;String sV;
        List<g_reqitem__c>  riItmLst =[select id, xf__c, itm__c, RQ__r.Service_Code__c, RQ__r.tsrv__c, itm__r.cd__c , AP__c,
                                       STA__r.cd__c, RQ__r.xcamc__c, RQ__r.STA__c from g_reqitem__c];
        g_srvcitm__c srvItem= new g_srvcitm__c(Id = riItmLst[0].itm__c,  elv__c ='ofl:ok;ofl:r;ofl:c;');
        update srvItem;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='221';

        listV.selItm = 'dr, dsr, xyz, cdr';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }

    static testMethod void doTest3() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='200';

        listV.selItm = 'att, att_a';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }

    static testMethod void doTest4() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='ltc';

        listV.selItm = 'att_a';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }
    static testMethod void doTest5() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        lstViewCnt listV = new lstViewCnt();
        listV.selCatg='923';
        listV.queryReq();
        Test.stopTest();
    }

}