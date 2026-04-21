public class Couriersummary
{

    public List<AggregateResult> lstAXS {get;set;}
    public list<g_cmb__c> lstSTA;
    public list<XMLParserforEmpostWebservice.summary> LstEMPOST {get; set;}
    public List<PageRecord> Lstcls {get; set;}
    public string ConfirmImg {get; set;}
    public string ErrorImg {get; set;}
    public Date fromDate {get; set;}
    public Date toDate {get; set;}
    public Integer empTotal {get; set;}
    public Integer axsTotal{get; set;}

    public class PageRecord
    {
        Public String Status {get;set;}
        Public Integer AXSCount {get;set;}
        Public Integer EMPOSTCount {get;set;}
        Public Boolean Matched {get; set;}
    }

    public Couriersummary (ApexPages.StandardController c) {empTotal=0;axsTotal=0;}

    public void CouriersummaryMethod() {
        Boolean InList;
        //String fromDateString = fromDate.format();
        //System.debug('--fromdateString-- : ' +fromdateString);
        //ConfirmImg = '/img/msg_icons/confirm16.png';
        //Errorimg = '/img/msg_icons/error16.png'; //'img/func_icons/util/escalation16.gif';
       // fromDate = Date.valueOf('2016-04-18 00:00:00');
        //toDate = Date.valueOf('2016-04-19 00:00:00');
     //fromDate= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fromDate'));
        //Datetime st = Datetime.parse(fromDate);
Datetime dt = datetime.newInstance(fromDate.year(), fromDate.month(), fromDate.day(), 0, 0, 0);

DateTime refDate2 = dt.addDays(1);

        XMLParserforEmpostWebservice obj = new XMLParserforEmpostWebservice();
        //String Res = XMLParserforEmpostWebservice.GetStatusSummary(String.valueOf(fromDate), String.Valueof(toDate));
        String Res = XMLParserforEmpostWebservice.GetStatusSummary(dt.format('dd-MMM-YYYY'), '19-Apr-2016');
      axsTotal=0;
        empTotal=0;

        LstEMPOST = obj.jsonToList(res);

        lstSTA = [SELECT Id, xawb__c, sta__c FROM g_cmb__c WHERE   DAY_ONLY(convertTimezone(createdDate)) = :fromDate ORDER BY xawb__c, createdDate desc];

        map<String, integer> mapAXSstatuscount = new map<String, integer>();

        if (lstSTA.size()>0) {
            String oldawb = '';

            for (g_cmb__c loopvar : lstSTA) {
                String newawb = String.valueOf(loopvar.xawb__c);
                if (oldawb != newawb) {
                    if (mapAXSstatuscount.containsKey(loopvar.sta__c)) {
                        mapAXSstatuscount.put(loopvar.sta__c, mapAXSstatuscount.get(loopvar.sta__c)+1);
                    }
                    else
                    {
                        mapAXSstatuscount.put(loopvar.sta__c, 1);
                    }
                }
            }
        }

        Lstcls = new List<PageRecord>();
        PageRecord PRobj;

        for (String loopvar : mapAXSstatuscount.keySet()) {
            PRobj = new PageRecord();
            InList = false;
            for (integer i=0; i<LstEMPOST.size(); i++) {
                if (LstEMPOST.size() > 0) {
                    if (LstEMPOST[i].status.equalsIgnoreCase(loopvar)) {
                        PRobj = new PageRecord();
                        PRobj.Status = loopvar;
                        PRobj.EMPOSTCount = Integer.valueOf(LstEMPOST[i].Count);
                        PRobj.AXSCount = mapAXSstatuscount.get(loopvar);
                         axsTotal=axsTotal+Integer.valueof(mapAXSstatuscount.get(loopvar));
                         empTotal=empTotal+Integer.valueOf(LstEMPOST[i].Count);
                        if (PRobj.EMPOSTCount == PRobj.AXSCount) PRobj.Matched = true;
                        else PRobj.Matched = false;
                        Lstcls.add(PRobj);
                        LstEMPOST.remove(i);
                        InList = true;
                    }
                }
            }
            if (!InList) {
                PRobj = new PageRecord();
                PRobj.Status = loopvar;
                PRobj.EMPOSTCount = 0;
                PRobj.AXSCount = mapAXSstatuscount.get(loopvar);
                if (mapAXSstatuscount != null && !mapAXSstatuscount.isEmpty() && mapAXSstatuscount.get(loopvar)!=null) {
                axsTotal=axsTotal+Integer.valueof(mapAXSstatuscount.get(loopvar));
                }
                    PRobj.Matched = false;
                Lstcls.add(PRobj);
            }
        }

        if (LstEMPOST.size() > 0) {
            for (XMLParserforEmpostWebservice.summary loopvar : LstEMPOST) {
                PRobj = new PageRecord();
                PRobj.Status = loopvar.Status;
                PRobj.EMPOSTCount = Integer.valueof(loopvar.count);
                if (loopvar != null) {
                empTotal=empTotal+Integer.valueof(loopvar.count);
                }
                PRobj.AXSCount = 0;
                PRobj.Matched = false;
                Lstcls.add(PRobj);
            }
        }
    }
}