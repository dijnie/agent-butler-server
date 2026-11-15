package xiaozhi.modules.agent.service;

import java.util.List;

import xiaozhi.modules.agent.dto.AgentVoicePrintSaveDTO;
import xiaozhi.modules.agent.dto.AgentVoicePrintUpdateDTO;
import xiaozhi.modules.agent.vo.AgentVoicePrintVO;

/**
 * Service for agent voiceprints
 *
 * @author zjy
 */
public interface AgentVoicePrintService {
    /**
     * Add a new voiceprint to an agent
     *
     * @param dto Data for saving the agent voiceprint
     * @return T:success, F: failure
     */
    boolean insert(AgentVoicePrintSaveDTO dto);

    /**
     * Delete the specified voiceprint of an agent
     *
     * @param userId       ID of the currently logged-in user
     * @param voicePrintId Voiceprint ID
     * @return Whether it succeeded, T: success, F: failure
     */
    boolean delete(Long userId, String voicePrintId);

    /**
     * Get all voiceprint data of the given agent
     *
     * @param userId  ID of the currently logged-in user
     * @param agentId Agent ID
     * @return Collection of voiceprint data
     */
    List<AgentVoicePrintVO> list(Long userId, String agentId);

    /**
     * Update the specified voiceprint data of an agent
     *
     * @param userId ID of the currently logged-in user
     * @param dto    Voiceprint data to modify
     * @return Whether it succeeded, T: success, F: failure
     */
    boolean update(Long userId, AgentVoicePrintUpdateDTO dto);

}
