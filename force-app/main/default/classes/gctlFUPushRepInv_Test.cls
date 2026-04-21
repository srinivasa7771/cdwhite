@isTest
public class gctlFUPushRepInv_Test {
static testmethod void meth1() {
        gctlFUPushRepInv cls = new gctlFUPushRepInv();
        cls.createFuInv();
        cls.createFuRep();
        cls.createFuDM();
        cls.cmDmappRep();
        cls.createYardiInv();
    cls.respx= 'tes34';

    BalanceChkResp obj = new BalanceChkResp();
    obj.MESSAGE = 'test Msg';
    obj.STATUS = 'test Sta';
    obj.CUST_BAL_UNAPP = 324324.67;
    obj.REFUNDTYPE = 'Test refund';
    obj.CUST_BAL_OPEN_INV = 878676.898;
    obj.ACCOUNTNUMBER = 'TestAccNum';
}
}