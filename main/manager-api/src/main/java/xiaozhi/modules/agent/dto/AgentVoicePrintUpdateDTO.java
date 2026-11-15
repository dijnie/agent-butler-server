package xiaozhi.modules.agent.dto;

import lombok.Data;

/**
 * DTO for modifying an agent voiceprint
 *
 * @author zjy
 */
@Data
public class AgentVoicePrintUpdateDTO {
    /**
     * Agent voiceprint ID
     */
    private String id;
    /**
     * Audio file ID
     */
    private String audioId;
    /**
     * Name of the person the voiceprint comes from
     */
    private String sourceName;
    /**
     * Description of the person the voiceprint comes from
     */
    private String introduce;
}
