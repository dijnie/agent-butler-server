package xiaozhi.modules.knowledge.service;

import java.util.List;

/**
 * Domain orchestration service of the knowledge base module
 * Handles complex business flows spanning KnowledgeBase and KnowledgeFiles, fully resolving circular dependencies between services.
 */
public interface KnowledgeManagerService {

    /**
     * Cascade delete a knowledge base and all its documents (including local DB and RAGFlow remote data)
     * 
     * @param datasetId Knowledge base ID
     */
    void deleteDatasetWithFiles(String datasetId);

    /**
     * Batch cascade delete knowledge bases
     * 
     * @param datasetIds Knowledge base ID list
     */
    void batchDeleteDatasetsWithFiles(List<String> datasetIds);
}
