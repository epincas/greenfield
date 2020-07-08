/**
* File Name:   CaseProcesses.apxc
* Description: It verifies a set of criteria on each inbound Case and invokes different
*              processes depending on such criteria.
* @author:     Ted Pincas

* Modification Log
* =========================================================================================
* Ver Date          Author              Modification
* --- ----------    ------              -------------
* 01 22/11/2019     Ted Pincas          Creation
* =========================================================================================
**/
public class CaseProcesses {
    // -------------------------------------------------------------------------------------
    // Method's name: calcNumChildrenOnParentCase
    // Description:   Calculates the number of Children on a Parent Case; (additional info)
    //    @params       [Set<Id> childrenCasesParentIDsToCount]
    //    @invoked from [CaseTriggerHandler.afterInsert()]
    //    @return       [void (It only verifies the new size of the list of children Cases)]
    // --------------------------------------------------------------------------------------
    public static void calcNumChildrenOnParentCase(Set<Id> parentIDs){
        List<Case> parentCasesToUpdateWithCounter = new List<Case>();
        List<Case> parentCases = [SELECT Id,
                                  (SELECT Id FROM Cases)
                                  FROM Case
                                  WHERE Id IN:parentIDs];
        for(Case eachParent : parentCases){
            eachParent.Children_Cases_Num__c = eachParent.Cases.size();
            parentCasesToUpdateWithCounter.add(eachParent);
        }
        update parentCasesToUpdateWithCounter;
    }

    // -------------------------------------------------------------------------------------
    // Method's name: closeAllChildren
    // Description:   Closes all the Children Cases of each Parent Case if that Parent Case's
    //                status is 'Closed';
    //    @params       [the Id of the Parent Case]
    //    @invoked from [CaseTriggerHandler.afterUpdate()]
    //    @return       [void (it only updates the childrend Cases by changing the Status to Closed)]
    // --------------------------------------------------------------------------------------
    public static void closeChildren(Set<Id> closedParentCasesIDs){
        List<Case> closedChildrenCasesToBeUpdated = new List<Case>();
        List<Case> childrenToBeClosed = [SELECT Status
                                         FROM Case
                                         WHERE ParentId IN:closedParentCasesIDs AND
                                         IsClosed != true];
        if(!childrenToBeClosed.isEmpty()){
            For(Case eachChildCaseToBeClosed : childrenToBeClosed){
                eachChildCaseToBeClosed.Status = 'Closed';
                closedChildrenCasesToBeUpdated.add(eachChildCaseToBeClosed);
            }
        }
        update closedChildrenCasesToBeUpdated;
    }
}