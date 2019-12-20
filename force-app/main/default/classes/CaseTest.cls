/** 
* File Name: CaseTest.apxc
* Description: performs tests on all potential scenarios around the Case sObject
* @author:     Ted Pincas
* Modification Log 
* ========================================================================================= 
* Ver Date          Author              Modification 
* --- ----------    ------              -------------
* 01 13/12/2019     Ted Pincas          Creation of Test Class and its scenarios
* =========================================================================================
**/
@isTest
public class CaseTest {
    static Integer numParentCases = 5;
    static Integer numchildrenCases = 10;
    // -------------------------------------------------------------------------------------
    // Method's name: insertParentCaseWithStatusDiffClosed();  
    // Description: Create a new Parent Case with a Status different to Closed.
    //              Note: a Parent Case is a Case where ParentID = NULL.      
    // Expected Result: Children Cases # = 0;     
    // --------------------------------------------------------------------------------------
    @isTest static void insertParentCaseWithStatusDiffClosed(){
        List<Case> parentCasesLst = DataFactoryForTests.createParentCase(numParentCases);
        insert parentCasesLst;
        List<Case> queriedCases = [SELECT Children_Cases_Num__c
                                   FROM Case];
        Boolean allZero = true;
        for(Case eachCase : queriedCases){
            if(eachCase.Children_Cases_Num__c != 0){
                allZero = false;
            }
        }
        System.assertEquals(true, allZero, 'Assertion error: Case.Children_Cases_Num__c different to zero');
    } 
    // -------------------------------------------------------------------------------------
    // Method's name: insertParentWithChildrenCasesWithStatusDiffClosed();  
    // Description: create various Children Cases(with their related Parent Cases) with a Status != Closed.
    //              Note: a Child Case is a Case ParentID != NULL      
    // Expected Result: on the Parent Case, the Children Cases # = childrenCasesLst;
    // --------------------------------------------------------------------------------------    
    @isTest static void insertParentWithChildrenCasesWithStatusDiffClosed(){
        List<Case> parentCasesLst = DataFactoryForTests.createParentCase(numParentCases);
        insert parentCasesLst;
        Set<Id> parentId = (new Map <Id,Case>(parentCasesLst)).keySet();
        Map<Id, List<Case>> parentWithChildrenCasesMap = 
            DataFactoryForTests.addChildrenToParentCasesWithStatusDiffClosed(parentId,numchildrenCases);
        List<Case> childrenCasesLst = New List<Case>(); 
        for(List<Case> eachLstOfCase : parentWithChildrenCasesMap.values()){
            childrenCasesLst.addAll(eachLstOfCase);
        }
        insert childrenCasesLst;
        List<Case> queriedParentCasesLst = [SELECT Children_Cases_Num__c, (SELECT Id FROM Cases)
                                            FROM Case
                                            WHERE Id IN:parentWithChildrenCasesMap.KeySet()];
        
        Boolean correctChildrenCasesNumber = true;
        if(queriedParentCasesLst.size() != numParentCases){
            correctChildrenCasesNumber = false; 
        } else {
            for(Case eachQueriedParent : queriedParentCasesLst){
                if(eachQueriedParent.Children_Cases_Num__c != eachQueriedParent.Cases.size()){
                    correctChildrenCasesNumber = false;
                }
            }
        }
        
        System.assertEquals(true, correctChildrenCasesNumber, 'Assertion error: Case.Children_Cases_Num__c is NOT correct');
    } 
    // -------------------------------------------------------------------------------------
    // Method's name: updateParentCaseWithStatusEqualClosed();  
    // Description: Step 1: create a new Parent Case with a Status different to Closed.
    //              Step 2: create various Children Cases with a Status different to Closed.
    //              Step 3: update the Parent Status to be equal to Closed                   
    // Expected Result: all children Cases automatically change their Status to Close 
    // --------------------------------------------------------------------------------------    
    @isTest static void updateParentCaseWithStatusEqualClosed(){
        List<Case> parentCasesLst = DataFactoryForTests.createParentCase(numParentCases);
        List<Case> parentCasesToBeUpdatedLst = new List<Case>();
        insert parentCasesLst;
        Set<Id> parentId = (new Map <Id,Case>(parentCasesLst)).keySet();
        Map<Id, List<Case>> parentWithChildrenCasesMap = 
            DataFactoryForTests.addChildrenToParentCasesWithStatusDiffClosed(parentId,numchildrenCases);
        
        List<Case> childrenCasesLst = New List<Case>(); 
        for(List<Case> eachLstOfCase : parentWithChildrenCasesMap.values()){
            childrenCasesLst.addAll(eachLstOfCase);
        }
        insert childrenCasesLst;
        for(Case eachParentCase : parentCasesLst){
            eachParentCase.Status = 'Closed';
            parentCasesToBeUpdatedLst.add(eachParentCase);
        }
        update parentCasesToBeUpdatedLst;
        List<Case> queriedChildrenUpdatedCases = [SELECT IsClosed
                                                  FROM Case
                                                  WHERE ParentId IN:parentWithChildrenCasesMap.KeySet()];
        
        Boolean childCaseIsClosed = true;
        for(Case eachUpdatedChildCase : queriedChildrenUpdatedCases){
            if(!eachUpdatedChildCase.IsClosed){
                
                childCaseIsClosed = false;   
            }
        }
        System.assertEquals(true, childCaseIsClosed, 'Assertion error: Children Cases are NOT all Closed- They should');  
    }
    
    
    // -------------------------------------------------------------------------------------
    // Method's name: deleteChildCases();  
    // Description:  Step 1: create a new Parent Case with a Status different to Closed.
    //               Step 2: create various Children Cases with a Status different to Closed.
    //               Step 3: delete various Children Cases.   
    // Expected Result: on the Parent Case, the Children Cases # = n; (n = num remaining children)     
    // ------------------------------------------------------------------------------------- 
    @isTest static void deleteChildCases(){
        List<Case> parentCasesLst = DataFactoryForTests.createParentCase(numParentCases);
        insert parentCasesLst;
        Set<Id> parentId = (new Map <Id,Case>(parentCasesLst)).keySet();
        Map<Id, List<Case>> parentWithChildrenCasesMap = 
            DataFactoryForTests.addChildrenToParentCasesWithStatusDiffClosed(parentId,numchildrenCases);
        System.debug('Tamaño del mapa de Padres e Hijos: '+parentWithChildrenCasesMap.size());
        // BUENA NOTICIA: Devuelve 5
        List<Case> childrenCasesLst = New List<Case>(); 
        for(List<Case> eachLstOfCase : parentWithChildrenCasesMap.values()){
            childrenCasesLst.addAll(eachLstOfCase);
        }
        insert childrenCasesLst;
        
        List<Case> childrenCasesToDelete = new List<Case>();
        for(Case eachParentCase : parentCasesLst){
            Integer r = calcRandomNumber(numchildrenCases);
            for(Integer i=0; i<r; i++){
                childrenCasesToDelete.add(eachParentCase);
            } 
        }
        List<Case> childrenCasesWithoutDuplicatesToDelete = 
            Utilities.removeDuplicatesFromList(childrenCasesToDelete);
        delete childrenCasesWithoutDuplicatesToDelete;
        
        List<Case> parentCasesAfterDeletingChildrenCases = [SELECT Id, Children_Cases_Num__c, (SELECT Id FROM Cases)
                                                            FROM Case
                                                            WHERE Id IN: parentWithChildrenCasesMap.keySet()];
        // PROBLEMA --> parentCasesAfterDeletingChildrenCases.size() = 0
        System.debug('parentCasesAfterDeletingChildrenCases.size(): '+parentCasesAfterDeletingChildrenCases.size());
        
        Boolean correctChildrenCasesNumber = true;
        if(parentCasesAfterDeletingChildrenCases.size() != numParentCases){
            correctChildrenCasesNumber = false; 
        } else {
            for(Case eachParentCaseAfterDeleting : parentCasesAfterDeletingChildrenCases){
                if(eachParentCaseAfterDeleting.Children_Cases_Num__c != eachParentCaseAfterDeleting.Cases.size()){
                    correctChildrenCasesNumber = false;
                }
            }  
        }
        System.assertEquals(true, 
                            correctChildrenCasesNumber,
                            'Assertion error: Case.Children_Cases_Num__c is NOT correct after deleting children');
    }  
    /*
// -------------------------------------------------------------------------------------
// Method's name: cloneParentCaseWithChildren();  
// Description: Clone/Create a new Parent Case where field Children Case # = n.  
// Expected Result: Children Cases # = 0;(because the resulting/cloned Parent Case will
//                  not have Children records)     
// -------------------------------------------------------------------------------------
@isTest static void cloneParentCaseWithChildren(){
Map<Id, List<Case>> parentAndChildrenCasesMap = DataFactoryForTests.addChildrenToParentCasesWithStatusDiffClosed(numParentCases,numchildrenCases);
List<Case> parentCases = [SELECT Id, (SELECT Id FROM Cases)
FROM Case
WHERE Id IN: parentAndChildrenCasesMap.keySet()];
List<Case> clonedParentCases = Utilities.cloneRecords(parentCases);
System.debug('List of cloned parent Cases'+clonedParentCases);
for(Case eachClonedCase : clonedParentCases){
eachClonedCase.Children_Cases_Num__c = 0; 
}
insert clonedParentCases;
List<Case> qryClonedCasesLst = [SELECT Id
FROM Case
WHERE Id IN:clonedParentCases];

Boolean correctChildrenCasesNumber = true;
for(Case eachUpdatedClonedCase : qryClonedCasesLst){
correctChildrenCasesNumber = (eachUpdatedClonedCase.Children_Cases_Num__c != 0)? false : true;
}
System.assertEquals(true, correctChildrenCasesNumber, 'Assertion error: the field eachUpdatedClonedCase.Children_Cases_Num__c should be zero');
}
*/
    
    // -------------------------------------------------------------------------------------
    // Method's name: calcRandomNumber();  
    // Description:  calculates a random number within the range of numchildrenCases  
    // -------------------------------------------------------------------------------------
    static Integer calcRandomNumber(Integer numchildrenCases){
        Integer randomNumber = Integer.valueOf((Math.random() * numchildrenCases));
        return randomNumber;
    }
    
}