package xiaozhi.modules.agent.service;


import java.util.List;

/**
 * Service for agent MCP access points
 *
 * @author zjy
 */
public interface AgentMcpAccessPointService {
    /**
     * Get the MCP access point address of an agent
     * @param id Agent ID
     * @return mcp access point address
     */
   String getAgentMcpAccessAddress(String id);

    /**
     * Get the list of tools available at the agent's MCP access point
     * @param id Agent ID
     * @return Tool list
     */
   List<String> getAgentMcpToolsList(String id);
}
