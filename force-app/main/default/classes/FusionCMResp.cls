public class FusionCMResp {

    public class ReceivablesCreditMemoLineTransactionDFF {
        public String FLEX_Context_DisplayValue{set;get;}
        public String originalInvoiceNumber{set;get;}
        public String supplierNumber{set;get;}
        public String CustomerTrxLineId{set;get;}
        public String FLEX_Context{set;get;}
    }

    public Output Output{set;get;}

    public class ReceivablesCreditMemoLineTaxLines {
        public String LastUpdatedBy{set;get;}
        public String CreationDate{set;get;}
        public String TaxInclusiveIndicator{set;get;}
        public String CreatedBy{set;get;}
        public String TaxableAmount{set;get;}
        public String CustomerTrxLineId{set;get;}
        public String TaxRateCode{set;get;}
        public String Tax{set;get;}
        public String TaxAmount{set;get;}
        public String TaxPointBasis{set;get;}
        public String TaxJurisdictionCode{set;get;}
        public String TaxRate{set;get;}
        public String TaxPointDate{set;get;}
        public String TaxRegimeCode{set;get;}
        public String TaxLineNumber{set;get;}
        public String TaxStatusCode{set;get;}
        public String LastUpdateDate{set;get;}
        public String PlaceOfSupply{set;get;}
    }

    public class Output {
        public String CreationDate{set;get;}
        public ReceivablesCreditMemoLines receivablesCreditMemoLines{set;get;}
        public String CustomerReferenceDate{set;get;}
        public String RecipientEmail{set;get;}
        public String CreditMemoCurrency{set;get;}
        public String ShipToCustomerName{set;get;}
        public String FreightCreditAmount{set;get;}
        public String GenerateBill{set;get;}
        public String EnteredAmount{set;get;}
        public String FreightFOB{set;get;}
        public String PrintDate{set;get;}
        public String AllowCompletion{set;get;}
        public String Carrier{set;get;}
        public String BillToContact{set;get;}
        public String LastUpdatedBy{set;get;}
        public String PurchaseOrderRevision{set;get;}
        public String LegalEntityIdentifier{set;get;}
        public String CreatedBy{set;get;}
        public String SoldToPartyNumber{set;get;}
        public String CustomerTransactionId{set;get;}
        public String BillToCustomerNumber{set;get;}
        public String FirstPartyRegistrationNumber{set;get;}
        public String TransactionBalanceDue{set;get;}
        public String CustomerReference{set;get;}
        public String ShipToContact{set;get;}
        public String DefaultTaxationCountry{set;get;}
        public String BusinessUnit{set;get;}
        public String StructuredPaymentReference{set;get;}
        public String PayingCustomerAccount{set;get;}
        public String ControlCompletionReason{set;get;}
        public String BillToCustomerName{set;get;}
        public String TransactionType{set;get;}
        public String TransactionNumber{set;get;}
        public String FreightShippingReference{set;get;}
        public String CreditMemoStatus{set;get;}
        public String AccountingDate{set;get;}
        public String BillingDate{set;get;}
        public String PrimarySalesperson{set;get;}
        public String DocumentFiscalClassifcation{set;get;}
        public String ConversionRateType{set;get;}
        public String BillToSite{set;get;}
        public String ShipToCustomerNumber{set;get;}
        public String PayingCustomerName{set;get;}
        public String PrintStatus{set;get;}
        public String ConversionRateDate{set;get;}
        public String CreditReason{set;get;}
        public String TransactionDate{set;get;}
        public String Intercompany{set;get;}
        public String SpecialInstructions{set;get;}
        public String PayingCustomerSite{set;get;}
        public String FreightShipDate{set;get;}
        public String DeliveryMethod{set;get;}
        public String TransactionSource{set;get;}
        public String ThirdPartyRegistrationNumber{set;get;}
        public String InternalNotes{set;get;}
        public String DocumentNumber{set;get;}
        public String ConversionRate{set;get;}
        public String PurchaseOrderDate{set;get;}
        public String ShipToCustomerSite{set;get;}
        public String CrossReference{set;get;}
        public String PurchaseOrder{set;get;}
        public String LastUpdateDate{set;get;}
        public String CreditMemoComments{set;get;}
    }

    public class ReceivablesCreditMemoLines {
        public String LineAmountIncludesTax{set;get;}
        public String CreationDate{set;get;}
        public String LineQuantityCredit{set;get;}
        public String Warehouse{set;get;}
        public String TaxInvoiceDate{set;get;}
        public String LineIntendedUse{set;get;}
        public String LineFreightCreditAmount{set;get;}
        public String SalesOrderChannel{set;get;}
        public String TaxExemptionReason{set;get;}
        public String LineNumber{set;get;}
        public String LineProductCategory{set;get;}
        public ReceivablesCreditMemoLineTransactionDFF receivablesCreditMemoLineTransactionDFF{set;get;}
        public String ItemNumber{set;get;}
        public String LineDescription{set;get;}
        public String SalesOrderLine{set;get;}
        public String TransactionLineAssessableValue{set;get;}
        public String SalesOrderDate{set;get;}
        public String LastUpdatedBy{set;get;}
        public String CreatedBy{set;get;}
        public String UnitOfMeasure{set;get;}
        public String LineAmountCredit{set;get;}
        public String TaxInvoiceNumber{set;get;}
        public String LineProductType{set;get;}
        public String ProductFiscalClassification{set;get;}
        public String LineTranslatedDescription{set;get;}
        public String TransactionBusinessCategory{set;get;}
        public String SalesOrderNumber{set;get;}
        public String UserDefinedFiscalClassification{set;get;}
        public String SalesOrderRevision{set;get;}
        public String CustomerTransactionLineId{set;get;}
        public String TaxClassificationCode{set;get;}
        public String TaxExemptionCertificateNumber{set;get;}
        public String LineTaxExemptionHandling{set;get;}
        public String UnitSellingPrice{set;get;}
        public String MemoLine{set;get;}
        public String LastUpdateDate{set;get;}
        public String LineCreditReason{set;get;}
        public ReceivablesCreditMemoLineTaxLines receivablesCreditMemoLineTaxLines{set;get;}
    }

}