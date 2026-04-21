public class CreditMemiLinesFusion {
public Input Input;
    public class Input {
        public String AccountingDate {set;get;}    //2023-01-02
        public String BillToCustomerNumber {set;get;}    //DHC-103594
        public String BillToSite {set;get;}    //292006
        public String BusinessUnit {set;get;}    //DH: Dubai Holding
        public String CreditMemoCurrency {set;get;}    //AED
        public String TransactionDate {set;get;}    //2023-01-02
        public String TransactionSource {set;get;}    //AXS-New-Manual
        public String TransactionNumber {set;get;}    //T2023013052212
        public String TransactionType {set;get;}    //DH Invoice
        public receivablesCreditMemoLines[] receivablesCreditMemoLines {set;get;}
        public receivablesCreditMemoDFF receivablesCreditMemoDFF {set;get;}
    }

    public class receivablesCreditMemoLines {
        //public String Description;    //Entry permit
        public Decimal LineNumber {set;get;}    //1
        public Decimal LineAmountCredit {set;get;}    //1
        public Decimal LineQuantityCredit {set;get;}    //1
        public Decimal UnitSellingPrice {set;get;}    //300
        public String MemoLine {set;get;}    //Cost Allocation
        public receivablesCreditMemoLineTransactionDFF[] receivablesCreditMemoLineTransactionDFF {set;get;}
        public receivablesCreditMemoLineTaxLines[] receivablesCreditMemoLineTaxLines {set;get;}
    }
    public class receivablesCreditMemoLineTransactionDFF {
        public String FLEX_Context {set;get;}    //AXS
        public String sourceTransactionNumber {set;get;}    //T2023013052212
        public String sourceLineNumber {set;get;}    //1
        public String supplierNumber {set;get;}    //123456

        public String originalInvoiceNumber {set;get;}
        public String previousInvoiceNumber {set;get;}

    }
    public class receivablesCreditMemoDFF {
        public String FLEX_Context {set;get;}    //15
        public String axsExtensionReference {set;get;}    //UAE VAT
        public String pmsBuilding {set;get;}    //VAT STD 5%
    }

    public class receivablesCreditMemoLineTaxLines {
        public Decimal TaxAmount {set;get;}    //15
        public String TaxRegimeCode {set;get;}    //UAE VAT
        public String TaxRateCode {set;get;}    //VAT STD 5%
    }

}