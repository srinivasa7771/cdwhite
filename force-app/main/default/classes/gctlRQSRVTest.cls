@isTest
public class gctlRQSRVTest {

  static testmethod void testgctlRQSRV() {
     Test.startTest();

         // Insert Survey Data
        Survey__c survey = TestDataDictionaryForSurvey.SurveyData();
        survey.name = 'AXS Center (GSO Counters)';
        insert survey ;
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='counter SurveyId', Text_Value__c = 'a1328000000qraLAAQ');
        gStg__c srv = new gStg__c(name='Counter Survey', Text_Value__c = survey.id);
        lstGStg.add(pActivation);
        lstGStg.add(srv);
        insert lstGStg;
         // Insert Survey Response
        Survey_Request__c sr = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr.Anonymous_Survey_Request__c = true;
        insert sr;
        list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='counter SurveyId', Checkbox_Value__c=false, Text_Value__c=sr.Id, Number_Value__c=0, Currency_Value__c=0));
      insert stgs;
         // Insert question 1
        Questionaire__c question1 = TestDataDictionaryForSurvey.QuestionaireData('How satisfied are you?', 'Rating', survey );
        question1.Question_Number__c  = '1';
        insert question1;

        // Insert question 2
        Questionaire__c question2 = TestDataDictionaryForSurvey.QuestionaireData('What do you dislike the most?', 'MultiSelect', survey );
        question2.Question_Number__c  = '2';
        insert question2;

        // Insert question 3
        Questionaire__c question3 = TestDataDictionaryForSurvey.QuestionaireData('What did you like the most?', 'MultiSelect', survey );
        question3.Question_Number__c  = '3';
        insert question3;

       gctlRQSRV ctrl = new gctlRQSRV();
       ctrl.anwser1 = '4';
        ctrl.anwser2 = 'Speed of Service';
       ctrl.qid = 'd';
       ctrl.submit();
      ctrl.previous();
      ctrl.firstPage();

     Test.stopTest();

  }
    static testmethod void testgctlRQSRV1() {
     Test.startTest();

         // Insert Survey Data
        Survey__c survey = TestDataDictionaryForSurvey.SurveyData();
        survey.name = 'AXS Center (GSO Counters)';
        insert survey ;
       List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='counter SurveyId', Text_Value__c = 'a1328000000qraLAAQ');
        gStg__c srv = new gStg__c(name='Counter Survey', Text_Value__c = survey.id);
        lstGStg.add(pActivation);
        lstGStg.add(srv);
        insert lstGStg;
         // Insert Survey Response
        Survey_Request__c sr = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr.Anonymous_Survey_Request__c = true;
        insert sr;
        list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='counter SurveyId', Checkbox_Value__c=false, Text_Value__c=sr.Id, Number_Value__c=0, Currency_Value__c=0));
      insert stgs;
         // Insert question 1
        Questionaire__c question1 = TestDataDictionaryForSurvey.QuestionaireData('How satisfied are you?', 'Rating', survey );
        question1.Question_Number__c  = '1';
        insert question1;

        // Insert question 2
        Questionaire__c question2 = TestDataDictionaryForSurvey.QuestionaireData('What do you dislike the most?', 'MultiSelect', survey );
        question2.Question_Number__c  = '2';
        insert question2;

        // Insert question 3
        Questionaire__c question3 = TestDataDictionaryForSurvey.QuestionaireData('What did you like the most?', 'MultiSelect', survey );
        question3.Question_Number__c  = '3';
        insert question3;
      ApexPages.currentPage().getParameters().put('a', '2');
       gctlRQSRV ctrl = new gctlRQSRV();

       ctrl.anwser2 = 'Speed of Service';
       ctrl.qid = 's';
       ctrl.submit();
      ctrl.previous();
      ctrl.firstPage();

     Test.stopTest();

  }

}