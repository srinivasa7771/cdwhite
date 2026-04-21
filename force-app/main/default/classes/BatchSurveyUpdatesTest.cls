@istest private class BatchSurveyUpdatesTest{

    static TestMethod void TestBatchSurveyUpdates() {

        // Insert Survey Data
        Survey__c survey = TestDataDictionaryForSurvey.SurveyData();
        insert survey ;
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='counter SurveyId', Text_Value__c = 'a1328000000qraLAAQ');
        gStg__c srv = new gStg__c(name='Counter Survey', Text_Value__c = survey.id);
        lstGStg.add(pActivation);
        lstGStg.add(srv);
        insert lstGStg;

        // Insert Survey Response
        List<Survey_Request__c> srLst = new List<Survey_Request__c>();
        Survey_Request__c sr = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr.Anonymous_Survey_Request__c = true;
        srLst.add(sr);
        Survey_Request__c sr1 = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr1.Anonymous_Survey_Request__c = false;
        sr1.Unique_Response_Id__c = 'R_1552212628223_5';
        srLst.add(sr1);
        insert srLst;

        // Insert question 1
        Questionaire__c question1 = TestDataDictionaryForSurvey.QuestionaireData('Overall, how satisfied were you with your experience for this request?', 'Rating', survey );
        question1.Question_Number__c  = '1';
        insert question1;

        // Insert question 2
        Questionaire__c question2 = TestDataDictionaryForSurvey.QuestionaireData('What do you dislike the most?', 'MultiSelect', survey );
        question2.Question_Number__c  = '2';
        insert question2;

         // Insert question 3
        Questionaire__c question3 = TestDataDictionaryForSurvey.QuestionaireData('Any additional feedback you would like to share with us?', 'Short Answer', survey );
        question3.Question_Number__c  = '3';
        insert question3;

        boolean blV;String sV;
        grqH.rBefore=grqH.rBefore;
        grqH.rAfter=grqH.rAfter;
        grqH.iBefore=grqH.iBefore;
        grqH.iAfter=grqH.iAfter;
        testData.init();
        gStg__c cs = new gStg__c();
        cs.name = 'slaExpiry';
        cs.Number_Value__c = 50;
        insert cs;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.suvtp__c = 'After Payment';
        update s;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        sr.Request__c = r.id;
        update sr;
        g_Req__c r1=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        sr1.Request__c = r1.id;
        update sr1;
        Answer__c objAnswer = new Answer__c(    Completion_Time__c = system.now(), value__c = 5, Questionaire__c= question2.id, Survey_Request__c = sr.id);
        insert objAnswer;
        Test.startTest();
        BatchSurveyUpdates objBSU = new BatchSurveyUpdates('afterpayment');
        Database.executeBatch(objBSU);
        Test.stopTest();
    }

    static testMethod void ScheduleSurveyUpdateTest() {
        ScheduleSurveyUpdate obj = new ScheduleSurveyUpdate();
       String sch1 = '0 0 * * * ? *';
        String jobID1 = System.schedule('ScheduleSurveyUpdate', sch1, obj);
    }
}