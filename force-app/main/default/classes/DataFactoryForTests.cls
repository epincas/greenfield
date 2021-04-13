/**
* File Name: DataFactoryForTests.apxc
* Description: Data factory to be consumed by any test class
* @author:      Ted Pincas
* Modification Log
* =========================================================================================
* Ver Date          Author              Modification
* --- ----------    ------              -------------
* 01 15/06/2019     Ted Pincas          Creation
* =========================================================================================
**/
public class DataFactoryForTests {
    // ------------------------------------------------------------------------------------
    // Method's name: createParentCasesTestRecords
    // Description: creates parent cases (without a ParentId)
    //    @params       [Number of Parent Cases to be created for tests]
    //    @invoked from [CaseTest.apexc]
    //    @return       [List of parent Cases]
    // ------------------------------------------------------------------------------------
    public static List<Case> createParentCase(Integer numParentCases){
        List<Case> parentCasesLst = new List<Case>();
        for (Integer i = 1; i < numParentCases + 1; i++){
            Case myParentCase = new Case(Status='New',
                                         Origin='Phone',
                                         Subject='Test Parent Case #: '+i);
            parentCasesLst.add(myParentCase);
        }
        return parentCasesLst;
    }

    // ------------------------------------------------------------------------------------
    // Method's name: addChildrenToParentCasesWithStatusDiffClosed
    // Description: creates children cases (Cases WITH a ParentId)
    //    @params       [Number of Parent and Children Cases to be created for tests]
    //    @invoked from [CaseTest.apexc]
    //    @return       [Void] A list of Child Cases will be inserted
    // ------------------------------------------------------------------------------------
    public static Map<Id, List<Case>> addChildrenToParentCasesWithStatusDiffClosed(Set<Id> parentIds, Integer numChildrenCases){
        Map<Id, List<Case>> parentAndChildrenCasesMap = new Map<Id, List<Case>>();
        for(Id eachParentCaseId : parentIds){
            List<Case> childrenCasesLst = new List<Case>();
            for(Integer i = 1; i < numChildrenCases + 1; i++){
                Case eachChildCase = new Case(Status='New',
                                              Origin='Phone',
                                              ParentId = eachParentCaseId,
                                              Subject='Test Child Case #: '+ i);
                childrenCasesLst.add(eachChildCase);
            }
            parentAndChildrenCasesMap.put(eachParentCaseId, childrenCasesLst);
        }
        return parentAndChildrenCasesMap;
    }
}