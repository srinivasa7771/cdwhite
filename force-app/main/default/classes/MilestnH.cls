public class MilestnH {
    private static final String STAGE_DELIMITER = '[;]{1}[\\s]?'; // for semi colon
    private static final String ST_DRFT = 'Draft';
    private static final String ST_OPEN = 'Open';
    private static final String ST_CMPL = 'Completed';
    private static final String ST_CNCL = 'Cancelled';
    private static final String ST_RJCT = 'Rejected';
    private static final String BUSINESS_HOUR_NAME = 'BH';
    private static Decimal correctionTime = 0;
    //private static Decimal totalDuration = 0;
    private static Datetime estimatedEndTime;
    private static BusinessHours bsHour;
    private static Boolean checkMilestone = false;
    private static Integer toHour=3600000;

    public static final String SLA_ACTION_STANDARD = 'Standard';
    public static final String SLA_ACTION_ADDITIONAL = 'Additional';
    public static final String SLA_ACTION_PARALLEL = 'Parallel';
    public static final String SLA_ACTION_AUTO = 'Auto';
    public static final String SLA_ACTION_COMPLETED = 'Completed';
    public static final String SLA_ACTION_CANCELLED = 'Cancelled';
    public static final String SLA_ACTION_REJECTED = 'Rejected';

    public static final String ACTION_TYPE_PROCESS = 'Process';
    public static final String ACTION_TYPE_ADDITIONAL_PROCESS = 'Additional Process';
    //link milestone lookup on request item records && priority SLA

    public static Map<String, g_Milestone__c> getMilestoneMap(Set<Id> lstRqIds) {
        Map<String, g_Milestone__c> mpMslId = new Map<String, g_Milestone__c>();
        for (g_Milestone__c mst : [SELECT Id, Start_Date__c, End_Date__c, Additional_End_Date__c, ovh__c, Status__c, Estimated_End_Date__c, Request__c, Name__c, SLA__c,
                                  Total_Duration__c, pmstone__r.End_Date__c, pmstone__r.Status__c, pmstone__r.lastmodifieddate FROM g_Milestone__c WHERE Request__c IN :lstRqIds]) {
                                      mpMslId.put(mst.Request__c+mst.Name__c, mst);
                                  }
        return mpMslId;
    }

    private static BusinessHours mBH;
    //by sachin kadian to calcululate status history and milestones
    public static void reCalculateHistoryAndMilestone(g_itmHistorySTA__c statusHistory, g_Milestone__c historyMilestone, BusinessHours bH, String nextStatus) {
        mBH = bH;
        //if milestone is in draft status,
        //change its status to open,
        //only consider  standard and additional here and convert additional to standard
        //if it is closure, change status to Completed

        //if milestone is in DRAFT or OPEN status
        if (historyMilestone.Status__c == ST_DRFT || historyMilestone.Status__c == ST_OPEN) {
            String mileStoneNewStatus;
            String statusHistoryNewType;
            if (statusHistory.SLA_Action__c == SLA_ACTION_STANDARD || statusHistory.SLA_Action__c == SLA_ACTION_ADDITIONAL) {
                mileStoneNewStatus = nextStatus;
                statusHistoryNewType = SLA_ACTION_STANDARD;
                calculateStatusHistoryFields(statusHistory, statusHistoryNewType, historyMilestone.Start_Date__c, historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, false, false);
                calculateMileStoneFields(historyMilestone, mileStoneNewStatus, statusHistory.acts__c, statusHistory.actE__c, NULL);
                }
                else if (( statusHistory.SLA_Action__c == SLA_ACTION_PARALLEL || statusHistory.SLA_Action__c == SLA_ACTION_AUTO) && (nextStatus == SLA_ACTION_COMPLETED || nextStatus == SLA_ACTION_CANCELLED || nextStatus == SLA_ACTION_REJECTED)) {
                    mileStoneNewStatus = nextStatus;
                    calculateMileStoneFields(historyMilestone, mileStoneNewStatus, NULL, NULL, NULL);
                }

        }
        //if Milestone is in Completed, cancelled or Rejected status
        else {
            //if milestone is closed without additional end date
            if (historyMilestone.End_Date__c == historyMilestone.Additional_End_Date__c) {
                /*if it is a standard process, reopen it*/ if (statusHistory.SLA_Action__c == SLA_ACTION_STANDARD) {
                    calculateStatusHistoryFields(statusHistory, SLA_ACTION_STANDARD, historyMilestone.Start_Date__c,
                        historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, false, false);
                    if (!(statusHistory.acts__c >= historyMilestone.Start_Date__c && statusHistory.actE__c <= historyMilestone.End_Date__c)) {
                        calculateMileStoneFields(historyMilestone, nextStatus, statusHistory.acts__c, statusHistory.actE__c, NULL);
                    }
                }
                /*if it is additional process, dont reopen the milestone but extend its additional end date*/ /*also counter duration in this case will be consider only which happened after the milestone additional end date(i.e same as end date)*/ else if (statusHistory.SLA_Action__c != SLA_ACTION_PARALLEL && statusHistory.SLA_Action__c != SLA_ACTION_AUTO) {
                    calculateStatusHistoryFields(statusHistory, SLA_ACTION_ADDITIONAL, historyMilestone.Start_Date__c,
                        historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, true, false);
                    calculateMileStoneFields(historyMilestone, NULL, NULL, NULL, statusHistory.actE__c);
                }
            }
            //else if milestone is closed with additional
            else{
                //dont reopen the milestone
                //if it is standard, ignore the timing that came after additional end date in counter duration
                if (statusHistory.SLA_Action__c == SLA_ACTION_STANDARD) {
                    calculateStatusHistoryFields(statusHistory, SLA_ACTION_STANDARD, historyMilestone.Start_Date__c,
                        historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, false, true);
                    }
                    /*if it is additional, ignore the timing that came before milestone start date in counter duration*/ else if (statusHistory.SLA_Action__c != SLA_ACTION_PARALLEL && statusHistory.SLA_Action__c != SLA_ACTION_AUTO) {
                        calculateStatusHistoryFields(statusHistory, SLA_ACTION_ADDITIONAL, historyMilestone.Start_Date__c,
                            historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, true, false);
                    }

                calculateMileStoneFields(historyMilestone, NULL, NULL, NULL, statusHistory.actE__c);
            }
        }

    }

    private static void calculateMileStoneFields(g_Milestone__c historyMilestone, String status, DateTime startDate, DateTime endDate, DateTime additionalEndDate) {
        if (startDate != NULL) historyMilestone.Start_Date__c          = historyMilestone.Start_Date__c == NULL || startDate < historyMilestone.Start_Date__c ? startDate : historyMilestone.Start_Date__c;
        if (endDate != NULL) historyMilestone.End_Date__c            = historyMilestone.End_Date__c == NULL || endDate   > historyMilestone.End_Date__c   ? endDate   : historyMilestone.End_Date__c;
        if (additionalEndDate != null && additionalEndDate > historyMilestone.Additional_End_Date__c)historyMilestone.Additional_End_Date__c = additionalEndDate;
        else
            historyMilestone.Additional_End_Date__c = historyMilestone.End_Date__c ;
        if (status != null )
            historyMilestone.Status__c              = status;

        if (historyMilestone.Start_Date__c != NULL && historyMilestone.Additional_End_Date__c != NULL)historyMilestone.Total_Duration__c      = calculateDuration(historyMilestone.Start_Date__c,
            historyMilestone.Additional_End_Date__c, mBH.Id);
        if (historyMilestone.End_Date__c != NULL && historyMilestone.Additional_End_Date__c != NULL)
            historyMilestone.ovh__c                 = calculateDuration(historyMilestone.End_Date__c, historyMilestone.Additional_End_Date__c, mBH.Id);
    }

    private static void calculateStatusHistoryFields(g_itmHistorySTA__c statusHistory,
        String msType, DateTime msStartDate, DateTime msEndDate, DateTime msAdditionEndDate,
        Boolean ignoreStarting, Boolean ignoreEnd) {
        if (msType != NULL)
            statusHistory.SLA_Action__c = msType;
        Double staHCounterDuration = 0;
        //if milestone start and end dates are not null (means when milestone is not in draft status)
        // calculate counter duration accordingly
        if (msStartDate != NULL && msEndDate != NULL) {
            if (!ignoreStarting) {
                if (statusHistory.acts__c < msStartDate) {
                    DateTime durationStartTime = statusHistory.acts__c;
                    DateTime durationEndTime   = statusHistory.acte__c < msStartDate ? statusHistory.acte__c : msStartDate;
                    staHCounterDuration += calculateDuration(durationStartTime, durationEndTime, mBH.Id);
                }
            }
            if (!ignoreEnd) {
                if (statusHistory.acte__c > msAdditionEndDate) {
                    DateTime durationStartTime = msAdditionEndDate > statusHistory.acts__c ? msAdditionEndDate : statusHistory.acts__c;
                    DateTime durationEndTime   = statusHistory.acte__c;
                    staHCounterDuration += calculateDuration(durationStartTime, durationEndTime, mBH.Id);
                }
            }
            /*if counter duration is 0, it means it is parallel*/ if (staHCounterDuration == 0) {
                statusHistory.SLA_Action__c = 'Parallel';
            }
        }
        //if milestone is in draft status
        //counter duration  = STA[E]-STA[S]
        else{
            staHCounterDuration = calculateDuration(statusHistory.acts__c, statusHistory.acte__c, mBH.Id);
        }
        statusHistory.cd__c = staHCounterDuration;
    }

    public static Double calculateDuration(DateTime startDate, DateTime endDate, Id businessHoursId ) {
        Double totalDuration;
        if (startDate != null && endDate != null && businessHoursId != null) {
            totalDuration = ((Double)BusinessHours.diff(businessHoursId, startDate, endDate))/toHour;
        }
        return totalDuration;
    }
}