@isTest
private class CreditMemiLinesFusionTest {
  static testmethod void meth1() {
      CreditMemiLinesFusion.Input i = new CreditMemiLinesFusion.Input();
      i.AccountingDate = null;
      i.BillToCustomerNumber = null;
      i.BillToSite = null;
      i.BusinessUnit = null;
      i.CreditMemoCurrency = null;
      i.TransactionDate = null;
      i.TransactionSource = null;
      i.TransactionNumber = null;
      i.TransactionType = null;
      i.receivablesCreditMemoLines = null;
      i.receivablesCreditMemoDFF = null;
      CreditMemiLinesFusion.receivablesCreditMemoLines rcml = new CreditMemiLinesFusion.receivablesCreditMemoLines();
      rcml.LineNumber = null;
      rcml.LineAmountCredit = null;
      rcml.LineQuantityCredit = null;
      rcml.UnitSellingPrice = null;rcml.MemoLine = null;
      rcml.receivablesCreditMemoLineTransactionDFF = null;
      rcml.receivablesCreditMemoLineTaxLines = null;
      CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF rcmlt = new CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF();
      rcmlt.FLEX_Context = null;
      rcmlt.sourceTransactionNumber = null;
      rcmlt.sourceLineNumber = null;
      rcmlt.supplierNumber = null;
      rcmlt.originalInvoiceNumber = null;
      rcmlt.previousInvoiceNumber = null;
      CreditMemiLinesFusion.receivablesCreditMemoDFF rcm = new CreditMemiLinesFusion.receivablesCreditMemoDFF();
      rcm.FLEX_Context = null;
      rcm.axsExtensionReference = null;
      rcm.pmsBuilding = null;
      CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines rc = new CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines();
      rc.TaxAmount = null;
      rc.TaxRegimeCode = null;
      rc.TaxRateCode = null;

  }
}