public class gctlRQSRV {
    public List<Questionaire__c> qLst {set;get;}
    public String anwser1 {set;get;}
    public String anwser2 {set;get;}
    public String q1 {set;get;}
    public String qId {set;get;}
    public String ctg {set;get;}
    public String counter {set;get;}
    public String cm {set;get;}
    public Map<string, Questionaire__c> qMap {set;get;}
    public gctlRQSRV() {
     anwser1 = ''; anwser2='';q1=''; counter = ''; qId = '';cm = ''; ctg = '';
     counter = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('c'));
     anwser1 = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('a'));
     qMap = new Map<String, Questionaire__c>();
     qLst =  [select id, Question_Number__c, Question_Text__c, Type_of_question_in_GetFeedback__c, Survey__c from Questionaire__c where Survey__r.name='AXS Center (GSO Counters)'];
        for (Questionaire__c q : qLst) {
            qMap.put(q.Question_Number__c, q);
            if (q.Question_Number__c == '1')
               q1 = q.Question_Text__c;
        }

    }

    Public PageReference submit() {
        PageReference ref = null;

        List<Answer__c> ansLst = new  List<Answer__c>();
        if (anwser2 != null && anwser2 != '') {
         /* Survey_Request__c res = new Survey_Request__c();
         res.Survey__c =   qMap.get('1').Survey__c;
         insert res;*/
        Datetime dt = datetime.now();
        String uid = 'R_'+dt.getTime()+'_'+counter;
          if (qId == 's')
             qId = qMap.get('3').id;
           else
             qId = qMap.get('2').id;

        Answer__c ans = new Answer__c();
         ans.Survey_Request__c = gU.csStr('counter SurveyId'); //'a1328000000qraLAAQ';
         ans.Questionaire__c = qMap.get('1').id;
         ans.Answer_by_customer__c = anwser1;
         ans.Score__c = integer.valueOf(anwser1);
         ans.Start_time__c = datetime.now();
         ans.Completion_Time__c = datetime.now();
         ans.scnt__c = counter;
         ans.Unique_Response_Id__c = uid;
         ans.Survey__c = qMap.get('1').Survey__c;
         ans.Category__c = ctg;
         ansLst.add(ans);
         if (qId != null) {
          Answer__c ans1 = new Answer__c();
          ans1.Survey_Request__c = gU.csStr('counter SurveyId');
          ans1.Questionaire__c = qId;
          ans1.Answer_by_customer__c = anwser2;
          ans1.Start_time__c = datetime.now();
          ans1.Completion_Time__c = datetime.now();
          ans1.Comments__c = cm;
          ans1.scnt__c = counter;
          ans1.Category__c = ctg;
          ans1.Unique_Response_Id__c = uid;
          ans1.Survey__c = qMap.get('1').Survey__c;
          ansLst.add(ans1);
         }
        if (Schema.sObjectType.Answer__c.isCreateable()) {
            insert ansLst;
        }
       system.debug('ansLst::'+ansLst);
        ref = new PageReference('/apex/grqsrvi?c='+counter);
        ref.setRedirect(true);
        }
        return ref;

    }
     Public PageReference previous() {
        PageReference ref = null;
        ref = new PageReference('/apex/grqsrv?c='+counter+'&a='+anwser1);
        ref.setRedirect(true);
        return ref;

     }
     Public PageReference firstPage() {
        PageReference ref = null;
        ref = new PageReference('/apex/grqsrv?c='+counter);
        ref.setRedirect(true);
        return ref;

     }

}