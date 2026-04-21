//  Copyright (c) 2010, David Van Puyvelde, Sales Engineering, Salesforce.com Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

public with sharing class FormController {

    public Web_Form__c form {get;set;}
    public List<Form_Field__c> fields {get;set;}
    //Map that holds all the object names and tokens in your org
    Map<String, Schema.SObjectType> gd;
    //List with just these tokens
    public List<SObjectType> tokens = new List<SObjectType>();
    public SObject sobjectInstance {get;set;} //will hold the instance of the object that will be saved

    //CONSTRUCTOR
    public FormController() {
        //get the url parameter indication the web form Id
        String formId = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('id'));
        if (formId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This page required a Web Form id url parameter.'));
            return;
        }
        try {
        //get the form and it's fields
        form = [select Id, Name, Object_Name__c, Return_URL__c,
                Background_Color__c, Text_Color__c, Save_Button_Text__c, Title__c from Web_Form__c where Id = :formId];

        fields = [Select f.Name, f.Id, f.Type__c, f.Label__c,
                    f.Text_Value__c, f.Date_Value__c, f.Email_Value__c, f.DateTime_Value__c, f.Boolean_Value__c,
                    f.Currency_Value__c, f.Number_Value__c, f.Percent_Value__c, f.Phone_Value__c, f.Text_Area_Value__c,
                    f.Text_Area_Long_Value__c, f.URL_Value__c, f.Picklist_Value__c, f.PicklistEntries__c, f.Width__c, f.Required__c, f.Hidden__c
                    From Form_Field__c f where f.Web_Form__c = :formId order by f.Order__c];
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not retrieve the form.'));
            return;
        }

        //get a full list of all objecttokens in this org
        gd = Schema.getGlobalDescribe();
        //get a reference to the token related to the object referenced in the webform
        SObjectType sot = gd.get(form.Object_Name__c);
        //instantiate an object of this type
        try {
            sobjectInstance = sot.newSObject();
        }
        //this happens when the object's API name doesn't exist, or has been removed from the profile access settings
        //Typically when admin's don't setup the webform editor correctly
        catch (System.NullPointerException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The system can not create a form for : '+ form.Object_Name__c));
        }
        //override the field value with whatever has been passed in the URL
        Map<String, String> params = System.currentPageReference().getParameters();
        //create a map of the fields
        Map<String, Form_Field__c> mfields = new Map<String, Form_Field__c>();
        for (Form_Field__c f:fields) {
            mfields.put(f.Name, f);
        }
        for (String p:params.keySet()) {
            //check if the passed param matches one of the field names
            Form_Field__c f = mfields.get(p);
            //if a field matches, make it's value what was passed as value in the url parameter
            if (f != null) {
                WebformUtil.setFormFieldValue(f, params.get(f.Name));
            }
        }
    }

    //fill the object with the correct field values and save it
    public PageReference saveObject() {
        try {
            System.debug('Entering Save method');
            //Boolean to keep validation status
            Boolean valid = true;
            //loop over all the displayed fields
            for (Form_Field__c ff:fields) {
                String fieldtype = ff.Type__c;
                String name = ff.Name;
                Object value = WebformUtil.getFormFieldValue(ff);
                //Check if required fields have values
                if ((value == null) && ff.Required__c  ) {
                    ApexPages.Message reqMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ff.Label__c + ' is a required field.');
                    ApexPages.addMessage(reqMsg);
                    valid = false;
                }
                if (value != null) sobjectInstance.put(name, value);
            }
            if (valid) {
                System.debug('Ready to save sobject instance');
                insert sobjectInstance;
                String retUrl = form.Return_URL__c;
                //accept url's with or without http://
                if (!form.Return_URL__c.startsWith('http://')) retUrl = 'http://'+form.Return_URL__c; //this slightly different from the component version that takes sites into account
                PageReference pr =  new PageReference(retUrl);
                return pr;
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            System.debug('Exception occured '+ex.getMessage());
        }
        return null;
    }

    //** TEST METHODS **//

    

}