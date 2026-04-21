@IsTest
public class BatchSTAHISTest {
@IsTest
    static void STAHISTesttest() {
        try{
           String queryString = 'select itm__r.itm__r.srvc__r.uid__c, itm__c, RQ__c, statype__c, SLA_Action__c, Milestone__c, staowner__c, acts__c' +
               ', actE__c, estE__c, sla__c, Duration__c, cd__c, f__c, t__c from g_itmHistorySTA__c' +
                   ' where t__r.Name=\'Medically Fit\'  and itm__r.itm__r.srvc__r.uid__c in (\'192\', \'055\', \'040\', \'002\', \'010\', \'189\', \'015\', \'191\', \'193\', \'004\', \'027\', \'028\', \'026\', \'106\', \'078\', \'080\', \'105\', \'081\', \'021\', \'020\', \'003\', \'025\', \'190\', \'016\', \'001\', \'188\')' +
               ' and CALENDAR_YEAR(createddate)=2019';
           BatchSTAHIS obj = new BatchSTAHIS();
            obj.queryString = queryString;
            database.executeBatch(obj, 1);
        }catch (Exception e) {}
    }
}