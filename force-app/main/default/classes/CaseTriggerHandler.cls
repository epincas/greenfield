/** 
* File Name: CaseTriggerHandler.apxc
* Description: Depending on the type of trigger, this class will redirect the process to 
*			   different classes supporting specific processes.
* @author:     Ted Pincas
* Modification Log 
* ========================================================================================= 
* Ver Date          Author              Modification 
* --- ----------    ------              -------------
* 01 16/11/2019     Ted Pincas          Creation 
* =========================================================================================
**/
public class CaseTriggerHandler {
    public static boolean isFirstTime = true;
    final List<Case> triggerNewLst;
    final Map<Id,Case> triggerOldMap;
    Set<Id> parentIDsToRecalculate = new Set<Id>();
    Set<Id> parentIDsClosed = new Set<Id>();
    Set<Id> parentIDsWithoutChildren = new Set<Id>();
    
    // CONSTRUCTOR -------------------------------------------------------------------------
    public CaseTriggerHandler(List<Case> triggerNewLst, Map<Id,Case> triggerOldMap){
        this.triggerNewLst = triggerNewLst;
        this.triggerOldMap = triggerOldMap;
    }
    
    // -------------------------------------------------------------------------------------
    // Method's name: afterInsert  
    // Description: evaluates inserted records  
    // -------------------------------------------------------------------------------------   
    public void afterInsert(){
        addParentIdToSetForChildrenCount(triggerNewLst);
        CaseProcesses.calcNumChildrenOnParentCase(this.parentIDsToRecalculate);    
    }
    
    // -------------------------------------------------------------------------------------
    // Method's name: afterUpdate  
    // Description:   evaluates if: Parent is Closed AND/OR if Children's Parent is changed                        
    // -------------------------------------------------------------------------------------- 
    public void afterUpdate(){
        for (Case eachCase : triggerNewLst){
            typeOfUpdate(eachCase);
        }
    }
    
    // -------------------------------------------------------------------------------------
    // Method's name: afterDelete  
    // Description:   
    // -------------------------------------------------------------------------------------- 
    public void afterDelete(){
        addParentIdToSetForChildrenCount(triggerOldMap.values());
        CaseProcesses.calcNumChildrenOnParentCase(this.parentIDsToRecalculate); 
    }
    
    // -------------------------------------------------------------------------------------
    // Method's name:   addParentIdToSetForCounting
    // Description:     It prepares a Set of Case.ParentIds so as to eventually pass this list
    //                  to another Class.method that will count the number of Children Cases
    // -------------------------------------------------------------------------------------- 
    private void addParentIdToSetForChildrenCount(List<Case> iteratableList){
        for(Case eachInboundCase : iteratableList){
            if (eachInboundCase.ParentId != null){
                this.parentIDsToRecalculate.add(eachInboundCase.ParentId);
            }
            else if (eachInboundCase.Cases.Size()== 0){
            }
        }
    }
    
    // -------------------------------------------------------------------------------------
    // Method's name: typeOfUpdate  
    // Description:   identify different types of update to re-direct to a different process.                        
    // -------------------------------------------------------------------------------------
    private void typeOfUpdate(Case eachCase){
        // Parent Status has changed to "Closed"?
        if(triggerOldMap.get(eachCase.Id).IsClosed != eachCase.IsClosed &&
           eachCase.IsClosed == true &&
           eachCase.ParentId == null){
               parentIDsClosed.add(eachCase.Id);
           } 
        // Has the Child's parent changed?
        else if(triggerOldMap.get(eachCase.Id).ParentId != eachCase.ParentId &&
                eachCase.ParentId != null){
                    parentIDsToRecalculate.add(triggerOldMap.get(eachCase.Id).ParentId);
                    parentIDsToRecalculate.add(eachCase.ParentId);
                }
        if(!parentIDsClosed.isEmpty()){
            CaseProcesses.closeChildren(parentIDsClosed);
        }
        if (!parentIDsToRecalculate.isEmpty()){
            CaseProcesses.calcNumChildrenOnParentCase(this.parentIDsToRecalculate);  
        }
    }
}