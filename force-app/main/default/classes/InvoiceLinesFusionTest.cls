@isTest
private class InvoiceLinesFusionTest {
  static testmethod void meth1() {
      Test.startTest();
       InvoiceLinesFusion.Input i= new InvoiceLinesFusion.Input();
       i.AccountingDate = '';i.BillToCustomerNumber = '';i.BillToSite = '';
       i.BusinessUnit = null;
      i.InvoiceCurrencyCode = null;
      i.PaymentTerms = null;
      i.TransactionDate = null;i.TransactionSource = null;
      i.TransactionNumber = null;
      i.TransactionType = null;
      i.InvoicingRule = null;
      i.receivablesInvoiceLines = null;
      i.receivablesInvoiceDFF = null;
      InvoiceLinesFusion.receivablesInvoiceDFF ri = new InvoiceLinesFusion.receivablesInvoiceDFF();
       ri.FLEX_Context = null;
       ri.axsExtensionReference = null;
       ri.pmsBuilding = null;
      InvoiceLinesFusion.receivablesInvoiceLines ril = new InvoiceLinesFusion.receivablesInvoiceLines();
      ril.Description = null;
      ril.LineNumber = null;
      ril.LineAmount = null;
      ril.Quantity = null;
      ril.UnitSellingPrice = null;
      ril.MemoLine = null;
      ril.AccountingRule = null;
       ril.RuleStartDate = null;
       ril.RuleEndDate = null;

      InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF c = new InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF();
      c.FLEX_Context = null;
      c.sourceTransactionNumber = null;
      c.sourceLineNumber = null;
      c.supplierNumber = null;
      c.originalInvoiceNumber = null;
      c.previousInvoiceNumber = null;

      InvoiceLinesFusion.receivablesInvoiceLineTaxLines rit = new  InvoiceLinesFusion.receivablesInvoiceLineTaxLines();
      rit.TaxAmount = null;
      rit.TaxRegimeCode = null;
rit.TaxRateCode = null;
      Test.stopTest();

  }
}