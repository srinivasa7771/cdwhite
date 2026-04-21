/*  Oracle fusion meta data map  value are based confugration from oralce fusion
*   Object refrence ORAMETA__c. Method getOraMetaLookup  returns Map with key value
*   of UID and ORAMETA__c
*/
public with sharing class gTOraFusionLookup {
    public gTOraFusionLookup() {}

 public static Map <String, ORAMETA__c> getOraMetaLookup() {
        Map<String, ORAMETA__c> mapOracleFusionFields = new Map<String, ORAMETA__c>();
        List<ORAMETA__c> Oracle_Metadata_list= [select Id, SERVICE__c, TYPE__c, SERVICE_TYPE__c,
            BRAND__c, PAYMENT_METHOD__c, BUSINESSUNITNAME__c, TRANSACTION_SOURCE__c, INVOICEBU__c,
            RECEIPTBU__c, TRANSACTION_TYPE__c, RECEIPT_METHOD__c, PAYMENTTERMS__c, BILLTOSITE__c,
            INVOICINGRULE__c, ACCOUNTINGRULE__c, SUPPILER__c, CUSTOMERSITENAME__c, MEMOLINE__c,
            UID__c  from ORAMETA__c];
      // System.debug('===Oracle_Metadata_list=='+Oracle_Metadata_list);
     for (ORAMETA__c oraMetaRec : Oracle_Metadata_list) {
             mapOracleFusionFields.put(oraMetaRec.UID__c, oraMetaRec);
       //  System.debug(oraMetaRec.UID__c+'===Map=='+oraMetaRec);
        }
    //  System.debug('===mapOracleFusionFields=='+mapOracleFusionFields);
       return mapOracleFusionFields;
    }

}