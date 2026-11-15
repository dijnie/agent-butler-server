package xiaozhi.modules.model.dto;

import java.io.Serializable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Timbre information")
public class VoiceDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    @Schema(description = "Timbre ID")
    private String id;

    @Schema(description = "Timbre name")
    private String name;

    @Schema(description = "Audio playback URL")
    private String voiceDemo;
    
    @Schema(description = "Language type")
    private String languages;
    
    @Schema(description = "Whether it is a cloned timbre")
    private Boolean isClone;

    // Add a two-argument constructor to keep backward compatibility
    public VoiceDTO(String id, String name) {
        this.id = id;
        this.name = name;
        this.voiceDemo = null;
        this.languages = null;
        this.isClone = false; // Not a cloned timbre by default
    }
    
    // Add a three-argument constructor for ordinary timbres
    public VoiceDTO(String id, String name, String voiceDemo) {
        this.id = id;
        this.name = name;
        this.voiceDemo = voiceDemo;
        this.languages = null;
        this.isClone = false;
    }

}