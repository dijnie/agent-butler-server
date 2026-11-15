package xiaozhi.modules.agent.vo;

import java.util.Date;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import xiaozhi.modules.agent.dto.AgentSnapshotDataDTO;

@Data
@Schema(description = "Agent configuration snapshot")
public class AgentSnapshotVO {
    private String id;
    private String agentId;
    @Schema(description = "Owner user ID, the owner of the agent this snapshot belongs to")
    private Long userId;
    private Integer versionNo;
    private List<String> changedFields;
    private List<String> fieldOrder;
    private String source;
    @Schema(description = "Restore source snapshot ID, only set on versions produced by a restore")
    private String restoreFromSnapshotId;
    @Schema(description = "Restore source version number, only set on versions produced by a restore")
    private Integer restoreFromVersionNo;
    @Schema(description = "Creator, the operator who triggered this snapshot write")
    private Long creator;
    private Date createdAt;
    private AgentSnapshotDataDTO snapshotData;
    private AgentSnapshotDataDTO afterSnapshotData;
    @Schema(description = "Redacted current configuration for the restore preview, only set by the detail API")
    private AgentSnapshotDataDTO currentSnapshotData;
    @Schema(description = "Fingerprint of the current configuration state for the restore preview, only set by the detail API")
    private String currentStateToken;
}
