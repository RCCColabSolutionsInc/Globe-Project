CREATE OR REPLACE PROCEDURE dswtdir1_dbo.ztcustom_copy_sourcemappings_backupfirst_thencarefully()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Did you update from and to in the view ztCustom_Copy_SourceMappings */
    /* did you take a backup? Select * into ttTargetFieldMapping_BKP_20200709_0310AM from ttTargetFieldMapping */
    /* did you check Select * from ztCustom_Copy_SourceMappings */
    /* comment the where clause in this proc before executing this proc */
    /* for samples, check queries below: */
    /* select SourceDatabaseObjectID */
    /* , TargetFieldMappingID, TargetFieldGroupID, TargetFieldID, Action, DefaultValue, SourceTable, SourceField, RulesComment, Comment, AutoGenerateRule, MappingStatus, MappedBy, MappedOn, RuleStatus, RuleSQL, ApprovedBy, ApprovedOn, boaStatus, AddedBy, AddedOn, ChangedBy, ChangedOn, AddedVia, ChangedVia, AEExecutionID, AETargetDataSourceID, AEFormStatementOnly, SourceDatabaseObjectID, TargetRelationshipID, RemediationValue, RemediationComment, AEActionID, CreatedOn, CreatedBy, RejectedOn, RejectedBy, SubmittedOn, SubmittedBy, FieldGroup, FieldGroupID, ExternalSourceID, WhereClauseOverride */
    /* from ttTargetFieldMapping */
    /* where ( SourceDatabaseObjectID = 'e789db23-58c4-49a9-ba38-59f572065487'  or SourceDatabaseObjectID = '3dd0a857-6d9c-4cad-b65a-8a41c519798a' or SourceDatabaseObjectID  = 'fbe6e2a4-d46e-422b-9d84-f737b6303c7d' ) */
    /* AND  (SourceField = 'TXT50' or   SourceField = 'KTOPL' ) order by TargetFieldID */
    /* select SourceDatabaseObjectID */
    /* , TargetFieldMappingID, TargetFieldGroupID, TargetFieldID, Action, DefaultValue, SourceTable, SourceField, RulesComment, Comment, AutoGenerateRule, MappingStatus, MappedBy, MappedOn, RuleStatus, RuleSQL, ApprovedBy, ApprovedOn, boaStatus, AddedBy, AddedOn, ChangedBy, ChangedOn, AddedVia, ChangedVia, AEExecutionID, AETargetDataSourceID, AEFormStatementOnly, SourceDatabaseObjectID, TargetRelationshipID, RemediationValue, RemediationComment, AEActionID, CreatedOn, CreatedBy, RejectedOn, RejectedBy, SubmittedOn, SubmittedBy, FieldGroup, FieldGroupID, ExternalSourceID, WhereClauseOverride */
    /* from ttTargetFieldMapping_BKP_20200709_0310AM */
    /* where ( SourceDatabaseObjectID = 'e789db23-58c4-49a9-ba38-59f572065487'  or SourceDatabaseObjectID = '3dd0a857-6d9c-4cad-b65a-8a41c519798a' or SourceDatabaseObjectID  = 'fbe6e2a4-d46e-422b-9d84-f737b6303c7d' ) */
    /* AND  (SourceField = 'TXT50' or   SourceField = 'KTOPL' ) order by TargetFieldID */
    UPDATE dswtdir1_dbo.ztcustom_copy_sourcemappings
    SET action = actionnew, instruction = instructionnew, defaultvalue = defaultvaluenew, sourcetable = sourcetablenew, sourcefield = sourcefieldnew, rulescomment = rulescommentnew, comment = commentnew, autogeneraterule = autogeneraterulenew, mappingstatus = mappingstatusnew, mappedby = mappedbynew, mappedon = mappedonnew, rulestatus = rulestatusnew, rulesql = rulesqlnew, approvedby = approvedbynew, approvedon = approvedonnew, boastatus = boastatusnew, addedby = addedbynew, addedon = addedonnew, changedby = changedbynew, changedon = changedonnew, addedvia = addedvianew, changedvia = changedvianew, aeexecutionid = aeexecutionidnew, aetargetdatasourceid = aetargetdatasourceidnew, aeformstatementonly = aeformstatementonlynew, remediationvalue = remediationvaluenew, remediationcomment = remediationcommentnew, createdon = createdonnew, createdby = createdbynew, rejectedon = rejectedonnew, rejectedby = rejectedbynew, submittedon = submittedonnew, submittedby = submittedbynew, externalsourceid = externalsourceidnew, whereclauseoverride = whereclauseoverride
        WHERE 1 = 2;
END;
$procedure$
