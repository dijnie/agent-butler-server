package xiaozhi.modules.agent.service;

/**
 * Agent chat history summary service interface
 */
public interface AgentChatSummaryService {

    /**
     * Generate a chat history summary by session ID and save it to the agent memory
     * 
     * @param sessionId Session ID
     * @return Save result
     */
    boolean generateAndSaveChatSummary(String sessionId);

    /**
     * Generate a chat title by session ID and save it
     *
     * @param sessionId Session ID
     * @return Whether it succeeded
     */
    boolean generateAndSaveChatTitle(String sessionId);
}