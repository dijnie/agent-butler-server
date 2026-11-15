package xiaozhi.modules.knowledge.rag;

import java.util.List;
import java.util.Map;

import xiaozhi.modules.knowledge.dto.dataset.DatasetDTO;

import xiaozhi.common.page.PageData;
import xiaozhi.modules.knowledge.dto.KnowledgeFilesDTO;
import xiaozhi.modules.knowledge.dto.document.DocumentDTO;
import xiaozhi.modules.knowledge.dto.document.ChunkDTO;
import xiaozhi.modules.knowledge.dto.document.RetrievalDTO;
import java.util.function.Consumer;

/**
 * Abstract base class for knowledge base API adapters
 * Defines the common knowledge base operation interface and supports multiple backend API implementations
 */
public abstract class KnowledgeBaseAdapter {

        /**
         * Get the adapter type identifier
         * 
         * @return Adapter type (e.g. ragflow, milvus, pinecone)
         */
        public abstract String getAdapterType();

        /**
         * Initialize the adapter configuration
         * 
         * @param config Configuration parameters
         */
        public abstract void initialize(Map<String, Object> config);

        /**
         * Validate whether the configuration is valid
         * 
         * @param config Configuration parameters
         * @return Validation result
         */
        public abstract boolean validateConfig(Map<String, Object> config);

        /**
         * Query the document list with pagination
         * 
         * @param datasetId   Knowledge base ID
         * @param queryParams Query parameters
         * @param page        Page number
         * @param limit       Page size
         * @return Paged data
         */
        public abstract PageData<KnowledgeFilesDTO> getDocumentList(String datasetId,
                        DocumentDTO.ListReq req);

        /**
         * Get document details by document ID
         * 
         * @param datasetId  Knowledge base ID
         * @param documentId Document ID
         * @return Document details (strongly typed InfoVO)
         */
        public abstract DocumentDTO.InfoVO getDocumentById(String datasetId, String documentId);

        /**
         * Upload a document to a knowledge base
         * 
         * @param req Upload request parameters
         * @return Uploaded document information
         */
        public abstract KnowledgeFilesDTO uploadDocument(DocumentDTO.UploadReq req);

        /**
         * Query the document list by status with pagination
         * 
         * @param datasetId Knowledge base ID
         * @param status    Document parsing status
         * @param page      Page number
         * @param limit     Page size
         * @return Paged data
         */
        public abstract PageData<KnowledgeFilesDTO> getDocumentListByStatus(String datasetId,
                        Integer status,
                        Integer page,
                        Integer limit);

        /**
         * Delete documents (supports batch deletion)
         * 
         * @param datasetId Knowledge base ID
         * @param req       Request object containing the document ID list
         */
        public abstract void deleteDocument(String datasetId, DocumentDTO.BatchIdReq req);

        /**
         * Parse documents (chunking)
         * 
         * @param datasetId   Knowledge base ID
         * @param documentIds Document ID list
         * @return Parse result
         */
        public abstract boolean parseDocuments(String datasetId, List<String> documentIds);

        /**
         * List the chunks of a given document
         * 
         * @param datasetId  Knowledge base ID
         * @param documentId Document ID
         * @param req        List request parameters (pagination, keywords, etc.)
         * @return Chunk list VO
         */
        public abstract ChunkDTO.ListVO listChunks(String datasetId,
                        String documentId,
                        ChunkDTO.ListReq req);

        /**
         * Retrieval test - retrieve relevant chunks from the knowledge base
         * 
         * @param req Retrieval test request parameters
         * @return Retrieval test result
         */
        public abstract RetrievalDTO.ResultVO retrievalTest(
                        RetrievalDTO.TestReq req);

        /**
         * Test the connection
         * 
         * @return Connection test result
         */
        public abstract boolean testConnection();

        /**
         * Get adapter status information
         * 
         * @return Status information
         */
        public abstract Map<String, Object> getStatus();

        /**
         * Get the supported configuration parameters
         * 
         * @return Description of the configuration parameters
         */
        public abstract Map<String, Object> getSupportedConfig();

        /**
         * Get the default configuration
         * 
         * @return Default configuration
         */
        public abstract Map<String, Object> getDefaultConfig();

        /**
         * Create a dataset
         * 
         * @param req Creation parameters
         * @return Dataset details
         */
        public abstract DatasetDTO.InfoVO createDataset(DatasetDTO.CreateReq req);

        /**
         * Update a dataset
         * 
         * @param datasetId Dataset ID
         * @param req       Update parameters
         * @return Dataset details
         */
        public abstract DatasetDTO.InfoVO updateDataset(String datasetId, DatasetDTO.UpdateReq req);

        /**
         * Delete datasets
         * 
         * @param req Delete request parameters (including the ID list)
         * @return Batch operation result
         */
        public abstract DatasetDTO.BatchOperationVO deleteDataset(DatasetDTO.BatchIdReq req);

        /**
         * Get the document count of a dataset
         *
         * @param datasetId Dataset ID
         * @return Document count
         */
        public abstract Integer getDocumentCount(String datasetId);

        /**
         * Get the full dataset information (name, description, document count, etc.)
         * Used to detect whether it was deleted on the RAGFlow side and to sync name/description changes
         *
         * @param datasetId Dataset ID
         * @return Dataset details, or null if it does not exist on the RAGFlow side
         */
        public abstract DatasetDTO.InfoVO getDatasetInfo(String datasetId);

        /**
         * Send a streaming request (SSE)
         * 
         * @param endpoint API endpoint
         * @param body     Request body
         * @param onData   Data callback
         */
        public abstract void postStream(String endpoint, Object body, Consumer<String> onData);

        /**
         * SearchBot question
         *
         * @param config RAG configuration
         * @param body   Request body
         * @param onData Data callback
         * @return Response object
         */
        public abstract Object postSearchBotAsk(Map<String, Object> config, Object body,
                        Consumer<String> onData);

        /**
         * AgentBot conversation
         *
         * @param config  RAG configuration
         * @param agentId Agent ID
         * @param body    Request body
         * @param onData  Data callback
         */
        public abstract void postAgentBotCompletion(Map<String, Object> config, String agentId, Object body,
                        Consumer<String> onData);
}