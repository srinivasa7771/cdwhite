@isTest
public class TestGctlConMgmt {

    @isTest static void testsaveAccInfo() {
        gctlConMgmt g = new gctlConMgmt();
        g.mgInName = ''; g.mgInPriEmail = ''; g.mgInPriPhn = '';
        g.mgInSecEmail = ''; g.mgInSecPhn = ''; g.exCons = 2;
        g.prolFlg = true; g.success = true; g.acc = new account();
        g.saveAccInfo();
        g.addCon(); g.rmvCon();
    }
}