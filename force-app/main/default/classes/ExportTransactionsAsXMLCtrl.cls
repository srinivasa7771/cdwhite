public with sharing class ExportTransactionsAsXMLCtrl {
    public String str {get;set;}
     public string nwln{get;set;}
    public class trans {
        public string tid{get;set;}
        public Decimal amt{get;set;}
        public Datetime gwdt{get;set;}
        public string gwmsg{get;set;}
        public string gwrf{get;set;}
        public string gwcd{get;set;}
        public string md{get;set;}
        public string sta{get;set;}
        public Datetime createdDate{get;set;}
    }
   // public Map<Date, new trans()> transactiosMap{get;set;}
    public List<trans> transList{get;set;}
    public ExportTransactionsAsXMLCtrl() {
        try{
       // transactiosMap = new Map<Date, List<new trans()>>();
        transList = new List<trans>();
            nwln='\r';
            trans t;
        String selectedMonth = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('selectedMonth'));
        String selectedYear = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('selectedYear'));
        str = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fileName'));
        Date startDate = Date.today();
        if (selectedMonth != null && selectedMonth!='' && selectedYear != null && selectedYear!='') {startDate = Date.newInstance(Integer.valueOf(selectedYear), Integer.valueOf(selectedMonth), 1);}
        startDate = startDate.toStartOfMonth();
        DateTime endDate = DateTime.newInstance(startDate.year(), startDate.month(), Date.daysInMonth(startDate.year(), startDate.month()), 23, 59, 59);
        if (enddate>Date.today()) {endDate =  system.now();}
       for (g_Tran__C trans: [SELECT X18Did__c, A__c, gwdt__c, gwmsg__c, gwrf__c, gwcd__c,
           md__c, sta__c, createdDate FROM g_Tran__c where TP__c='Payment'and sta__c='Completed' AND md__c NOT IN ('Customer Deposit',
               'Bank Letter', 'Cash', 'Cheque', 'Debit Memo', 'Wire Transfer') AND createdDate>=:startDate and createdDate<=:endDate order by createdDate]) {
             t=new trans();t.tid=trans.X18Did__c;t.gwdt=trans.gwdt__c;t.gwmsg=trans.gwmsg__c;t.gwrf=trans.gwrf__c;t.gwcd=trans.gwcd__c;
           t.md=trans.md__c;t.sta=trans.sta__c;t.createdDate=trans.createdDate;
           t.amt=trans.A__c;
           transList.add(t);
           // Date cdate = trans.CreatedDate.date();if (!transactiosMap.containsKey(cdate)) {transactiosMap.put(cdate, new List<g_Tran__C>());}transactiosMap.get(cdate).add(trans);
       }
        }catch (Exception e) {System.debug(e.getMessage());}
    }
}