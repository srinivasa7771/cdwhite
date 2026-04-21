@isTest
private class CMDMFuAppTest {
  static testmethod void meth1() {
      Test.startTest();
       CMDMFuApp c = new CMDMFuApp();
       c.BusinessUnitName = null;
       c.CreditMemoTrxId = null;
      c.DebitMemoTrxId = null;
      c.AmountApplied = null;
      c.InvoiceLineNumber = null;
      c.GlDate = null;
      c.ApplyDate = null;
      Test.stopTest();
  }
}