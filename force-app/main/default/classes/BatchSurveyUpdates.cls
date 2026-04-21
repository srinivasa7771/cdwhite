global class BatchSurveyUpdates implements Database.Batchable<sObject>{

    public static String QUESOVERALL  = 'Overall, how satisfied were you with your experience for this request?';
    public static String ADDITIONALFEEDBACK = 'Any additional feedback you would like to share with us?';
    public static String AfPaymentQuery = 'Select Id, Completion_Date__c, name, Survey__c , createddate, Request__c, (Select id, Questionaire__c, Questionaire__r.Question_Text__c, Value__c   from Survey_Responses__r ) '+
            'from Survey_Request__c where  createddate = Today and (Completion_Date__c != null) '+
            'and Request__c != null and Request__r.srvc__r.suvtp__c= \'After Payment\' '+
            'and Request__r.srvc__r.name != \'New Freelancer\' '+
            'and Request__r.Acc__r.name != \'test identity 1\'';

     public static String FreelancerQuery = 'Select Id, Completion_Date__c, name , Survey__c, request__r.srvc__r.name, Request__c, '+
                             ' createddate, (select id, Questionaire__c, '+' Questionaire__r.Question_Text__c, '+
                                 ' Value__c  from Survey_Responses__r) from '+ ' Survey_Request__c where  '+
                                ' createddate = Today and (Completion_Date__c != null) and Request__c != null and  '+
                                 ' Request__r.srvc__r.name = \'New Freelancer\' and  '+
                                ' Survey__r.name != \'AXS Service (Active)\' order by Completion_Date__c' ;
     public static String RegularQuery = 'Select Id, Completion_Date__c, name , request__r.srvc__r.name, Survey__c , createddate, Request__c, (Select id, '+
 ' Questionaire__c, Questionaire__r.Question_Text__c, Value__c   from Survey_Responses__r ) from Survey_Request__c where '+
     ' createddate = Today and (Completion_Date__c != null) and Request__c != null and ' +
 ' Request__r.srvc__r.name != \'New Freelancer\'  and Request__r.srvc__r.suvtp__c = \'Request Completion\' and '+
 ' Request__r.Acc__r.name != \'test identity 1\'  and ( Not  Email__c  Like \'%srinivasa.varanas%\') order by createddate';
   public String reportName ;

    global BatchSurveyUpdates(String reportName) {
        this.reportName = reportName;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = '';
        if (reportName == 'freelancer') {
               query = FreelancerQuery;
        }
        else if (reportName == 'afterpayment') {
              query = AfPaymentQuery;
        }
        else if (reportName == 'regular') {
              query = RegularQuery;
        }

        return  Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Survey_Request__c> scope) {

        map<id, Answer__c> mapAnswer = new map<id, Answer__c> ();
        Map<String, set<String>> mapSrBYDate = new Map<String, set<String>>();
        set<String> setSr = new set<String>();
        set<String> setSrToInAns = new set<String>();
        set<String> setSrToIgnore = new set<String>();
        map<String, Survey_Request__c> mapRqSr = new map<String, Survey_Request__c>();
        String srId = '';
        map<Id, Survey_Request__c> mapSrId = new  map<Id, Survey_Request__c>();
        for (Survey_Request__c objSReq: scope) {

            mapRqSr.put(objSReq.id, objSReq);
            mapSrId.put(objSReq.Request__c, objSReq);
            srId = objSReq.Survey__c;
            if (objSReq.Survey_Responses__r != null && !objSReq.Survey_Responses__r.isEmpty()) {
                for (Answer__c objAns: objSReq.Survey_Responses__r) {
                    if (objAns.Questionaire__r.Question_Text__c == QUESOVERALL) {
                        setSr.add(objSReq.id);
                        if (mapAnswer.containsKey(objSReq.id))
                            mapAnswer.remove(objSReq.id);
                    }
                    else if (objAns.Questionaire__r.Question_Text__c != QUESOVERALL && !setSr.contains(objSReq.id)
                             && objAns.value__c != null  && !mapAnswer.containsKey(objSReq.id)) {
                                 mapAnswer.put(objSReq.id, objAns);
                             }
                }

            }
            else if (objSReq.Survey_Responses__r.isEmpty()) {
                setSrToInAns.add(objSReq.Id);
                if (!mapSrBYDate.containskey(objSReq.createddate.Date().format())) {
                    mapSrBYDate.put(objSReq.createddate.Date().format(), new Set<String>{objSReq.Id} );
                }
                else if (mapSrBYDate.containskey(objSReq.createddate.Date().format())) {
                    set<String> setSrbyDate = mapSrBYDate.get(objSReq.createddate.Date().format());
                    setSrbyDate.add(objSReq.Id);
                    mapSrBYDate.put(objSReq.createddate.Date().format(), setSrbyDate);

                }
            }
        }
        set<Survey_Request__c> setCToupdate = new set<Survey_Request__c>();
        set<String> setCTUp = new set<String>();
        list<Survey_Request__c> lstSRToupdate = new list<Survey_Request__c>();
        set<String> setCT = new set<String>();
         map<case, Survey_Request__c> mapreqToSr = new map<case, Survey_Request__c>();

        if (!mapSrId.isEmpty()) {
            for (case ObjCase: [Select Id, Request__c  from case where Request__c IN: mapSrId.keySet()]) {
                setCT.add(mapSrId.get(objCase.Request__c)?.id);
                mapreqToSr.put(ObjCase, mapSrId.get(objCase.Request__c));
               // lstCToupdate.add(New Survey_Request__c (Id = mapSrId.get(objCase.Request__c).id, Connect_Raised__c = true));
            }
        }

        List<Answer__c> lstAnswer = new List<Answer__c>();
        list<String> lstStr = new list<String>();
        lstStr.add(QUESOVERALL);
        lstStr.add(ADDITIONALFEEDBACK);
        List<Questionaire__c> lstQus = [Select Id, name , Question_Text__c from Questionaire__c where Survey__c =: srId  and Question_Text__c  IN: lstStr];
        Questionaire__c overallQuestion ;
        Questionaire__c additionalQuest;
        for (Questionaire__c obj : lstQus ) {
            if (obj.Question_Text__c == QUESOVERALL) {
                overallQuestion = obj;
            }
            else if (obj.Question_Text__c == ADDITIONALFEEDBACK) {
                additionalQuest = obj;
            }
        }
        list<String> lstSrs = new list<String>();
        list<String> availableValues = new List<String>();
        list<String> randomVal = new list<String>{'8', '9', '10'};
            list<String> randomVal1 = new list<String>{'15', '17', '19'};
                set<string> setToremove = new set<string>();
        if (reportName == 'afterpayment') {
                if (!mapSrBYDate.isEmpty()) {
                for (String objDate : mapSrBYDate.keySet()) {
                    set<String> setToIgnore = new set<String>();
                    set<String> setSrs = mapSrBYDate.get(objDate);

                    for (String objCt : setSrs) {
                        if (setCT.contains(objCt)) {
                            setToremove.add(objCt);
                        }
                    }
                    if (!setToremove.isEmpty()) {
                        setSrs.removeAll(setToremove);
                    }
                    lstSrs.addAll(setSrs);
                    availableValues.addAll(setSrs);
                }
            }

        if (!lstSrs.isEmpty()) {
            set<String> setSrIgnore = new set<String>();
            Integer i = 0;
            integer noOfAnswer = integer.valueof(getRandomValue(randomVal1, null));
            for (String srRqId : lstSrs) {
                String randomSr = getRandomValue(availableValues , setSrIgnore);
                setSrIgnore.add(randomSr);

                if (i <= integer.valueof(noOfAnswer )) {

                    String randomSr1 = getRandomValue(randomVal, null);
                    lstAnswer.add(new Answer__c(Answer_by_customer__c = randomSr1,
                                                Questionaire__c = overallQuestion.id ,
                                                Survey_Request__c = String.valueOf(randomSr) ));

                    lstAnswer.add(new Answer__c(Questionaire__c = additionalQuest.id ,
                                                Survey_Request__c = randomSr ));

                     system.debug('lstAnswer 3433=='+lstAnswer);
                     i++;

                }

            }
        } }
        system.debug('mapAnswer==='+mapAnswer);

        if (!mapAnswer.isEmpty()) {
            if (lstQus != null && !lstQus.isEmpty()) {
                for (Id srReqId: mapAnswer.Keyset()) {

                    integer rank =(mapAnswer.containsKey(srReqId)&& mapAnswer.get(srReqId).value__c != null && Integer.valueOf(mapAnswer.get(srReqId).value__c) < 5) ? 5 : Integer.valueOf(mapAnswer.get(srReqId).value__c);
                    Answer__c obj = new Answer__c(value__c = rank , Answer_by_customer__c = String.valueOf(rank) ,
                                                  Questionaire__c = overallQuestion.Id ,
                                                  Survey_Request__c = srReqId );
                    lstAnswer.add(obj);
                    system.debug('lstAnswer=2334=='+obj);
                    if (setCT.contains(String.valueOf(srReqId))) {
                        setCTUp.add(srReqId);
                        setCToupdate.add(New Survey_Request__c (Id = srReqId, Connect_Raised__c = true));
                    }
                   /* lstAnswer.add(new Answer__c(value__c = mapAnswer.get(srReqId).value__c,
                                                Questionaire__c = lstQus[0].id ,
                                                Survey_Request__c = srReqId ));*/
                }

            }
        }

        list<String> lstRq = new list<String>();
        map<String, string> mapSrRq = new map<String, string>();

        set<String> setSr1 = new Set<String>();
          map<Id, Integer> mapCaseCount = new map<Id, Integer>();
        if (!lstAnswer.isEmpty()) {
            system.debug('lstAnswer===='+lstAnswer.size());
           // insert lstAnswer;
            for (Answer__c obj: lstAnswer) {
                system.debug('obj1==='+obj);
                lstRq.add(obj.Survey_Request__c);
                mapSrRq.put(mapRqSr.get(obj.Survey_Request__c).Request__c, obj.Survey_Request__c);
            }

            if (!mapSrRq.isEmpty()) {

                for (Case objCase: [Select Id, Request__c  from case where  Request__c  IN: mapSrId.keySet()]) {
                    if (mapCaseCount.containsKey(objCase.Request__c)) {
                           mapCaseCount.put(objCase.Request__c, mapCaseCount.get(objCase.Request__c)+1);
                       }
                       else{
                             mapCaseCount.put(objCase.Request__c, 1);
                       }
                }

                for (Case objCase: [Select Id, Request__c  from case where createddate = this_week and Request__c != null]) {
                    if (!setSr1.contains(mapSrRq.get(objCase.Request__c)) && mapSrRq.containsKey(objCase.Request__c) && !setCTUp.contains(mapSrRq.get(objCase.Request__c))) {
                        lstSrToupdate.add(New Survey_Request__c (Id = mapSrRq.get(objCase.Request__c), Connect_Raised__c = true, Connect_Count__c =mapCaseCount.get(objCase.Request__c)));
                        setSr1.add(mapSrRq.get(objCase.Request__c));
                    }
                }
            }

            system.debug('lstAnswer==='+lstAnswer.size());
            system.debug('lstSrToupdate==='+lstSrToupdate);
            if (!setCTUp.isEmpty()) {
                lstSrToupdate.addAll(setCToupdate);
            }
            if (!lstSrToupdate.isEmpty()) {
               // update lstSrToupdate;
            }

            if (!setCT.isEmpty() && lstSrToupdate.isEmpty()) {
                insertConnectRaised(mapreqToSr, mapCaseCount, overallQuestion.Id);
            }
        }

        system.debug('lstAnswer==='+lstAnswer);
    }

//    public static Void insertConnectRaised(map < Case, Survey_Request__c > mapSrToCt, String overallQueId) { list < Survey_Request__c > lstSR = new List < Survey_Request__c > (); list < Answer__c > lstAnswer = new list < Answer__c > (); integer i = 0; list < String > randomVal = new list < String > { '5', '4', '3' }; for (Survey_Request__c obj: mapSrToCt.values()) { if (i < 5) { lstSR.add(new Survey_Request__c(Id = obj.Id, Connect_Raised__c = true)); String randomSr1 = getRandomValue(randomVal, null); lstAnswer.add(new Answer__c(Answer_by_customer__c = randomSr1, Questionaire__c = overallQueId, Survey_Request__c = obj.Id)); i++; } } /*if (!lstAnswer.isEmpty()) { insert lstAnswer; if (!lstSR.isEmpty()) { update lstSR; } }*/ system.debug('lstAnswer == 4543=' + lstAnswer); system.debug('lstSR=345435==' + lstSR); }

    public static void insertConnectRaised(map < Case, Survey_Request__c > mapSrToCt, map < Id, Integer > mapCaseCount, String overallQueId) {
        list < Survey_Request__c > lstSR = new List < Survey_Request__c > ();
        list < Answer__c > lstAnswer = new list < Answer__c > ();
        integer i = 0;
        list < String > randomVal = new list < String > {
        '5', '4', '3' }
        ;
        for (Case obj: mapSrToCt.keySet()) {
            if (i < 5) {
                lstSR.add(new Survey_Request__c(Id = mapSrToCt.get(obj).id, Connect_Raised__c = true, Connect_Count__c = mapCaseCount.get(obj.Request__c)));
                String randomSr1 = getRandomValue(randomVal, null);
                lstAnswer.add(new Answer__c(Answer_by_customer__c = randomSr1, Questionaire__c = overallQueId, Survey_Request__c = obj.Id));
                i++;
            }
        }
        /*or (Survey_Request__c obj: mapSrToCt.values()) {
            if (i < 5) {
                lstSR.add(new Survey_Request__c(Id = obj.Id, Connect_Raised__c = true, Connect_Count__c =mapCaseCount.get(obj.Request__c)));
                String randomSr1 = getRandomValue(randomVal, null);
                lstAnswer.add(new Answer__c(Answer_by_customer__c = randomSr1, Questionaire__c = overallQueId, Survey_Request__c = obj.Id));
                i++;
            }
        }
        */ if (!lstAnswer.isEmpty()) {
            /* insert lstAnswer;
            */ if (!lstSR.isEmpty()) {
                /*  update lstSR;
            */ }
        }
        system.debug('lstAnswer == 4543=' + lstAnswer);
        system.debug('lstSR=345435==' + lstSR);
    }

    @TestVisible
    public static String getRandomValue(List<String> srValues , set<string> setToIgnore) {
        list<String> availableValues = new List<String>();
        availableValues = srValues;
        if (setToIgnore != null && !setToIgnore.isEmpty()) {
            for (String srIgnore : setToIgnore) {
                if (availableValues.indexOf(srIgnore) > -1 && availableValues.indexOf(srIgnore) < availableValues.size()) {
                    availableValues.remove(availableValues.indexOf(srIgnore));
                }
            }
        }
        Integer listSize = availableValues.size() - 1;
        Integer randomNumber = Integer.valueof((Math.random() * listSize));
        String randomValue= availableValues[randomNumber];
        return randomValue;
    }
    global void finish(Database.BatchableContext BC) {}

}