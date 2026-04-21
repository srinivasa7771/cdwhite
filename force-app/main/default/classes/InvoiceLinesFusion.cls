public class InvoiceLinesFusion {
    public Input Input;
        public class Input {
            public String AccountingDate {set;get;}    //2023-01-02
            public String BillToCustomerNumber {set;get;}    //DHC-103594
            public String BillToSite {set;get;}    //292006
            public String BusinessUnit {set;get;}    //DH: Dubai Holding
            public String InvoiceCurrencyCode {set;get;}    //AED
            public String PaymentTerms {set;get;}    //30 DAYS
            public String TransactionDate {set;get;}    //2023-01-02
            public String TransactionSource {set;get;}    //AXS-New-Manual
            public String TransactionNumber {set;get;}    //T2023013052212
            public String TransactionType {set;get;}    //DH Invoice
            public String Prevalidation{set;get;}
        // public String CrossReference;
            public String InvoicingRule {set;get;}

            public receivablesInvoiceLines[] receivablesInvoiceLines {set;get;}
            public receivablesInvoiceDFF receivablesInvoiceDFF {set;get;}

        }

        public class receivablesInvoiceDFF {
            public String FLEX_Context {set;get;}    //15
            //public String crossReference;    //UAE VAT
            public String axsExtensionReference {set;get;}
            public String pmsBuilding {set;get;}    //VAT STD 5%
        }

        public class receivablesInvoiceLines {
            //public String FLEX_Context;
            public String Description {set;get;}    //Entry permit
            public Decimal LineNumber {set;get;}    //1
            public Decimal LineAmount {set;get;}    //1
            public Decimal Quantity {set;get;}    //1
            public Decimal UnitSellingPrice {set;get;}    //300
            public String MemoLine {set;get;}    //Cost Allocation
            public String AccountingRule {set;get;}
            public String RuleStartDate {set;get;}
            public String RuleEndDate {set;get;}
            public ValidationCriteria[] ValidationCriteria {set;get;}
            public receivablesInvoiceLineTransactionDFF[] receivablesInvoiceLineTransactionDFF {set;get;}
            public receivablesInvoiceLineTaxLines[] receivablesInvoiceLineTaxLines {set;get;}
        }
        public class receivablesInvoiceLineTransactionDFF {
            public String FLEX_Context {set;get;}    //AXS
            public String sourceTransactionNumber {set;get;}    //T2023013052212
            public Decimal sourceLineNumber {set;get;}    //1
            public String supplierNumber {set;get;}    //123456
            public String originalInvoiceNumber {set;get;}
            public String previousInvoiceNumber {set;get;}

        }
        public class receivablesInvoiceLineTaxLines {
            public Decimal TaxAmount {set;get;}    //15
            public String TaxRegimeCode {set;get;}    //UAE VAT
            public String TaxRateCode {set;get;}    //VAT STD 5%
        }

        public class ValidationCriteria {
            public String serviceName {set;get;}    //Service Name--BUNDLE SERVICES
            public String attribute1  {set;get;}    //T Number
            public String attribute2  {set;get;}    //0
            public String attribute3  {set;get;}    //null
        }

    }