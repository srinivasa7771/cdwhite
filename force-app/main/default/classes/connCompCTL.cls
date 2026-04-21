public with sharing class connCompCTL {   
    public Issue_Tracker__c issue{ get; set; }  
    public string createdDateDay{ get; set; }
    public string createdDateMonth{ get; set; }
    public string createdDateYear{ get; set; }
    public string createdDateHour{ get; set; }
    public string createdDateMinute{ get; set; }
    public string assignDateDay{ get; set; }
    public string assignDateMonth{ get; set; }
    public string assignDateYear{ get; set; }
    public string assignDateHour{ get; set; }
    public string assignDateMinute{ get; set; }
    public string closeDateDay{ get; set; }
    public string closeDateMonth{ get; set; }
    public string closeDateYear{ get; set; }
    public string closeDateHour{ get; set; }    
    public string closeDateMinute{ get; set; }    
    
    public connCompCTL(ApexPages.StandardController stdController) {
        issue = (Issue_Tracker__c)stdController.getRecord();
        parseDates();
    }

    public void parseDates() {
        createdDateDay=String.valueOf(issue.CreatedDate.day());
        createdDateMonth=String.valueOf(Integer.valueOf(issue.CreatedDate.month())-1);
        createdDateYear=String.valueOf(issue.CreatedDate.year());
        createdDateHour=String.valueOf(issue.CreatedDate.hour());
        createdDateMinute=String.valueOf(issue.CreatedDate.minute());
        
        if(issue.Assignment_Date__c<>null){
            assignDateDay=String.valueOf(issue.Assignment_Date__c.day());
            assignDateMonth=String.valueOf(Integer.valueOf(issue.Assignment_Date__c.month())-1);
            assignDateYear=String.valueOf(issue.Assignment_Date__c.year());
            assignDateHour=String.valueOf(issue.Assignment_Date__c.hour());
            assignDateMinute=String.valueOf(issue.Assignment_Date__c.minute());                       
        }
        else{
            assignDateDay=String.valueOf(issue.CreatedDate.day());
            assignDateMonth=String.valueOf(Integer.valueOf(issue.CreatedDate.month())-1);
            assignDateYear=String.valueOf(issue.CreatedDate.year());
            assignDateHour=String.valueOf(issue.CreatedDate.hour());
            assignDateMinute=String.valueOf(issue.CreatedDate.minute());
        }
        
        if(issue.Status__c=='In Process'){
            closeDateDay=String.valueOf(System.now().day());
            closeDateMonth=String.valueOf(Integer.valueOf(System.now().month())-1);
            closeDateYear=String.valueOf(System.now().year());
            closeDateHour=String.valueOf(System.now().hour());
            closeDateMinute=String.valueOf(System.now().minute());                        
        }
        else{        
            closeDateDay=String.valueOf(issue.Closure_Date__c.day());
            closeDateMonth=String.valueOf(Integer.valueOf(issue.Closure_Date__c.month())-1);
            closeDateYear=String.valueOf(issue.Closure_Date__c.year());
            closeDateHour=String.valueOf(issue.Closure_Date__c.hour());            
            closeDateMinute=String.valueOf(issue.Closure_Date__c.minute());                        
        }
    }


}